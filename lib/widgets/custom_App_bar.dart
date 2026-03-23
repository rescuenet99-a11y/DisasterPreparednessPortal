import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/user_state.dart';
import '../screens/settings_screen.dart';
import '../screens/emergency_contacts_screen.dart';
import '../screens/login_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSignalStrength;

  const CustomAppBar({Key? key, this.showSignalStrength = false}) : super(key: key);

  String _maskMobile(String mobile) {
    if (mobile.length < 4) return mobile;
    return mobile.replaceRange(0, mobile.length - 4, '*' * (mobile.length - 4));
  }

  void _showProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryTeal,
                    child: Text(
                      UserState.name.isNotEmpty ? UserState.name[0].toUpperCase() : 'G',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserState.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 12, color: AppColors.primaryTeal),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                UserState.villageName.isNotEmpty ? UserState.villageName : 'Location not set',
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 12, color: AppColors.primaryTeal),
                            const SizedBox(width: 4),
                            Text(
                              _maskMobile(UserState.mobileNumber),
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Menu Options
            _buildMenuTile(
              context,
              icon: Icons.settings_outlined,
              iconColor: AppColors.primaryTeal,
              label: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
            _buildMenuTile(
              context,
              icon: Icons.contacts_outlined,
              iconColor: AppColors.primaryTeal,
              label: 'Emergency Contacts',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyContactsScreen()));
              },
            ),
            _buildMenuTile(
              context,
              icon: Icons.shield_outlined,
              iconColor: AppColors.primaryTeal,
              label: 'Privacy & Security',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy & Security coming soon')),
                );
              },
            ),

            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),

            _buildMenuTile(
              context,
              icon: Icons.logout_rounded,
              iconColor: AppColors.primaryRed,
              label: 'Logout',
              labelColor: AppColors.primaryRed,
              onTap: () {
                Navigator.pop(context);
                UserState.name = 'Guest User';
                UserState.mobileNumber = '+1 234-567-8900';
                UserState.villageName = '';
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
    Color labelColor = AppColors.textPrimary,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            )
          : IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      title: const Text(
        'Disaster Alert',
        style: TextStyle(
          color: AppColors.darkRed,
          fontWeight: FontWeight.w800,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        if (showSignalStrength)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      'SIGNAL STRENGTH',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryTeal,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Icon(
                      Icons.signal_cellular_alt,
                      color: AppColors.primaryTeal,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        InkWell(
          onTap: () => _showProfile(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFE2DACC), // Fallback color
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
