import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/account/account_bloc.dart';
import '../../bloc/account/account_event.dart';
import '../../bloc/account/account_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../domain/entities/archive_request.dart';
import '../../domain/entities/image_request.dart';
import '../theme.dart';
import '../widgets/date_time_field.dart';

const _noData = 'пользователь не внёс данные';
const _hintStyle = TextStyle(fontSize: 13, color: Color(0xFF5F5F5F));

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Аккаунт')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: _ProfileCard(
                    nickname: user?.nickname ?? '',
                    email: user?.email ?? '',
                  ),
                ),
                Expanded(
                  child: BlocBuilder<AccountBloc, AccountState>(
                    builder: (context, state) => switch (state) {
                      AccountLoadInProgress() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      AccountLoadFailure(:final message) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(message, textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(160, 44),
                                ),
                                onPressed: () => context
                                    .read<AccountBloc>()
                                    .add(AccountStarted()),
                                child: const Text('Обновить'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AccountLoadSuccess() => _RequestsTabs(state: state),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String nickname;
  final String email;

  const _ProfileCard({required this.nickname, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nickname.isEmpty ? 'Без имени' : nickname,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(email, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _RequestsTabs extends StatelessWidget {
  final AccountLoadSuccess state;

  const _RequestsTabs({required this.state});

  @override
  Widget build(BuildContext context) {
    final images = state.imageRequests;
    final archives = state.archiveRequests;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: kAccent,
            unselectedLabelColor: const Color(0xFF5F5F5F),
            indicatorColor: kAccent,
            tabs: [
              Tab(text: 'Снимки (${images.length})'),
              Tab(text: 'Открытые базы (${archives.length})'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _RequestList(
                  count: images.length,
                  itemBuilder: (_, i) => _ImageRequestCard(request: images[i]),
                ),
                _RequestList(
                  count: archives.length,
                  itemBuilder: (_, i) =>
                      _ArchiveRequestCard(request: archives[i]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestList extends StatelessWidget {
  final int count;
  final IndexedWidgetBuilder itemBuilder;

  const _RequestList({required this.count, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return const Center(child: Text('Пока нет запросов'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: itemBuilder,
    );
  }
}

class _CardShell extends StatelessWidget {
  final String title;
  final List<Widget> rows;

  const _CardShell({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...rows,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: _hintStyle)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

String _created(DateTime? value) =>
    value == null ? 'сохраняется…' : formatDateTime(value);

class _ImageRequestCard extends StatelessWidget {
  final ImageRequest request;

  const _ImageRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: request.title,
      rows: [
        _Row('Файл', request.fileName),
        _Row('Описание', request.description),
        _Row('Область', request.coordinates?.label ?? _noData),
        _Row(
          'Дата съёмки',
          request.shotAt == null ? _noData : formatDateTime(request.shotAt!),
        ),
        _Row('Запрос создан', _created(request.createdAt)),
      ],
    );
  }
}

class _ArchiveRequestCard extends StatelessWidget {
  final ArchiveRequest request;

  const _ArchiveRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Запрос от ${_created(request.createdAt)}',
      rows: [
        _Row('Описание', request.description),
        _Row('Область', request.coordinates.label),
        _Row(
          'Период',
          'с ${formatDateTime(request.periodFrom)} '
              'по ${formatDateTime(request.periodTo)}',
        ),
      ],
    );
  }
}
