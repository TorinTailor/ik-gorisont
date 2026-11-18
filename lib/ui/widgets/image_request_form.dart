import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/requests/requests_bloc.dart';
import '../../bloc/requests/requests_event.dart';
import '../../bloc/requests/requests_state.dart';
import '../../domain/entities/image_request.dart';
import '../theme.dart';
import 'date_time_field.dart';
import 'geo_rect_fields.dart';

const _maxFileBytes = 20 * 1024 * 1024;
const _hintStyle = TextStyle(fontSize: 13, color: Color(0xFF5F5F5F));

/// Режим 1: загрузка снимка (файл остаётся в памяти браузера).
class ImageRequestForm extends StatefulWidget {
  const ImageRequestForm({super.key});

  @override
  State<ImageRequestForm> createState() => _ImageRequestFormState();
}

class _ImageRequestFormState extends State<ImageRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _geo = GeoRectController();

  PlatformFile? _file;
  Uint8List? _bytes;
  String? _fileError;
  DateTime? _shotAt;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _geo.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'tif', 'tiff'],
    );
    if (file == null || !mounted) return;

    final Uint8List bytes;
    try {
      bytes = await file.readAsBytes();
    } catch (_) {
      if (!mounted) return;
      setState(() => _fileError = 'Не удалось прочитать файл. Выберите другой');
      return;
    }
    if (!mounted) return;

    if (bytes.length > _maxFileBytes) {
      setState(() => _fileError = 'Файл больше 20 МБ. Выберите файл меньше');
      return;
    }
    setState(() {
      _file = file;
      _bytes = bytes;
      _fileError = null;
    });
  }

  void _submit() {
    final valid = _formKey.currentState!.validate();
    setState(() {
      _fileError = _file == null
          ? 'Выберите файл снимка (JPG, PNG или TIFF)'
          : _fileError;
    });
    final file = _file;
    if (!valid || file == null) return;

    final title = _titleController.text.trim();
    context.read<RequestsBloc>().add(
      ImageRequestSubmitted(
        ImageRequest(
          title: title.isEmpty ? file.name : title,
          fileName: file.name,
          description: _descriptionController.text.trim(),
          coordinates: _geo.read(),
          shotAt: _shotAt,
        ),
      ),
    );
  }

  void _reset() {
    _titleController.clear();
    _descriptionController.clear();
    _geo.clear();
    setState(() {
      _file = null;
      _bytes = null;
      _fileError = null;
      _shotAt = null;
    });
    _formKey.currentState?.reset();
  }

  Widget _buildUploadArea(bool busy) {
    final file = _file;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: _fileError != null ? const Color(0xFFB3261E) : kBorder,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: file == null
          ? Column(
              children: [
                const Icon(Icons.satellite_alt_outlined, size: 40, color: kAccent),
                const SizedBox(height: 8),
                const Text('Файл снимка не выбран'),
                const SizedBox(height: 4),
                const Text('JPG, PNG или TIFF, до 20 МБ', style: _hintStyle),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: busy ? null : _pickFile,
                  child: const Text('Выбрать файл'),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 220,
                  child: Image.memory(
                    _bytes!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Text(
                        'Предпросмотр для этого формата недоступен',
                        style: _hintStyle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${file.name} · ${((_bytes?.length ?? 0) / 1024 / 1024).toStringAsFixed(1)} МБ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Снимок остаётся на вашем устройстве и никуда не отправляется',
                  style: _hintStyle,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: busy ? null : _pickFile,
                      child: const Text('Заменить'),
                    ),
                    TextButton(
                      onPressed: busy
                          ? null
                          : () => setState(() {
                              _file = null;
                              _bytes = null;
                            }),
                      child: const Text('Убрать'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestsBloc, RequestsState>(
      listenWhen: (previous, current) =>
          previous.notice != current.notice &&
          current.notice?.successFor == RequestKind.image,
      listener: (context, state) => _reset(),
      builder: (context, state) {
        final busy = state.isSubmitting;
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUploadArea(busy),
              if (_fileError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 12),
                  child: Text(
                    _fileError!,
                    style: const TextStyle(
                      color: Color(0xFFB3261E),
                      fontSize: 13,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                enabled: !busy,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Название снимка',
                  helperText:
                      'Если оставить пустым, будет использовано имя файла',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                enabled: !busy,
                minLines: 3,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Описание запроса',
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v ?? '').trim().isEmpty
                    ? 'Введите описание запроса'
                    : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Дополнительно (необязательно)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              const Text(
                'Область съёмки: прямоугольник в градусах. '
                'Если не заполнять, в списке будет «пользователь не внёс данные»',
                style: _hintStyle,
              ),
              const SizedBox(height: 12),
              GeoRectFields(controller: _geo, optional: true, enabled: !busy),
              const SizedBox(height: 16),
              DateTimeField(
                label: 'Дата и время съёмки',
                enabled: !busy,
                clearable: true,
                onChanged: (v) => _shotAt = v,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: busy ? null : _submit,
                child: busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Отправить запрос'),
              ),
            ],
          ),
        );
      },
    );
  }
}
