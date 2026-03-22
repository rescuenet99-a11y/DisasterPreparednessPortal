import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSignalStrength;

  const CustomAppBar({Key? key, this.showSignalStrength = false}) : super(key: key);

  void _showProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Options'),
        content: const Text('Manage your emergency profile, update locations, and review trusted contacts.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Profile Settings...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: Colors.white,
            ),
            child: const Text('SETTINGS'),
          ),
        ],
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
