import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import 'volunteer_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int)? onNavigate;

  const HomeScreen({Key? key, this.onNavigate}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isPowerReady = true;
  bool _isWaterStored = false;
  bool _isMedicalKitReady = false;
  bool _isDocsSecured = false;
  bool _isFoodStocked = false;

  LatLng? _currentPosition;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }

  void _navigateToTab(int index, String? fallbackMessage) {
    if (widget.onNavigate != null) {
      widget.onNavigate!(index);
    } else if (fallbackMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(fallbackMessage)),
      );
    }
  }

  void _showMockNavMsg(String dest) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $dest...')),
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

            const Text(
              'RURAL SENTINEL LIVE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF6D4C41),
                letterSpacing: 1.0,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Stay Safe',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            Row(
              children: const [

                Icon(Icons.signal_cellular_alt,
                    color: AppColors.primaryTeal,
                    size: 16),

                SizedBox(width: 4),

                Text(
                  'LIVE SIGNAL: STRONG',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🚨 ALERT CARD

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightRed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      const CircleAvatar(
                        backgroundColor:
                        AppColors.primaryRed,
                        child: Icon(Icons.waves,
                            color: Colors.white),
                      ),

                      const SizedBox(width: 12),

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4),
                        decoration: BoxDecoration(
                          color:
                          AppColors.primaryRed,
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'ACTIVE ALERT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Flood alert',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.w900,
                      color:
                      AppColors.darkRed,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Flash flooding expected near Blackwood Creek. Seek higher ground immediately.',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                      AppColors.darkRed,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(

                    onPressed: () {
                      _navigateToTab(
                          4,
                          'Opening Evacuation Map');
                    },

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.primaryRed,
                      foregroundColor:
                      Colors.white,
                      minimumSize:
                      const Size(
                          double.infinity,
                          48),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            12),
                      ),
                    ),

                    child: const Text(
                      'View Evacuation Map',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

          

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.9,
              children: [
                _buildActionCard(
                  title: 'Alerts',
                  subtitle: 'Local updates & history',
                  icon: Icons.notifications_active,
                  iconColor: AppColors.primaryRed,
                  onTap: () => _navigateToTab(1, 'Opening Alerts'),
                ),
                _buildActionCard(
                  title: 'SOS Emergency',
                  subtitle: 'Instant distress signal',
                  icon: Icons.location_on,
                  iconColor: Colors.white,
                  bgColor: AppColors.primaryRed,
                  titleColor: Colors.white,
                  subtitleColor: Colors.white,
                  onTap: () => _navigateToTab(2, 'Opening SOS'),
                ),
                _buildActionCard(
                  title: 'Report Issue',
                  subtitle: 'Submit road blocks/hazards',
                  icon: Icons.warning_rounded,
                  iconColor: AppColors.primaryTeal,
                  onTap: () => _navigateToTab(3, 'Opening Report'),
                ),
                _buildActionCard(
                  title: 'Shelters',
                  subtitle: 'Nearest safe zones',
                  icon: Icons.home_work,
                  iconColor: AppColors.primaryTeal,
                  onTap: () => _navigateToTab(4, 'Opening Shelters'),
                ),
                _buildActionCard(
                  title: 'Volunteer',
                  subtitle: 'Join & help community',
                  icon: Icons.people,
                  iconColor: AppColors.primaryTeal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VolunteerScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            
            const Text(
              'Live Resource Map',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            InkWell(
              onTap: () => _showMockNavMsg('Full Map'),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryTeal.withOpacity(0.2), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: _currentPosition == null
                    ? const Center(child: CircularProgressIndicator())
                    : FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: _currentPosition!,
                          initialZoom: 14.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.disaster_portal',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentPosition!,
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                              ),
                            ],
                          ),
                        ],
                      ),
                ),
              ),
            ),

            const SizedBox(height: 24),

       

            Container(

              padding:
              const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color:
                Colors.grey.shade100,
                borderRadius:
                BorderRadius.circular(20),
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(
                    'PREPAREDNESS CHECKLIST',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildChecklistItem(
                    'Backup Power Ready',
                    _isPowerReady,
                        () => setState(() =>
                    _isPowerReady =
                    !_isPowerReady),
                  ),

                  _buildChecklistItem(
                    'Emergency Water Store',
                    _isWaterStored,
                        () => setState(() =>
                    _isWaterStored =
                    !_isWaterStored),
                  ),

                  _buildChecklistItem(
                    'Medical Kit Updated',
                    _isMedicalKitReady,
                    () => setState(() => _isMedicalKitReady = !_isMedicalKitReady),
                  ),
                  _buildChecklistItem(
                    'Important Documents Secured',
                    _isDocsSecured,
                    () => setState(() => _isDocsSecured = !_isDocsSecured),
                  ),
                  _buildChecklistItem(
                    'Non-perishable Food Stocked',
                    _isFoodStocked,
                    () => setState(() => _isFoodStocked = !_isFoodStocked),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

          ],
        ),
      ),
      ), // closes gradient Container
    );
  }

  Widget _buildChecklistItem(
      String title,
      bool isChecked,
      VoidCallback onTap,
      ) {

    return InkWell(

      onTap: onTap,

      child: Padding(

        padding:
        const EdgeInsets.symmetric(
            vertical: 8),

        child: Row(

          children: [

            Icon(
              isChecked
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: isChecked
                  ? AppColors.primaryRed
                  : Colors.grey,
            ),

            const SizedBox(width: 12),

            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    Color bgColor = AppColors.cardBackground,
    Color titleColor = AppColors.textPrimary,
    Color subtitleColor = AppColors.textSecondary,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: subtitleColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}