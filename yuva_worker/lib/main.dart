import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';

import 'design_system/theme.dart';
import 'core/providers.dart';
import 'core/web_wrapper.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/navigation/main_navigation_screen.dart';
import 'features/settings/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: YuvaWorkerApp(),
    ),
  );
}

class YuvaWorkerApp extends ConsumerWidget {
  const YuvaWorkerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeCode = ref.watch(appSettingsProvider.select((settings) => settings.localeCode));

    return MaterialApp(
      title: 'Yuva Trabajador',
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration
      theme: YuvaTheme.light,
      darkTheme: YuvaTheme.dark,
      themeMode: ThemeMode.system,
      
      // Internationalization Configuration
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // Spanish (default)
        Locale('en'), // English
      ],
      locale: Locale(localeCode),
      
      // Routing Configuration with WebWrapper
      initialRoute: '/',
      routes: {
        '/': (context) => const WebWrapper(child: SplashScreen()),
        '/onboarding': (context) => const WebWrapper(child: OnboardingScreen()),
        '/auth': (context) => const WebWrapper(child: LoginScreen()),
        '/login': (context) => const WebWrapper(child: LoginScreen()),
        '/signup': (context) => const WebWrapper(child: SignUpScreen()),
        '/main': (context) => const WebWrapper(child: MainNavigationScreen()),
        '/settings': (context) => const WebWrapper(child: SettingsScreen()),
      },
    );
  }
}

