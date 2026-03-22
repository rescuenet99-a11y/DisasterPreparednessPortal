import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DisasterHistoryScreen extends StatelessWidget {
  const DisasterHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Disaster History'),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDisasterCard(
            title: 'Cyclone Montha',
            date: '2025',
            icon: Icons.storm,
            details: [
              'Hit Andhra Pradesh',
              'Huge agricultural & infrastructure damage',
            ],
          ),
          _buildDisasterCard(
            title: 'Punjab Floods',
            date: 'August 2025',
            icon: Icons.water_drop,
            details: [
              'Worst floods in decades',
              '1400+ villages submerged',
            ],
          ),
          _buildDisasterCard(
            title: 'Uttarakhand Flash Floods',
            date: 'August 2025',
            icon: Icons.water_damage,
            details: [
              'Cloudburst disaster',
              'People dead + many missing',
            ],
          ),
          _buildDisasterCard(
            title: 'Vijayawada Floods',
            date: 'Aug–Sept 2024',
            icon: Icons.flood,
            details: [
              'Massive urban flooding',
              '45+ deaths',
              '2.7 lakh people affected',
            ],
          ),
          _buildDisasterCard(
            title: 'Wayanad Landslides',
            date: 'Kerala, July 2024',
            icon: Icons.terrain,
            details: [
              '392 deaths',
              'Entire areas destroyed',
            ],
          ),
          _buildDisasterCard(
            title: 'Cyclone Remal',
            date: 'May 2024',
            icon: Icons.storm,
            details: [
              'Hit West Bengal & Northeast India',
              'Wind speeds: 100–135 km/h',
              'Dozens of deaths and heavy damage',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisasterCard({
    required String title,
    required String date,
    required IconData icon,
    required List<String> details,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryRed, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...details.map((detail) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                      Expanded(
                        child: Text(
                          detail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
