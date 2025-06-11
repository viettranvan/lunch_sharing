import 'package:go_router/go_router.dart';
import 'package:lunch_sharing/pages/index.dart';

final appRouter = _AppRouter();

class _AppRouter {
  _AppRouter._internal();
  static final _singleton = _AppRouter._internal();
  factory _AppRouter() => _singleton;
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/add-record',
        builder: (context, state) => const AddRecordPage(),
      ),
      GoRoute(
        path: '/mark-paid',
        builder: (context, state) => const MarkPaidPage(),
      ),
    ],
  );
}
