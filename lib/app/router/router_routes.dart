import 'package:go_router/go_router.dart';
import 'package:pdf_pipeline_app/app/router/router_path.dart';
import 'package:pdf_pipeline_app/features/auth/presentation/views/pages/login_page.dart';
import 'package:pdf_pipeline_app/features/auth/presentation/views/pages/sign_up_page.dart';
import 'package:pdf_pipeline_app/features/my_files/presentation/views/pages/my_files_page.dart';
import 'package:pdf_pipeline_app/features/pdf_convert/presentation/views/pages/pdf_convert_page.dart';
import 'package:pdf_pipeline_app/shared/pages/shell_page.dart';
import 'package:pdf_pipeline_app/shared/pages/splash_page.dart';

class AppRoutes {
  static final entryRoutes = <RouteBase>[
    GoRoute(
      path: RouterPath.splash,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SplashPage()),
    ),
    GoRoute(
      path: RouterPath.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouterPath.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
  ];

  static final shellRoutes = <RouteBase>[
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) =>
          NoTransitionPage(child: ShellPage(navigationShell: navigationShell)),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterPath.pdfConvert,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: PdfConvertPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterPath.myFiles,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: MyFilesPage()),
            ),
          ],
        ),
      ],
    ),
  ];
}
