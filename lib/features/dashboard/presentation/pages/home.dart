import 'package:autotech/core/theme/app_pallete.dart';
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
    const ServicesContent(),
    const BookingsContent(),
    const ProfileContent(),
  ];

  // Sidebar menu items (some overlap with bottom nav)
  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Car Document', 'icon': Icons.file_copy, 'index': 0},
    {
      'title': 'Car Management',
      'icon': Icons.directions_car_outlined,
      'index': null,
    },
    {'title': 'Payments', 'icon': Icons.payment_outlined, 'index': null},
    {'title': 'Repair history', 'icon': Icons.build_outlined, 'index': 1},
    {'title': 'FAQ', 'icon': Icons.question_mark_outlined, 'index': 2},
    
    {'title': 'Settings', 'icon': Icons.settings_outlined, 'index': null},

    // {'title': 'Logout', 'icon': Icons.logout, 'index': null},
  ];

  final List<Map<String, dynamic>> _bottomItems = [
    // {'title': 'Dashboard', 'icon': Icons.dashboard_outlined, 'index': 0},
    // {'title': 'My Vehicles', 'icon': Icons.directions_car_outlined, 'index': null},
    // {'title': 'Services', 'icon': Icons.build_outlined, 'index': 1},
    // {'title': 'Bookings', 'icon': Icons.calendar_today_outlined, 'index': 2},
    // {'title': 'Reminders', 'icon': Icons.notifications_outlined, 'index': null},
    // {'title': 'Payments', 'icon': Icons.payment_outlined, 'index': null},
    // {'title': 'Profile', 'icon': Icons.person_outline, 'index': 3},
    {'title': 'Rate Us', 'icon': Icons.star, 'index': null},
    {'title': 'Logout', 'icon': Icons.logout, 'index': null},
  ];

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onMenuItemTap(int? pageIndex) {
    if (pageIndex != null) {
      setState(() => _selectedIndex = pageIndex);
    }
    Navigator.pop(context); // close drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar with menu button
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: notifications
            },
          ),
        ],
      ),

      // drawer: Drawer(

      //   // margin: EdgeInsets.zero,
      //   backgroundColor: Colors.white,
      //   width: MediaQuery.of(context).size.width * 0.78,
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       // Drawer header
      //       DrawerHeader(
      //         margin: EdgeInsets.zero,
      //         padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      //         decoration: const BoxDecoration(color: Colors.white),
      //         child: const Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             CircleAvatar(
      //               radius: 36,
      //               backgroundColor: Colors.white,
      //               child: Icon(Icons.person, size: 40, color: Colors.blue),
      //             ),
      //             SizedBox(height: 16),
      //             Text(
      //               'Uzochukwu Nwigwe',
      //               style: TextStyle(color: Colors.black, fontSize: 20),
      //             ),
      //           ],
      //         ),
      //       ),

      //       // Menu section with single centered divider
      //       Container(
      //         color: Colors.white,
      //         child: Column(
      //           children: [
      //             // Single divider with padding (doesn't touch edges)
      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 24.0),
      //               child: Divider(
      //                 height: 1,
      //                 color: Colors.grey.shade300,
      //                 thickness: 1,
      //               ),
      //             ),

      //             // Menu items
      //             ..._menuItems.map((item) {
      //               final isSelected = item['index'] == _selectedIndex;
      //               return ListTile(
      //                 contentPadding: const EdgeInsets.symmetric(
      //                   horizontal: 24,
      //                   vertical: 4,
      //                 ),
      //                 leading: Icon(
      //                   item['icon'],
      //                   color: isSelected
      //                       ? AppPallete.primaryColor
      //                       : Colors.grey[700],
      //                 ),
      //                 title: Text(
      //                   item['title'],
      //                   style: TextStyle(
      //                     color: isSelected
      //                         ? AppPallete.primaryColor
      //                         : Colors.black87,
      //                     fontWeight: isSelected
      //                         ? FontWeight.w600
      //                         : FontWeight.normal,
      //                   ),
      //                 ),
      //                 selected: isSelected,
      //                 selectedTileColor: Colors.blue.shade50,
      //                 onTap: () => _onMenuItemTap(item['index']),
      //               );
      //             }),

      //             // Optional: second divider if you want separation before bottom items
      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 24.0),
      //               child: Divider(
      //                 height: 1,
      //                 color: Colors.grey.shade300,
      //                 thickness: 1,
      //               ),
      //             ),

      //             const SizedBox(height: 16),

      //             // Bottom items (if you have them)
      //             ..._bottomItems.map((item) {
      //               final isSelected = item['index'] == _selectedIndex;
      //               return ListTile(
      //                 contentPadding: const EdgeInsets.symmetric(
      //                   horizontal: 24,
      //                   vertical: 4,
      //                 ),
      //                 leading: Icon(
      //                   item['icon'],
      //                   color: isSelected
      //                       ? AppPallete.primaryColor
      //                       : Colors.grey[700],
      //                 ),
      //                 title: Text(
      //                   item['title'],
      //                   style: TextStyle(
      //                     color: isSelected
      //                         ? AppPallete.primaryColor
      //                         : Colors.black87,
      //                     fontWeight: isSelected
      //                         ? FontWeight.w600
      //                         : FontWeight.normal,
      //                   ),
      //                 ),
      //                 selected: isSelected,
      //                 onTap: () => _onMenuItemTap(item['index']),
      //               );
      //             }),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width * 0.78,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Custom header using Container (no default border)
            Container(
              padding: const EdgeInsets.fromLTRB(
                24,
                60,
                24,
                10,
              ), // more top padding for breathing room
              color: Colors.white,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Uzochukwu Nwigwe',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                ],
              ),
            ),

            // Single divider with padding (doesn't touch edges)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(
                height: 1,
                color: Colors.grey.shade300,
                thickness: 1,
              ),
            ),

            // Menu items
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ..._menuItems.map((item) {
                    final isSelected = item['index'] == _selectedIndex;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      leading: Icon(
                        item['icon'],
                        color: isSelected
                            ? Colors.black87

                            : AppPallete.primaryColor ,
                      ),
                      title: Text(
                        item['title'],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black87
                              : AppPallete.primaryColor,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedTileColor: AppPallete.primaryColor,
                      tileColor: Colors.white,
                      onTap: () => _onMenuItemTap(item['index']),
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: 48),

             // Single divider with padding (doesn't touch edges)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(
                height: 1,
                color: Colors.grey.shade300,
                thickness: 1,
              ),
            ),

            // Bottom items
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ..._bottomItems.map((item) {
                    final isSelected = item['index'] == _selectedIndex;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      leading: Icon(
                        item['icon'],
                        color: isSelected
                            ? Colors.black87

                            : AppPallete.primaryColor ,
                      ),
                      title: Text(
                        item['title'],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black87
                              : AppPallete.primaryColor,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedTileColor: AppPallete.primaryColor,
                      tileColor: Colors.white,
                      onTap: () => _onMenuItemTap(item['index']),
                    );
                  }),
                ],
              ),
            ),


          ],
        ),
      ),
      // Main content
      body: Stack(
        children: [
          _pages[_selectedIndex],

          // Optional: subtle overlay when drawer is open (Flutter handles it automatically via Drawer)
          // But if you want custom shadow on right side, you can use DrawerController + Listener
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Dashboard\n(Upcoming services, reminders, etc.)'),
    );
  }
}

class ServicesContent extends StatelessWidget {
  const ServicesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Services Page'));
  }
}

class BookingsContent extends StatelessWidget {
  const BookingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Bookings & History'));
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile & Settings'));
  }
}
