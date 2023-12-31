import 'package:shipper/auth/presentation/screens/auth_guard_screen.dart';
import 'package:shipper/core/presentation/routing/navigation_transitions.dart';
import 'package:shipper/core/presentation/routing/route_paths.dart';
import 'package:shipper/core/presentation/screens/no_internet_connection_screen.dart';
import 'package:shipper/core/presentation/screens/splash_screen.dart';
import 'package:shipper/core/presentation/widgets/platform_widgets/platform_page_route.dart';
import 'package:shipper/features/home/presentation/screens/home_screen.dart';
import 'package:shipper/features/map/presentation/screens/map_screen.dart';
import 'package:shipper/features/profile/presentation/screens/profile_screen.dart';
import 'package:shipper/features/settings/presentation/screens/language_screen.dart';
import 'package:shipper/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  ///Root Navigator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //Core
      case RoutePaths.coreSplash:
        return platformPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case RoutePaths.coreNoInternet:
        final args = settings.arguments as Map?;
        return platformPageRoute(
          builder: (_) => NoInternetConnectionScreen(
            offAll: args?['offAll'],
          ),
          settings: settings,
        );

      //Auth
      case RoutePaths.authGuard:
        return NavigationFadeTransition(
          const AuthGuardScreen(),
          settings: settings,
        );

      default:
        return platformPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }

  ///Nested Navigators
  static Route<dynamic> generateHomeNestedRoute(RouteSettings settings) {
    switch (settings.name) {
      //Home
      case RoutePaths.home:
        return NavigationFadeTransition(
          const HomeScreen(),
          settings: settings,
        );

      //Map
      case RoutePaths.map:
        return platformPageRoute(
          builder: (_) => const MapScreen(),
          settings: settings,
        );

      default:
        return NavigationFadeTransition(
          const HomeScreen(),
          settings: settings,
        );
    }
  }

  static Route<dynamic> generateProfileNestedRoute(RouteSettings settings) {
    switch (settings.name) {
      //Profile
      case RoutePaths.profile:
        return platformPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );

      default:
        return platformPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );
    }
  }

  static Route<dynamic> generateSettingsNestedRoute(RouteSettings settings) {
    switch (settings.name) {
      //Settings
      case RoutePaths.settings:
        return platformPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );

      case RoutePaths.language:
        return platformPageRoute(
          builder: (_) => const LanguageScreen(),
          settings: settings,
        );

      default:
        return platformPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
    }
  }
}
