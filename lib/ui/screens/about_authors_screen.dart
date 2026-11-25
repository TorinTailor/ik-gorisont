import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/content_blocks.dart';

class AboutAuthorsScreen extends StatelessWidget {
  const AboutAuthorsScreen({super.key});

  static const _members = [
    _Member(
      'Бровко Лилиана Вячеславовна',
      'Лидер команды',
      avatar: 'assets/avatar_1.png',
    ),
    _Member(
      'Романова Юлия Сергеевна',
      'Аналитик',
      avatar: 'assets/avatar_2.png',
    ),
    _Member(
      'Гриценко Светлана Юрьевна',
      'Генератор идей',
      avatar: 'assets/avatar_3.png',
    ),
    _Member(
      'Сапожинец Ярослав Евгеньевич',
      'Спикер',
      note: 'Активный участник научных конференций',
      avatar: 'assets/avatar_4.png',
    ),
    _Member(
      'Арефьева Валерия Викторовна',
      'Мастер презентации',
      avatar: 'assets/avatar_5.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Об авторах')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: AppLogo(size: 88)),
                  const SectionTitle('О проекте'),
                  const BodyText(
                    'Платформа «ИК-Горизонт» разрабатывается командой '
                    'студентов в рамках акселератора «Платформа НТИ».',
                  ),
                  const SectionTitle('Команда'),
                  for (final member in _members) ...[
                    _MemberCard(member: member),
                    const SizedBox(height: 10),
                  ],
                  const SectionTitle('Опыт команды'),
                  const BodyText(
                    'Все члены команды — студенты 4 курса АмГУ. Принимали '
                    'участие в «ТехноИмпульс Амур» АмГУ 2025 г. с проектом '
                    '«Роса-Куб», где мы разрабатывали систему раскрытия '
                    'солнечных панелей на CubeSat.',
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Member {
  final String name;
  final String role;
  final String? note;
  final String avatar;

  const _Member(this.name, this.role, {this.note, required this.avatar});
}

class _MemberCard extends StatelessWidget {
  final _Member member;

  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Image.asset(
            member.avatar,
            width: 84,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox(width: 84, height: 73),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(member.role),
                if (member.note != null)
                  Text(
                    member.note!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5F5F5F),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
