import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domus_mobile/core/theme/app_theme.dart';
import 'package:domus_mobile/screens/auth/login_screen.dart';
import 'package:domus_mobile/screens/auth/profile_setup_screen.dart';
import 'package:domus_mobile/screens/main_screen.dart';
import 'package:domus_mobile/viewmodels/auth/auth_notifier.dart';
import 'package:screen_protector/screen_protector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    // Prevent screenshots and screen recordings
    await ScreenProtector.preventScreenshotOn();

    // Protect data when app is in background (blur effect)
    await ScreenProtector.protectDataLeakageWithBlur();
  }

  runApp(
    const ProviderScope(
      child: DomusApp(),
    ),
  );
}

class DomusApp extends ConsumerWidget {
  const DomusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      title: 'Domus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _getHome(authState),
    );
  }

  Widget _getHome(AuthState authState) {
    // 1. Initial startup check
    if (authState.isInitializing) {
      return const SplashScreen();
    }

    // 2. Authenticated user
    if (authState.user != null && !authState.isNewUser) {
      return const MainScreen();
    }

    // 3. New user state (Profile setup)
    if (authState.isNewUser) {
      return const ProfileSetupScreen();
    }

    // 4. Default to Login
    return const LoginScreen();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF021B3A),
        ),
      ),
    );
  }
}
