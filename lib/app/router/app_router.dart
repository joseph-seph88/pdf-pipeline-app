import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_pipeline_app/core/di/core_provider.dart';
import 'package:pdf_pipeline_app/core/session/auth_state.dart';
import 'router_path.dart';
import 'router_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: RouterPath.splash,
    redirect: (context, state) {
      final authStatus = ref.read(authStateProvider).status;
      final loc = state.matchedLocation;

      const publicRoutes = [
        RouterPath.splash,
        RouterPath.login,
        RouterPath.signUp,
      ];
      final isPublic = publicRoutes.any((p) => loc == p);

      if (isPublic) return null;

      if (authStatus == AuthStatus.unauthenticated ||
          authStatus == AuthStatus.tokenExpired) {
        return RouterPath.login;
      }

      return null;
    },
    routes: [...AppRoutes.entryRoutes, ...AppRoutes.shellRoutes],
  );

  ref.listen(authStateProvider, (_, __) => router.refresh());

  return router;
});
