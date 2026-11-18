import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/requests/requests_bloc.dart';
import 'data/auth_repository.dart';
import 'data/requests_repository.dart';
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
          locale: const Locale('ru'),
          supportedLocales: const [Locale('ru')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) => switch (state) {
              AuthInitial() => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              AuthUnauthenticated() => const LoginScreen(),
              AuthAuthenticated(:final user) => BlocProvider(
                key: ValueKey(user.uid),
                create: (_) => RequestsBloc(RequestsRepository()),
                child: const HomeScreen(),
              ),
            },
          ),
        ),
      ),
    );
  }
}
