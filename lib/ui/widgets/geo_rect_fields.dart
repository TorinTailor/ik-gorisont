import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/geo_rect.dart';

class GeoRectController {
  final south = TextEditingController();
  final north = TextEditingController();
  final west = TextEditingController();
  final east = TextEditingController();

  List<TextEditingController> get _all => [south, north, west, east];

  bool get isEmpty => _all.every((c) => c.text.trim().isEmpty);

  static double? parse(String text) =>
      double.tryParse(text.trim().replaceAll(',', '.'));

  /// Вызывать только после успешной валидации.
  GeoRect? read() {
    if (isEmpty) return null;
    return GeoRect(
      south: parse(south.text)!,
      north: parse(north.text)!,
      west: parse(west.text)!,
      east: parse(east.text)!,
    );
  }

  void clear() {
    for (final c in _all) {
      c.clear();
    }
  }

  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
  }
}

/// Четыре поля координат прямоугольника. Если [optional] = true, поля можно
/// оставить пустыми все сразу.
class GeoRectFields extends StatelessWidget {
  final GeoRectController controller;
  final bool optional;
  final bool enabled;

  const GeoRectFields({
    super.key,
    required this.controller,
    this.optional = false,
    this.enabled = true,
  });

  String? _validate(String? value, {required bool isLat}) {
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      if (!optional) return 'Введите значение';
      return controller.isEmpty
          ? null
          : 'Заполните все четыре поля координат или очистите их все';
    }
    final number = GeoRectController.parse(text);
    if (number == null) {
      return 'Введите число, например 55.75 (дробная часть после точки)';
    }
    if (isLat && (number < -90 || number > 90)) {
      return 'Широта должна быть от −90 до 90';
    }
    if (!isLat && (number < -180 || number > 180)) {
      return 'Долгота должна быть от −180 до 180';
    }
    return null;
  }

  String? _validateNorth(String? value) {
    final base = _validate(value, isLat: true);
    if (base != null) return base;
    final n = GeoRectController.parse(value ?? '');
    final s = GeoRectController.parse(controller.south.text);
    if (n != null && s != null && n < s) {
      return 'Северная широта не может быть меньше южной';
    }
    return null;
  }

  String? _validateEast(String? value) {
    final base = _validate(value, isLat: false);
    if (base != null) return base;
    final e = GeoRectController.parse(value ?? '');
    final w = GeoRectController.parse(controller.west.text);
    if (e != null && w != null && e < w) {
      return 'Восточная долгота не может быть меньше западной';
    }
    return null;
  }

  Widget _field(
    TextEditingController c,
    String label,
    String? Function(String?) validator,
  ) {
    return Expanded(
      child: TextFormField(
        controller: c,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]'))],
        decoration: InputDecoration(labelText: label),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field(
              controller.south,
              'Южная широта',
              (v) => _validate(v, isLat: true),
            ),
            const SizedBox(width: 12),
            _field(controller.north, 'Северная широта', _validateNorth),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field(
              controller.west,
              'Западная долгота',
              (v) => _validate(v, isLat: false),
            ),
            const SizedBox(width: 12),
            _field(controller.east, 'Восточная долгота', _validateEast),
          ],
        ),
      ],
    );
  }
}
