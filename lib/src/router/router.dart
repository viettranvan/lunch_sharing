import 'package:go_router/go_router.dart';
import 'package:lunch_sharing/pages/index.dart';
import 'package:lunch_sharing/src/pages/add_invoice/add_invoice_page.dart';
import 'package:lunch_sharing/src/pages/home/home_page.dart';
import 'package:lunch_sharing/src/pages/manage_user/manage_user_page.dart';

part 'route_name.dart';

final appRouter = _AppRouter();

class _AppRouter {
  _AppRouter._internal();
  static final _singleton = _AppRouter._internal();
  factory _AppRouter() => _singleton;
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: RouterName.home.path,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouterName.addInvoice.path,
        builder: (context, state) => const AddInvoicePage(),
      ),
      GoRoute(
        path: RouterName.manageUser.path,
        builder: (context, state) => const ManageUserPage(),
      ),
      GoRoute(
        path: RouterName.markPaid.path,
        builder: (context, state) => const MarkPaidPage(),
      ),
    ],
  );
}
