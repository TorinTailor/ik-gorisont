import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

/// Временная заглушка. На этапе 3 здесь появится загрузка снимка.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final nickname = state is AuthAuthenticated ? state.user.nickname : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Спутниковые снимки'),
        actions: [
          TextButton(
            onPressed: () =>
                context.read<AuthBloc>().add(AuthSignOutRequested()),
            child: const Text('Выйти'),
          ),
        ],
      ),
      body: Center(
        child: Text(
          nickname.isEmpty ? 'Вы вошли' : 'Вы вошли как $nickname',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
