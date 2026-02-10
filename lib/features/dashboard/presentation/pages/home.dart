import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/features/dashboard/presentation/pages/request.dart';
import 'package:autotech/features/settings/presentation/pages/settings.dart';
import 'package:autotech/features/repairs/presentation/pages/repairs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Autotech Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Pages for bottom navigation
  final List<Widget> _pages = [
    const HomeContent(),
    const Repairs(),
    const Requests(),
    const Settings(),
  ];

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Main content
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12), // soft gray shadow
              blurRadius: 12, // softness
              spreadRadius: 2, // slight spread
              offset: const Offset(0, -6), // shadow above the bar (top edge)
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF134CA2),
          unselectedItemColor: Colors.grey,
          backgroundColor:
              Colors.transparent, // important – let Container handle color
          elevation: 0, // disable built-in elevation
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage('assets/images/home.png'),
                size: 26,
                color: _selectedIndex == 0
                    ? const Color(0xFF134CA2)
                    : Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage('assets/images/repairs.png'),
                size: 26,
                color: _selectedIndex == 1
                    ? const Color(0xFF134CA2)
                    : Colors.grey,
              ),
              label: 'My Repairs',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage('assets/images/request.png'),
                size: 26,
                color: _selectedIndex == 2
                    ? const Color(0xFF134CA2)
                    : Colors.grey,
              ),
              label: 'Request',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage('assets/images/setting.png'),
                size: 26,
                color: _selectedIndex == 3
                    ? const Color(0xFF134CA2)
                    : Colors.grey,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages (keep or replace with your real content)
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Dashboard\n(Upcoming services, reminders, etc.)'),
    );
  }
}

