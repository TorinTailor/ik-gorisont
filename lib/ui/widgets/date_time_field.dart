import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _format = DateFormat('dd.MM.yyyy HH:mm');

String formatDateTime(DateTime value) => _format.format(value);

/// Поле выбора даты и времени (с точностью до минут).
/// Значение хранится внутри FormField, поэтому его сбрасывает Form.reset().
class DateTimeField extends StatelessWidget {
  final String label;
  final ValueChanged<DateTime?> onChanged;
  final String? Function(DateTime? value)? validator;
  final bool enabled;
  final bool clearable;

  const DateTimeField({
    super.key,
    required this.label,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.clearable = false,
  });

  Future<void> _pick(FormFieldState<DateTime> state) async {
    final context = state.context;
    final now = DateTime.now();
    final initial = state.value ?? now;

    final date = await showDatePicker(
      context: context,
      initialDate: DateUtils.dateOnly(initial),
      firstDate: DateTime(1990),
      lastDate: DateUtils.dateOnly(now),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !context.mounted) return;

    final value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    state.didChange(value);
    onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        final value = state.value;
        return InkWell(
          onTap: enabled ? () => _pick(state) : null,
          child: InputDecorator(
            isEmpty: value == null,
            decoration: InputDecoration(
              labelText: label,
              errorText: state.errorText,
              suffixIcon: value != null && clearable && enabled
                  ? IconButton(
                      tooltip: 'Очистить',
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        state.didChange(null);
                        onChanged(null);
                      },
                    )
                  : const Icon(Icons.calendar_today_outlined, size: 20),
            ),
            child: Text(value == null ? '' : formatDateTime(value)),
          ),
        );
      },
    );
  }
}
