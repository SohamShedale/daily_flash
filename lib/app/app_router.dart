import 'package:daily_flash/app/app_routes.dart';
import 'package:daily_flash/features/home/screens/home_screen.dart';
import 'package:daily_flash/features/splash/screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage _platformPageBuilder<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  // Use TargetPlatform from the Theme, or check Platform.isIOS if needed for non-material roots
  final platform = Theme.of(context).platform;
  final bool isIOS = platform == TargetPlatform.iOS;

  // Define the transition duration
  const Duration transitionDuration = Duration(milliseconds: 350);

  // Use the standard platform transition (CupertinoPageTransition for iOS, FadeThroughTransition/SlideTransition for Android)
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: transitionDuration,
    reverseTransitionDuration: transitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (isIOS) {
        // iOS Native Transition: Slide in from the right
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      } else {
        // Android Native Transition (Standard Material Fade/Slide from bottom/up)
        // This simulates the behavior of MaterialPageRoute's default.
        return FadeTransition(opacity: animation, child: child);
      }
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        pageBuilder: (context, state) =>
            _platformPageBuilder(context: context, state: state, child: const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        pageBuilder: (context, state) =>
            _platformPageBuilder(context: context, state: state, child: const HomeScreen()),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Error: ${state.error}'))),
    debugLogDiagnostics: kDebugMode,
  );
});
