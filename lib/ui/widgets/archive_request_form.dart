import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/requests/requests_bloc.dart';
import '../../bloc/requests/requests_event.dart';
import '../../bloc/requests/requests_state.dart';
import '../../domain/entities/archive_request.dart';
import 'date_time_field.dart';
import 'geo_rect_fields.dart';

const _hintStyle = TextStyle(fontSize: 13, color: Color(0xFF5F5F5F));

/// Режим 2: запрос к открытым базам спутниковых снимков (заглушка).
class ArchiveRequestForm extends StatefulWidget {
  const ArchiveRequestForm({super.key});

  @override
  State<ArchiveRequestForm> createState() => _ArchiveRequestFormState();
}

class _ArchiveRequestFormState extends State<ArchiveRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _geo = GeoRectController();

  DateTime? _from;
  DateTime? _to;

  @override
  void dispose() {
    _descriptionController.dispose();
    _geo.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final coordinates = _geo.read();
    final from = _from;
    final to = _to;
    if (coordinates == null || from == null || to == null) return;

    context.read<RequestsBloc>().add(
      ArchiveRequestSubmitted(
        ArchiveRequest(
          description: _descriptionController.text.trim(),
          coordinates: coordinates,
          periodFrom: from,
          periodTo: to,
        ),
      ),
    );
  }

  void _reset() {
    _descriptionController.clear();
    _geo.clear();
    _from = null;
    _to = null;
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestsBloc, RequestsState>(
      listenWhen: (previous, current) =>
          previous.notice != current.notice &&
          current.notice?.successFor == RequestKind.archive,
      listener: (context, state) => _reset(),
      builder: (context, state) {
        final busy = state.isSubmitting;
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Запрос к открытым базам спутниковых снимков. '
                'Сейчас запрос только сохраняется в вашем списке '
                'и никуда не отправляется.',
                style: _hintStyle,
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
                'Область (прямоугольник, градусы)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              GeoRectFields(controller: _geo, enabled: !busy),
              const SizedBox(height: 24),
              const Text(
                'Период',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              DateTimeField(
                label: 'Начало периода',
                enabled: !busy,
                onChanged: (v) => _from = v,
                validator: (v) => v == null ? 'Укажите начало периода' : null,
              ),
              const SizedBox(height: 16),
              DateTimeField(
                label: 'Конец периода',
                enabled: !busy,
                onChanged: (v) => _to = v,
                validator: (v) {
                  if (v == null) return 'Укажите конец периода';
                  final from = _from;
                  if (from != null && v.isBefore(from)) {
                    return 'Конец периода не может быть раньше начала';
                  }
                  return null;
                },
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
