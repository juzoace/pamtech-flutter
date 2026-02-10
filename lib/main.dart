import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/features/auth/presentation/pages/onboarding.dart';
import 'package:autotech/features/auth/presentation/providers/auth_provider.dart';
import 'package:autotech/features/dashboard/presentation/pages/home.dart';
import 'package:autotech/features/repairs/controllers/repairs_controller.dart';
import 'package:autotech/init_dependencies.dart' hide serviceLocator;
import 'package:autotech/init_dependencies.dart';
import 'package:autotech/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'di_container.dart' as di;
import 'features/auth/domain/usecases/login_usecase.dart' show LoginUseCase;
import 'package:autotech/features/auth/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<AuthController>()),
        ChangeNotifierProvider(create: (context) => di.sl<RepairsController>())
        // add other providers here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Autotech',

        // theme: AppTheme.lightTheme,
        home: const AuthCheckScreen(),
        theme: ThemeData(
        // ── Global font family ───────────────────────────────────
        fontFamily: 'PlusJakartaSans',
        )
        // Optional: define routes if you use Navigator.pushNamed later
        // routes: { ... },
      ),
    );
  }
}

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.userLoginToken);

      print('checking token');
      print(token);

      if (token != null && token.trim().isNotEmpty) {
        // Important: Update Dio header right after app start if token exists
        final dioClient = di
            .sl<DioClient>(); // or however you access your DioClient
        dioClient.updateHeader(token, null);

        // Optional: you could also validate token here by calling a /me or /user endpoint
        // but for most apps it's fine to trust the stored token for the first navigation

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
        );
      }
    } catch (e) {
      debugPrint("Auth check error: $e");
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
