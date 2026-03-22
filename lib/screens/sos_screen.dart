import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({Key? key}) : super(key: key);

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isSosSent = false;

  final FlutterTts tts = FlutterTts();

  // 🔊 Tamil Voice Function
  void speakTamil() async {
    await tts.setLanguage("ta-IN");
    await tts.speak("அபாய எச்சரிக்கை. தயவு செய்து பாதுகாப்பான இடத்திற்கு செல்லுங்கள்");
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    tts.stop();
    super.dispose();
  }

  // 🚨 SOS FUNCTION (FULL LOGIC)
  void _sendSOS() {
    setState(() {
      _isSosSent = true;
    });

    _animationController.stop();

    // 🔊 Tamil Voice
    speakTamil();

    // 📩 SMS Simulation
    print("📩 SMS sent to emergency contacts");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🚨 SOS sent via SMS to volunteers & authorities!"),
        backgroundColor: AppColors.darkRed,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _cancelSOS() {
    if (!_isSosSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No active SOS request to cancel.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Request?'),
        content: const Text('Are you sure you want to cancel the emergency request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isSosSent = false;
              });
              _animationController.repeat(reverse: true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("SOS request cancelled.")),
              );
            },
            child: const Text('YES', style: TextStyle(color: AppColors.primaryRed)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showSignalStrength: true),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            const Text(
              'EMERGENCY',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 SOS BUTTON
            GestureDetector(
              onTap: _isSosSent ? null : _sendSOS,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isSosSent ? 1.0 : _pulseAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isSosSent ? Colors.green : AppColors.primaryRed,
                      ),
                      child: Center(
                        child: Text(
                          _isSosSent ? "SENT" : "SEND SOS",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Tap button to request emergency help",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            TextButton(
              onPressed: _cancelSOS,
              child: const Text(
                'CANCEL REQUEST',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}