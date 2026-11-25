import 'package:flutter/material.dart';

/// Мелкие блоки для информационных экранов.
class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class BodyText extends StatelessWidget {
  final String text;

  const BodyText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 16, height: 1.45));
  }
}

class BulletItem extends StatelessWidget {
  final String? lead;
  final String text;

  const BulletItem({super.key, this.lead, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 16, height: 1.45)),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  if (lead != null)
                    TextSpan(
                      text: '$lead ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  TextSpan(text: text),
                ],
              ),
              style: const TextStyle(fontSize: 16, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
