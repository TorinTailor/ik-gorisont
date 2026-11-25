import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/account/account_bloc.dart';
import '../../bloc/account/account_event.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/requests/requests_bloc.dart';
import '../../bloc/requests/requests_state.dart';
import '../../data/requests_repository.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/archive_request_form.dart';
import '../widgets/image_request_form.dart';
import 'account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RequestKind _mode = RequestKind.image;

  void _openAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AccountBloc(RequestsRepository())..add(AccountStarted()),
          child: const AccountScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestsBloc, RequestsState>(
      listenWhen: (previous, current) =>
          current.notice != null && previous.notice != current.notice,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.notice!.message)));
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('ИК-Горизонт'),
          actions: [
            IconButton(
              tooltip: 'Аккаунт',
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: _openAccount,
            ),
            TextButton(
              onPressed: () =>
                  context.read<AuthBloc>().add(AuthSignOutRequested()),
              child: const Text('Выйти'),
            ),
          ],
        ),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<RequestKind>(
                      showSelectedIcon: false,
                      expandedInsets: EdgeInsets.zero,
                      style: SegmentedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: kText,
                        selectedBackgroundColor: kAccent,
                        selectedForegroundColor: Colors.white,
                        side: const BorderSide(color: kBorder),
                      ),
                      segments: const [
                        ButtonSegment(
                          value: RequestKind.image,
                          label: Text('Загрузка снимка'),
                        ),
                        ButtonSegment(
                          value: RequestKind.archive,
                          label: Text('Открытые базы'),
                        ),
                      ],
                      selected: {_mode},
                      onSelectionChanged: (s) =>
                          setState(() => _mode = s.first),
                    ),
                    const SizedBox(height: 20),
                    IndexedStack(
                      index: _mode == RequestKind.image ? 0 : 1,
                      children: const [
                        ImageRequestForm(),
                        ArchiveRequestForm(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
