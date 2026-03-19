import 'package:autotech/core/common/widgets/custom_alert.dart';
import 'package:autotech/core/theme/app_pallete.dart';
import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/features/auth/presentation/pages/login.dart';
import 'package:autotech/features/profile/controllers/profile_controller.dart';
// import 'package:autotech/features/settings/presentation/pages/faqs.dart';
import 'package:autotech/features/settings/presentation/pages/help_support.dart';
import 'package:autotech/features/settings/presentation/pages/notifications.dart';
import 'package:autotech/features/settings/presentation/pages/payment.dart';
import 'package:autotech/features/settings/presentation/pages/personal_info.dart';
import 'package:autotech/features/settings/presentation/pages/report_problem.dart';
import 'package:autotech/features/settings/presentation/pages/security.dart';
import 'package:autotech/features/settings/presentation/pages/terms_policies.dart';
import 'package:autotech/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  const Settings({super.key, this.dioClient, this.sharedPreferences});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    // Fetch profile when the settings page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserProfile();
    });
  }

  fetchUserProfile() async {
    print('Trying to fetch user profile');
    try {
      final profile = Provider.of<ProfileController>(context, listen: false);
      await profile.fetchProfile();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, child) {
        // controller.profile.name;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 3, // subtle but visible
            shadowColor: Colors.black.withOpacity(0.2),
            surfaceTintColor: const Color.fromARGB(0, 251, 250, 250),
            scrolledUnderElevation: 3,
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  // SizedBox(onst SizedBox(width: 24),: 24),
                  // ── User Profile Header
                  _buildUserHeader(controller.profile),

                  // ── Section A: Account
                  _buildSettingsList([
                    _SettingsItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Personal  Info',
                      src: 'assets/icons/personal.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonalInfo(),
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Security',
                      src: 'assets/icons/security.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Security()),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      src: 'assets/icons/notifications.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Notifications(),
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.payment_rounded,
                      title: 'Payment',
                      src: 'assets/icons/payment.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Payment()),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSettingsList([
                    _SettingsItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      src: 'assets/icons/helpsupport.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HelpSupport(),
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.description_outlined,
                      title: 'Terms & Policies',
                      src: 'assets/icons/termspolicies.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsPolicies(),
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.question_answer_outlined,
                      title: 'FAQs',
                      src: 'assets/icons/faqs.png',
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Faqs()),
                        // );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.flag_outlined,
                      title: 'Report a problem',
                      src: 'assets/icons/reportproblem.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportProblem(),
                          ),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),
                  _buildSettingsList([
                    _SettingsItem(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      src: 'assets/images/logout.png',
                      showTrailing: false,
                      textColor: Color(
                          0xFF5C5C5C), // optional: red text to indicate danger
                      onTap: () async {
                        final confirmed = await CustomAlert.showConfirmLogout(
                          context: context,
                          title: 'Log Out?',
                          message: 'Are you sure you want to log out?',
                          confirmText: 'Yes',
                          cancelText: 'Cancel',
                        );

                        if (confirmed == true) {
                          // Perform logout
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove(AppConstants.userLoginToken);

                          // Clear Dio auth header
                          widget.dioClient?.updateHeader(null, null);

                          // Show success
                          await CustomAlert.showSuccess(
                            context: context,
                            title: 'Logged Out',
                            message: 'You have been successfully logged out.',
                            buttonText: 'OK',
                          );

                          // Navigate to login screen (adjust route name as per your app)
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        }
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),
                  _buildDeleteAccount([
                    _SettingsItem(
                      icon: Icons.logout_rounded,
                      title: 'Delete Account',
                      src: 'assets/images/delete_icon.png',
                      showTrailing: false,
                      // iconColor: Colors
                      //     .white,
                      textColor:
                          Colors.white, // optional: red text to indicate danger
                      onTap: () async {
                        final confirmed = await CustomAlert.showDeleteAccount(
                          context: context,
                          title: 'Delete Account',
                          message:
                              'Deactivate your account and schedule it for permanent deletion.',
                          confirmText: 'Yes, Delete',
                          cancelText: 'No, Cancel',
                        );

                        if (confirmed == true) {
                          // Perform logout
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove(AppConstants.userLoginToken);

                          // Clear Dio auth header
                          widget.dioClient?.updateHeader(null, null);

                          // Show success
                          await CustomAlert.showSuccess(
                            context: context,
                            title: '',
                            message:
                                'Your account has been scheduled for deletion',
                            buttonText: 'OK',
                          );

                          // Navigate to login screen (adjust route name as per your app)
                          // Navigator.push(
                          //   // ignore: use_build_context_synchronously
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => LoginPage(),
                          //   ),
                          // );
                        }
                      },
                    ),

                    // _SettingsItem(
                    //   icon: Icons.logout_rounded,
                    //   title: 'Log Out',
                    //   src: 'assets/images/logout.png',
                    //   showTrailing: false,
                    //   textColor: Colors
                    //       .red
                    //       .shade700, // optional: red text to indicate danger
                    //   onTap: () async {
                    //     final confirmed = await CustomAlert.showConfirmLogout(
                    //       context: context,
                    //       title: 'Log Out?',
                    //       message: 'Are you sure you want to log out?',
                    //       confirmText: 'Yes',
                    //       cancelText: 'Cancel',
                    //     );

                    //     if (confirmed == true) {
                    //       // Perform logout
                    //       final prefs = await SharedPreferences.getInstance();
                    //       await prefs.remove(AppConstants.userLoginToken);

                    //       // Clear Dio auth header
                    //       widget.dioClient?.updateHeader(null, null);

                    //       // Show success
                    //       await CustomAlert.showSuccess(
                    //         context: context,
                    //         title: 'Logged Out',
                    //         message: 'You have been successfully logged out.',
                    //         buttonText: 'OK',
                    //       );

                    //       // Navigate to login screen (adjust route name as per your app)
                    //       Navigator.push(
                    //         // ignore: use_build_context_synchronously
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => LoginPage(),
                    //         ),
                    //       );
                    //     }
                    //   },
                    // ),
                  ]),

                  const SizedBox(height: 40), // bottom padding
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserHeader(profile) {
    final hasAvatar = (profile.avatar ?? '').toString().trim().isNotEmpty &&
        (profile.avatar ?? '').toString().startsWith('http');
    final name = (profile.name ?? '').toString().trim();
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    // controller.profile.name
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppPallete.primaryColor.withOpacity(0.15),
            backgroundImage: hasAvatar ? NetworkImage(profile.avatar) : null,
            child: hasAvatar
                ? null
                : Text(
                    initial,
                    style: const TextStyle(
                      color: AppPallete.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  // 'Uzochukwu Nwigwe',
                  style: const TextStyle(
                    fontSize: 20,
                    wordSpacing: -2.0,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  // 'uzochukwunwigwe@gmail.com',
                  style: TextStyle(
                    fontSize: 14,
                    wordSpacing: -2.0,
                    letterSpacing: -0.5,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildSettingsList(List<_SettingsItem> items) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 241, 243, 246),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child: item.src.isNotEmpty
                      ? Image.asset(
                          item.src,
                          fit: BoxFit.contain,
                          color: item
                              .iconColor, // only tint when you want (e.g. logout)
                          errorBuilder: (_, __, ___) => Icon(
                            item.icon,
                            color: AppPallete.primaryColor,
                            size: 32,
                          ),
                        )
                      : Icon(
                          item.icon,
                          color: item.iconColor ?? AppPallete.primaryColor,
                          size: 32,
                        ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    wordSpacing: -2.0,
                    letterSpacing: -0.5,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: item.textColor ?? Color(0xFF5C5C5C),
                  ),
                ),
                trailing: item.showTrailing
                    ? Icon(
                        Icons.chevron_right_rounded,
                        color: const Color(0xFF676767),
                        size: 18,
                      )
                    : null,
                onTap: item.onTap,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDeleteAccount(List<_SettingsItem> items) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Color(0xFFFF3333),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child: item.src.isNotEmpty
                      ? Image.asset(
                          item.src,
                          fit: BoxFit.contain,
                          color: item
                              .iconColor, // only tint when you want (e.g. logout)
                          errorBuilder: (_, __, ___) => Icon(
                            item.icon,
                            color: AppPallete.primaryColor,
                            size: 32,
                          ),
                        )
                      : Icon(
                          item.icon,
                          color: item.iconColor ?? AppPallete.primaryColor,
                          size: 32,
                        ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    wordSpacing: -2.0,
                    letterSpacing: -0.5,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: item.textColor ?? Color(0xFF5C5C5C),
                  ),
                ),
                trailing: item.showTrailing
                    ? Icon(
                        Icons.chevron_right_rounded,
                        color: const Color(0xFF676767),
                        size: 18,
                      )
                    : null,
                onTap: item.onTap,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String src;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool showTrailing;

  _SettingsItem({
    required this.icon,
    required this.title,
    required this.src,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.showTrailing = true,
  });
}
