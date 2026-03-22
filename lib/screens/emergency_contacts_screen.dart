import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.health_and_safety, color: Colors.orange, size: 32),
              title: Text('Accident', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('108', style: TextStyle(fontSize: 16)),
            ),
          ),
          Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
              title: Text('Danger', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('100 / 101', style: TextStyle(fontSize: 16)),
            ),
          ),
          Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.storm, color: Colors.blueGrey, size: 32),
              title: Text('Disaster', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('1070 / 1077', style: TextStyle(fontSize: 16)),
            ),
          ),
          Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.contact_phone, color: Colors.green, size: 32),
              title: Text('All-in-one', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('112', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
