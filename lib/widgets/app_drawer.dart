import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/user_state.dart';
import '../screens/settings_screen.dart';
import '../screens/disaster_history_screen.dart';
import '../screens/emergency_contacts_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            color: AppColors.background,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFE2DACC), // Profile fallback
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    UserState.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    UserState.mobileNumber,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.history,
                  title: 'Disaster History',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DisasterHistoryScreen()));
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.contact_phone,
                  title: 'Emergency Contacts',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyContactsScreen()));
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: _buildDrawerItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              color: AppColors.primaryRed,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Clear the user credentials
                          UserState.name = 'Guest User';
                          UserState.mobileNumber = '+1 234-567-8900';
                          UserState.villageName = '';
                          
                          Navigator.pop(context); // Close dialog
                          
                          // Proceed back to Login Screen overriding the entire stack
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text('Logout', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, Color? color, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap ?? () {
        Navigator.pop(context); // Close drawer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $title...')),
        );
      },
    );
  }
}
