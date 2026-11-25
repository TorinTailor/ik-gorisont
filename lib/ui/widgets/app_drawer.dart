import 'package:flutter/material.dart';

import '../screens/about_authors_screen.dart';
import '../screens/about_platform_screen.dart';
import '../theme.dart';
import 'app_logo.dart';

/// Боковое меню, открывается слева по значку из трёх полосок.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _open(BuildContext context, Widget page) {
    final navigator = Navigator.of(context);
    navigator.pop(); // закрываем меню
    navigator.push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kBackground,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  AppLogo(size: 72),
                  SizedBox(height: 12),
                  Text(
                    'ИК-Горизонт',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Мониторинг чрезвычайных ситуаций',
                    style: TextStyle(fontSize: 13, color: Color(0xFF5F5F5F)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: kBorder),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('О платформе'),
              onTap: () => _open(context, const AboutPlatformScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('Об авторах'),
              onTap: () => _open(context, const AboutAuthorsScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
