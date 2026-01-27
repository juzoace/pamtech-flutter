import 'package:autotech/core/theme/theme.dart';
import 'package:autotech/features/auth/domain/usecases/register_usecase.dart';
// import 'package:autotech/features/auth/domain/usecases/login_usecase.dart';
import 'package:autotech/features/auth/presentation/pages/onboarding.dart';
import 'package:autotech/features/auth/presentation/providers/auth_provider.dart';
import 'package:autotech/init_dependencies.dart' hide serviceLocator;
import 'package:autotech/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'di_container.dart' as di;
import 'features/auth/domain/usecases/login_usecase.dart' show LoginUseCase;
import 'package:autotech/features/auth/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection (get_it)
  await initDependencies();

  // Lock to portrait mode
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
        
        // ChangeNotifierProvider<AuthProvider>(
        //   create: (_) => AuthProvider(
        //     loginUseCase: serviceLocator<LoginUseCase>(),
        //     registerUseCase: serviceLocator<RegisterUseCase>(),
        //   ),
        // ),
        
         ChangeNotifierProvider(create: (context) => di.sl<AuthController>()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Autotech',
        // theme: AppTheme.lightTheme,      // or darkTheme
        home: const AuthCheckScreen(), // checks token and decides screen
      ),
    );
  }
}

// Screen that checks if user is logged in (via token)
class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    // Check token on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      // Token exists → user is logged in → go to Home (or dashboard)
      // For now, we go to a placeholder Home screen
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      print('No auth token found, navigating to Onboarding');
      // No token → show Onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
