import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';

class SheltersScreen extends StatefulWidget {
  const SheltersScreen({Key? key}) : super(key: key);

  @override
  State<SheltersScreen> createState() => _SheltersScreenState();
}

class _SheltersScreenState extends State<SheltersScreen> {

  double? latitude;
  double? longitude;
  GoogleMapController? mapController;

  Set<Marker> _markers = {};
  StreamSubscription<QuerySnapshot>? _sheltersSub;
  
  final List<Map<String, dynamic>> _dummyShelters = [
    {'name': 'Primary School', 'lat': 11.0168, 'lng': 76.9558, 'distance': '1.2 km away', 'icon': Icons.school},
    {'name': 'Community Hall', 'lat': 11.0200, 'lng': 76.9600, 'distance': '2.8 km away', 'icon': Icons.business},
    {'name': 'Regional Sports Center', 'lat': 11.0100, 'lng': 76.9500, 'distance': '4.5 km away', 'icon': Icons.sports_basketball},
  ];

  @override
  void initState() {
    super.initState();
    getLocation();
    _loadDummyMarkers();
    _initFirestoreListener();
  }

  void _loadDummyMarkers() {
    _markers = _dummyShelters.map((s) => Marker(
      markerId: MarkerId(s['name'] as String),
      position: LatLng(s['lat'] as double, s['lng'] as double),
      infoWindow: InfoWindow(title: s['name'] as String, snippet: 'Verified Safe Zone'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    )).toSet();
  }

  void _initFirestoreListener() {
    try {
      if (Firebase.apps.isNotEmpty) {
        _sheltersSub = FirebaseFirestore.instance.collection('shelters').snapshots().listen((snapshot) {
           if (snapshot.docs.isNotEmpty && mounted) {
              setState(() {
                 _markers = _markers.union(snapshot.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final lat = data['lat'] as double? ?? 0.0;
                    final lng = data['lng'] as double? ?? 0.0;
                    return Marker(
                      markerId: MarkerId(doc.id),
                      position: LatLng(lat, lng),
                      infoWindow: InfoWindow(title: data['name'] ?? 'Shelter', snippet: 'Live Update'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    );
                 }).toSet());
              });
           }
        });
      }
    } catch (e) {
       debugPrint("Firestore listener error: $e");
    }
  }

  @override
  void dispose() {
    _sheltersSub?.cancel();
    super.dispose();
  }

  // 📍 Get Live Location
  Future<void> getLocation() async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return;

    permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
       if (mounted) {
         setState(() {
           latitude = 11.0168; // fallback
           longitude = 76.9558;
         });
       }
       return;
    }

    Position position =
        await Geolocator.getCurrentPosition();

    if (mounted) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(latitude!, longitude!)));
    }
  }

  void _showMapAction(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Map Action: $action')),
    );
  }

  void _routeToShelter(BuildContext context, String name) {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Route to $name?'),
        content: const Text(
            'Connecting to navigation... Safe route computed.'
        ),
        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),

          ElevatedButton(
            onPressed: () {

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Starting navigation to $name...'
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: Colors.white,
            ),
            child: const Text('START'),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: const CustomAppBar(),
      drawer: const AppDrawer(),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.symmetric(horizontal: 20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 10),

            const Text(
              'Nearby Shelters',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Verified safe zones within your current evacuation perimeter.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryTeal.withOpacity(0.2), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: latitude == null || longitude == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude!, longitude!),
                        zoom: 13.0,
                      ),
                      onMapCreated: (controller) => mapController = controller,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      markers: _markers.isNotEmpty ? _markers : <Marker>{},
                    ),
              ),
            ),

            const SizedBox(height: 24),

            // 🏫 Shelter Cards

            StreamBuilder<QuerySnapshot>(
              stream: (() {
                try {
                  if (Firebase.apps.isNotEmpty) {
                    return FirebaseFirestore.instance.collection('shelters').snapshots();
                  }
                } catch (e) {
                  debugPrint("Using static shelters fallback");
                }
                return const Stream<QuerySnapshot>.empty();
              })(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && Firebase.apps.isNotEmpty) {
                   return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  // Fallback to dummy data mapping
                  return Column(
                    children: _dummyShelters.map((s) => Column(
                      children: [
                        _buildShelterCard(
                          context: context,
                          title: s['name'],
                          distance: s['distance'],
                          icon: s['icon'] ?? Icons.home_work,
                          iconBgColor: AppColors.lightRed,
                          iconColor: AppColors.darkRed,
                        ),
                        const SizedBox(height: 16),
                      ],
                    )).toList(),
                  );
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        _buildShelterCard(
                          context: context,
                          title: data['name'] ?? 'Unknown Shelter',
                          distance: data['distance'] ?? 'Nearby',
                          icon: Icons.security,
                          iconBgColor: AppColors.lightRed,
                          iconColor: AppColors.darkRed,
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }

  // 🏠 Shelter Card Widget

  Widget _buildShelterCard({

    required BuildContext context,
    required String title,
    required String distance,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,

  }) {

    return InkWell(

      onTap:
          () => _routeToShelter(context, title),

      borderRadius:
      BorderRadius.circular(16),

      child: Container(

        padding:
        const EdgeInsets.all(16),

        decoration: BoxDecoration(

          color:
          AppColors.cardBackground,

          borderRadius:
          BorderRadius.circular(16),

          boxShadow: [

            BoxShadow(
              color:
              Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset:
              const Offset(0, 4),
            ),

          ],
        ),

        child: Row(

          children: [

            Container(

              padding:
              const EdgeInsets.all(12),

              decoration:
              BoxDecoration(

                color: iconBgColor,
                shape: BoxShape.circle,

              ),

              child:
              Icon(icon, color: iconColor),

            ),

            const SizedBox(width: 16),

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w800,
                      color:
                      AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [

                      const Icon(
                        Icons.near_me,
                        size: 12,
                        color:
                        AppColors.textSecondary,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 12,
                          color:
                          AppColors.textSecondary,
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            Container(

              padding:
              const EdgeInsets.all(10),

              decoration:
              BoxDecoration(

                color:
                Colors.grey.shade200,

                shape: BoxShape.circle,

              ),

              child: const Icon(
                Icons.arrow_forward,
                size: 16,
                color:
                AppColors.textPrimary,
              ),
            ),

          ],
        ),
      ),
    );
  }
}