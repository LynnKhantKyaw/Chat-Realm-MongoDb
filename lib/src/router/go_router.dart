import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test_realm/src/feature/auth/presentation/login.dart';
import 'package:test_realm/src/feature/chat/presentation/chat.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final username = ref.watch(userNameProvider);
  return GoRouter(
    navigatorKey: navigatorKey,
    redirect: (context, state) =>
        username == null || username.isEmpty ? '/' : '/chat',
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          name: 'login',
          pageBuilder: (context, state) => pageBuilder(
              context: context, state: state, child: const Login())),
      GoRoute(
          path: '/chat',
          name: 'chat',
          pageBuilder: (context, state) =>
              pageBuilder(context: context, state: state, child: const Chat()))
    ],
  );
});

pageBuilder(
    {required BuildContext context,
    required GoRouterState state,
    required Widget child}) {
  return CupertinoPage<void>(
    key: state.pageKey,
    child: child,
  );
}
