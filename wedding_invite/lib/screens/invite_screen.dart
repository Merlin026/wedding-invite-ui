import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'rsvp_screen.dart';

const Color kOliveGreen = Color(0xFF6B7A57);
const Color kCreamBg = Color(0xFFF7F4EF);
const Color kDarkText = Color(0xFF4A4E41);

class InviteScreen extends StatefulWidget {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;
  final DateTime _weddingDate = DateTime(2026, 8, 30, 11, 0, 0);

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    if (_weddingDate.isAfter(now)) {
      setState(() {
        _timeLeft = _weddingDate.difference(now);
      });
    } else {
      if (_timeLeft != Duration.zero) {
        setState(() {
          _timeLeft = Duration.zero;
        });
        _timer.cancel();
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _launchMapsUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open map.')));
      }
    }
  }

  void _showRsvpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RsvpPopup();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isWide = screenSize.width > 768;

    return Scaffold(
      backgroundColor: kCreamBg,
      body: Stack(
        children: [
          // Scrollable Full-Bleed Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Full-Bleed Green Envelope Header (Spans 100% Screen Width)
                ClipPath(
                  clipper: EnvelopeClipper(),
                  child: Container(
                    width: double.infinity,
                    color: kOliveGreen,
                    padding: EdgeInsets.symmetric(
                      vertical: isWide ? 30 : 15,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/J.png',
                              height: isWide ? 320 : 250,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              "30.08.2026",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                // 2. Main Couple Image & Overlay Quote (Centered)
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 580),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          top: -70,
                          child: Opacity(
                            opacity: 0.6,
                            // child: Image.asset(
                            //   'assets/quotey.png',
                            //   width: isWide ? 280 : 230,
                            // ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/illustration.png',
                                fit: BoxFit.cover,
                                height: isWide ? 420 : 340,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // 3. Full-Bleed Save The Date & Countdown (Spans 100% Screen Width)
                Container(
                  width: double.infinity,
                  color: kOliveGreen,
                  padding: EdgeInsets.symmetric(
                    vertical: isWide ? 60 : 45,
                    horizontal: 20,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 750),
                      child: Column(
                        children: [
                          const Text(
                            "SAVE THE DATE",
                            style: TextStyle(
                              fontFamily: 'serif',
                              color: Colors.white,
                              fontSize: 22,
                              letterSpacing: 4.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            "Sunday",
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 15),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildDateUnit("AUG"),
                                const SizedBox(width: 25),
                                const Text(
                                  "30",
                                  style: TextStyle(
                                    fontFamily: 'serif',
                                    color: Colors.white,
                                    fontSize: 80,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                _buildDateUnit("2026"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            "COUNTDOWN",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              letterSpacing: 5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildTimeUnit(_timeLeft.inDays, "DAYS"),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(":", style: TextStyle(color: Colors.white, fontSize: 34)),
                                ),
                                _buildTimeUnit(_timeLeft.inHours.remainder(24), "HRS"),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(":", style: TextStyle(color: Colors.white, fontSize: 34)),
                                ),
                                _buildTimeUnit(_timeLeft.inMinutes.remainder(60), "MIN"),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(":", style: TextStyle(color: Colors.white, fontSize: 34)),
                                ),
                                _buildTimeUnit(_timeLeft.inSeconds.remainder(60), "SEC"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 55),

                // 4 & 5. Event Details - Mass & Reception (Centered Grid)
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 750),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildMassSection()),
                                Container(
                                  height: 250,
                                  width: 1,
                                  color: kOliveGreen.withOpacity(0.3),
                                  margin: const EdgeInsets.symmetric(horizontal: 24),
                                ),
                                Expanded(child: _buildReceptionSection()),
                              ],
                            )
                          : Column(
                              children: [
                                _buildMassSection(),
                                const SizedBox(height: 45),
                                Divider(color: kOliveGreen.withOpacity(0.3), indent: 40, endIndent: 40),
                                const SizedBox(height: 35),
                                _buildReceptionSection(),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 65),

                // 6. Full-Bleed Green Banner with Heart Icon
                Container(
                  width: double.infinity,
                  color: kOliveGreen,
                  padding: EdgeInsets.symmetric(
                    vertical: isWide ? 40 : 30,
                    horizontal: 20,
                  ),
                  child: const Center(
                    child: Icon(Icons.favorite_border, color: Colors.white, size: 38),
                  ),
                ),
              ],
            ),
          ),

          // Top Left Corner Lotus
          Positioned(
            top: -20,
            left: -20,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.8,
                child: Transform.flip(
                  flipX: true,
                  flipY: true,
                  child: Image.asset('assets/lotus.png', width: 120),
                ),
              ),
            ),
          ),
          // Top Right Corner Lotus
          Positioned(
            top: -20,
            right: -20,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.8,
                child: Transform.flip(
                  flipY: true,
                  child: Image.asset('assets/lotus.png', width: 120),
                ),
              ),
            ),
          ),
          // Bottom Left Corner Lotus
          Positioned(
            bottom: -20,
            left: -20,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.8,
                child: Transform.flip(
                  flipX: true,
                  child: Image.asset('assets/lotus.png', width: 120),
                ),
              ),
            ),
          ),
          // Bottom Right Corner Lotus
          Positioned(
            bottom: -20,
            right: -20,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.8,
                child: Image.asset('assets/lotus.png', width: 120),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMassSection() {
    return Column(
      children: [
        const Icon(Icons.church_outlined, color: kOliveGreen, size: 36),
        const SizedBox(height: 12),
        const Text(
          "Wedding Mass",
          style: TextStyle(
            fontFamily: 'serif',
            fontStyle: FontStyle.italic,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
  textAlign: TextAlign.center,
  text: const TextSpan(
    style: TextStyle(
      color: Colors.black87,
      fontSize: 15,
      height: 1.5,
    ),
    children: [
      TextSpan(
        text: "Inviting you\nto witness the sacred union\n"
            "solemnized by\n\n"
            "Very Rev. Msgr. Mathew Kallingal\n\n",
      ),
      TextSpan(
        text: "11:00 AM\n"
            "Mount Carmel Church\n"
            "Chathiath",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => _launchMapsUrl("https://www.google.com/maps/search/?api=1&query=Mount+Carmel+Church,+Chathiath,+Kochi,+Kerala"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(color: kOliveGreen, width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          ),
          child: const Text("View Location", style: TextStyle(letterSpacing: 1)),
        ),
      ],
    );
  }

  Widget _buildReceptionSection() {
    return Column(
      children: [
        const Icon(Icons.wine_bar_outlined, color: kOliveGreen, size: 36),
        const SizedBox(height: 12),
        const Text(
          "Lunch Reception",
          style: TextStyle(
            fontFamily: 'serif',
            fontStyle: FontStyle.italic,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
  textAlign: TextAlign.center,
  text: const TextSpan(
    style: TextStyle(
      color: Colors.black87,
      fontSize: 15,
      height: 1.5,
    ),
    children: [
      TextSpan(
        text: "12:30 PM\n"
            "Carmel Hall\n"
            "Cemetery Junction, Kochi",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => _launchMapsUrl("https://www.google.com/maps/place/Carmel+Hall/@9.9914413,76.279609,17z/data=!4m10!1m2!2m1!1sCarmel+Hall,+Pachalam,+Ernakulam,+Kerala!3m6!1s0x3b080d5cc431d5ab:0xd606c141305a14ae!8m2!3d9.9914413!4d76.2817977!15sCihDYXJtZWwgSGFsbCwgUGFjaGFsYW0sIEVybmFrdWxhbSwgS2VyYWxhkgEEaGFsbOABAA!16s%2Fg%2F1q5bkk9nj?entry=ttu&g_ep=EgoyMDI2MDQxNS4wIKXMDSoASAFQAw%3D%3D"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(color: kOliveGreen, width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          ),
          child: const Text("View Location", style: TextStyle(letterSpacing: 1)),
        ),
      ],
    );
  }

  Widget _buildDateUnit(String val) {
    return Column(
      children: [
        Container(width: 48, height: 1.5, color: Colors.white54),
        const SizedBox(height: 8),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 3, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(width: 48, height: 1.5, color: Colors.white54),
      ],
    );
  }

  Widget _buildTimeUnit(int val, String label) {
    return Column(
      children: [
        Text(
          val.toString().padLeft(2, '0'),
          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

class EnvelopeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}