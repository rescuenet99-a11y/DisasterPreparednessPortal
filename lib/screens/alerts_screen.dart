import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import 'emergency_contacts_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  
  bool _showFloodAlert = true;
  bool _showCycloneAlert = true;
  bool _showFlashFloodAlert = true;

  void _refreshAlerts() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fetching latest alerts...")),
    );
    setState(() {
      _showFloodAlert = true;
      _showCycloneAlert = true;
      _showFlashFloodAlert = true;
    });
  }

  void _viewSafeRoutes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Safe Routes'),
        content: const Text('Evacuation Route 12 is currently clear. Head North towards the elevated highway.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  void _showDetails(String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Additional detailed information from the meteorological department. Please stay tuned to local radio and this app for live updates.'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Acknowledge'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5F7FA), Color(0xFFE0F2F1)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'CURRENT STATUS: VIGILANT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryTeal,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Active Alerts',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _refreshAlerts,
                  icon: const Icon(Icons.refresh, color: AppColors.primaryTeal),
                  tooltip: 'Refresh Alerts',
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Critical environmental updates for your specific rural coordinates. Stay grounded, stay informed.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            if (_showFloodAlert) ...[
              _buildAlertCard(
                title: 'FLOOD',
                status: 'IMMEDIATE',
                description:
                    'Rapid water level rise detected in the North Basin. Evacuate to higher ground immediately via Route 12.',
                icon: Icons.warning_amber_rounded,
                bgColor: AppColors.lightRed,
                isImmediate: true,
                onDismiss: () {
                  setState(() => _showFloodAlert = false);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Flood alert dismissed.')));
                },
                onPrimaryAction: _viewSafeRoutes,
              ),
              const SizedBox(height: 16),
            ],
            if (_showCycloneAlert) ...[
              _buildAlertCard(
                title: 'CYCLONE',
                status: 'WATCH',
                description:
                    'High-velocity winds expected within 24 hours. Secure all loose farm equipment and livestock.',
                icon: Icons.cyclone,
                bgColor: AppColors.cardBackground,
                iconBgColor: AppColors.primaryTeal,
                onPrimaryAction: () => _showDetails('Cyclone Watch Details'),
              ),
              const SizedBox(height: 16),
            ],
            if (_showFlashFloodAlert) ...[
              _buildAlertCard(
                title: 'FLASH FLOOD RISK',
                status: 'ELEVATED',
                description:
                    'Heavy precipitation predicted for the weekend. Monitor local creek beds for sudden changes.',
                icon: Icons.water_drop,
                bgColor: AppColors.cardBackground,
                iconBgColor: const Color(0xFFEFEBE9),
                iconColor: const Color(0xFF5D4037),
                onPrimaryAction: () => _showDetails('Flash Flood Risk Details'),
              ),
              const SizedBox(height: 24),
            ],
            if (!_showFloodAlert && !_showCycloneAlert && !_showFlashFloodAlert) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No active alerts.', style: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 24),
            ],
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.cardBackground,
                boxShadow: [
                   BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 140,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: Color(0xFFCCD5CD),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(Icons.map, size: 80, color: Colors.white.withOpacity(0.5)),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'LAT: -34.92 | LON: 138.60',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const Center(
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: AppColors.primaryRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CONNECTIVITY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: Color(0xFF6D4C41),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.signal_cellular_alt, color: AppColors.primaryRed),
                            SizedBox(width: 8),
                            Text(
                              'Satellite Live',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Map data cached 4m ago. Real-time tracking active.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickActions(context),
        backgroundColor: AppColors.darkRed,
        icon: const Icon(Icons.bolt, color: Colors.white),
        label: const Text('Quick Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 4,
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick Emergency Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 4),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fast access to critical features',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 20),

            // SOS
            _buildQuickActionTile(
              context,
              icon: Icons.crisis_alert,
              iconBg: AppColors.lightRed,
              iconColor: AppColors.primaryRed,
              title: 'Send SOS',
              subtitle: 'Broadcast emergency to authorities',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🚨 Navigate to SOS screen to send emergency signal'),
                    backgroundColor: AppColors.darkRed,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Report Hazard
            _buildQuickActionTile(
              context,
              icon: Icons.warning_amber_rounded,
              iconBg: const Color(0xFFFFF8E1),
              iconColor: const Color(0xFFF9A825),
              title: 'Report Hazard',
              subtitle: 'Submit a road block or local danger',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Report screen...')),
                );
              },
            ),
            const SizedBox(height: 12),

            // View Shelters
            _buildQuickActionTile(
              context,
              icon: Icons.home_work_outlined,
              iconBg: AppColors.lightTeal,
              iconColor: AppColors.primaryTeal,
              title: 'Nearby Shelters',
              subtitle: 'Find verified safe zones near you',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Shelters screen...')),
                );
              },
            ),
            const SizedBox(height: 12),

            // Emergency Contacts
            _buildQuickActionTile(
              context,
              icon: Icons.contacts_outlined,
              iconBg: const Color(0xFFEDE7F6),
              iconColor: const Color(0xFF6A1B9A),
              title: 'Emergency Contacts',
              subtitle: 'View and call your emergency contacts',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmergencyContactsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard({
    required String title,
    required String status,
    required String description,
    required IconData icon,
    required Color bgColor,
    bool isImmediate = false,
    Color? iconBgColor,
    Color? iconColor,
    VoidCallback? onDismiss,
    VoidCallback? onPrimaryAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: isImmediate ? AppColors.darkRed : iconBgColor,
                child: Icon(
                  icon,
                  color: isImmediate ? Colors.white : (iconColor ?? Colors.white),
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: isImmediate ? AppColors.darkRed : AppColors.primaryTeal,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          if (isImmediate)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPrimaryAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkRed,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('VIEW SAFE \nROUTES', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDismiss,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkRed,
                      side: const BorderSide(color: AppColors.darkRed),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('DISMISS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          else
            ElevatedButton(
              onPressed: onPrimaryAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightTeal,
                foregroundColor: AppColors.primaryTeal,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('DETAILS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}
