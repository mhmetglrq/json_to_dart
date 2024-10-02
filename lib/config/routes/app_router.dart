import 'package:go_router/go_router.dart';

import '../../features/jsonToDart/presentation/views/dashboard.dart';

class AppRouter {
  static final appRouter = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        name: "home",
        path: "/",
        builder: (context, state) => const Dashboard(),
      )
    ],
  );
}
