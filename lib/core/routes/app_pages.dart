import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/core/routes/middlewares/onboarding_middleware.dart';
import 'package:safe_to_spend/features/root/bindings/root_shell_binding.dart';
import 'package:safe_to_spend/features/root/pages/root_shell_page.dart';
import 'package:safe_to_spend/features/splash/bindings/splash_binding.dart';
import 'package:safe_to_spend/features/splash/pages/splash_page.dart';

/// Central route table configuration for GetX navigation.
abstract class AppPages {
  AppPages._();

  static const String initial = AppRoutes.splash;

  /// Fallback route handling unrecognized URLs and deep links safely.
  static final GetPage<dynamic> unknownRoute = GetPage<dynamic>(
    name: '/notfound',
    page: () => const RootShellPage(),
    binding: RootShellBinding(),
    middlewares: [OnboardingMiddleware()],
  );

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
    ),

    GetPage<dynamic>(
      name: AppRoutes.onboardingWelcome,
      page: () => const _PlaceholderScreen(title: 'Welcome'),
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboardingIncome,
      page: () => const _PlaceholderScreen(title: 'Onboarding Income'),
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboardingBills,
      page: () => const _PlaceholderScreen(title: 'Onboarding Bills'),
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboardingResult,
      page: () => const _PlaceholderScreen(title: 'Onboarding Result'),
    ),
    GetPage<dynamic>(
      name: AppRoutes.root,
      page: () => const RootShellPage(),
      binding: RootShellBinding(),
      middlewares: [OnboardingMiddleware()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.today,
      page: () => const RootShellPage(),
      binding: RootShellBinding(),
      middlewares: [OnboardingMiddleware()],
    ),

    GetPage<dynamic>(
      name: AppRoutes.settings,
      page: () => const _PlaceholderScreen(title: 'Settings'),
      middlewares: [OnboardingMiddleware()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.paywall,
      page: () => const _PlaceholderScreen(title: 'Paywall'),
    ),
    GetPage<dynamic>(
      name: AppRoutes.expenseEdit,
      page: () => const _PlaceholderScreen(title: 'Expense Edit'),
      middlewares: [OnboardingMiddleware()],
    ),
  ];
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
