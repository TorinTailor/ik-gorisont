import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'data/auth_repository.dart';
import 'firebase_options.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _authRepository = AuthRepository();
  late final AuthBloc _authBloc = AuthBloc(_authRepository)
    ..add(AuthStarted());

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: BlocProvider.value(
        value: _authBloc,
        child: MaterialApp(
          title: 'Спутниковые снимки',
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) => switch (state) {
              AuthInitial() => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              AuthUnauthenticated() => const LoginScreen(),
              AuthAuthenticated() => const HomeScreen(),
            },
          ),
        ),
      ),
    );
  }
}
