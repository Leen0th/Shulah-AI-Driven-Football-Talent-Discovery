import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'profile.dart'; // Import the Profile page
import 'discovery.dart'; // Import Discovery page
import 'player_analytics.dart'; // Import Player Analytics page
import 'past_matches.dart'; // Import Past Matches page
import 'upload_page.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const SplashScreen(), // Show splash screen first
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Lottie.network(
          'https://lottie.host/a3bc6f01-71cf-4991-b4cd-0c8c3a9dbc60/xMNRJxAEqQ.json',
          width: 200,
          height: 200,
          repeat: true,
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; // Track the selected tab index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0: // Already on Home screen
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const PlayerAnalyticsScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UploadPage()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const PastMatchesScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Discovery()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.032;
    final double verticalPadding = screenHeight * 0.030;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Set Scaffold background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight), // Ensure full height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.18,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEF7A49),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(screenWidth * 0.08),
                        bottomRight: Radius.circular(screenWidth * 0.08),
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: screenWidth * 0.765,
                        top: screenHeight * 0.072,
                        child: Container(
                          width: screenWidth * 0.17,
                          height: screenWidth * 0.17,
                          decoration: ShapeDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            shape: const OvalBorder(),
                            shadows: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.775,
                        top: screenHeight * 0.0743,
                        child: Container(
                          width: screenWidth * 0.15,
                          height: screenWidth * 0.15,
                          decoration: ShapeDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            shape: const OvalBorder(),
                            shadows: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.775,
                        top: screenHeight * 0.0765,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Profile()),
                            );
                          },
                          child: Container(
                            width: screenWidth * 0.15,
                            height: screenWidth * 0.15,
                            decoration: ShapeDecoration(
                              image: const DecorationImage(
                                image: NetworkImage(
                                    "https://assets.manutd.com/AssetPicker/images/0/0/20/87/1333066/Player_Profile_Kobee_Mainoo1719482688199.jpg"),
                                fit: BoxFit.cover,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(screenWidth * 0.075),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.075,
                        top: screenHeight * 0.081,
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.037,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.075,
                        top: screenHeight * 0.105,
                        child: Text(
                          'Kobbie',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.064,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth - 2 * horizontalPadding,
                        height: screenHeight * 0.051,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF3F3F3),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color(0xFFF3F3F3)),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(screenWidth * 0.048),
                              topRight: Radius.circular(screenWidth * 0.048),
                            ),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x07000000),
                              blurRadius: 16,
                              offset: Offset(0, 9),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            'Player recent match rating',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.90,
                        child: Container(
                          width: screenWidth - 2 * horizontalPadding,
                          height: screenHeight * 0.24,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Color(0xFFEFEFEF)),
                              borderRadius: BorderRadius.circular(screenWidth * 0.048),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Speed',
                                      style: TextStyle(
                                        color: const Color(0xFF150000),
                                        fontSize: screenWidth * 0.037,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '24 km/h',
                                      style: TextStyle(
                                        color: const Color(0xFFEF7A49),
                                        fontSize: screenWidth * 0.029,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    Text(
                                      'Passing accuracy',
                                      style: TextStyle(
                                        color: const Color(0xFF150000),
                                        fontSize: screenWidth * 0.037,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '70%',
                                      style: TextStyle(
                                        color: const Color(0xFFEF7A49),
                                        fontSize: screenWidth * 0.029,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    Text(
                                      'Ball possession time',
                                      style: TextStyle(
                                        color: const Color(0xFF150000),
                                        fontSize: screenWidth * 0.037,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '3-5 seconds per touch',
                                      style: TextStyle(
                                        color: const Color(0xFFEF7A49),
                                        fontSize: screenWidth * 0.029,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Insights & Recommendations:',
                            style: TextStyle(
                              color: const Color(0xFF353535),
                              fontSize: screenWidth * 0.043,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: screenHeight * 0.150,
                            width: screenWidth - 2 * horizontalPadding,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.368,
                                    height: screenHeight * 0.150,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: ShapeDecoration(
                                      color: const Color(0x993CB371),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 8,
                                          top: 39,
                                          child: Text(
                                            'Positive improvement',
                                            style: TextStyle(
                                              color: const Color(0xFFFFFEFE),
                                              fontSize: screenWidth * 0.029,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 11,
                                          top: 56,
                                          child: SizedBox(
                                            width: screenWidth * 0.309,
                                            child: Text(
                                              'Your passing accuracy increased by 5% this week!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: screenWidth * 0.027,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth * 0.368,
                                    height: screenHeight * 0.150,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: ShapeDecoration(
                                      color: const Color(0x99C62828),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 7,
                                          top: 39,
                                          child: Text(
                                            'Area for improvement',
                                            style: TextStyle(
                                              color: const Color(0xFFFFFEFE),
                                              fontSize: screenWidth * 0.029,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 11,
                                          top: 56,
                                          child: SizedBox(
                                            width: screenWidth * 0.309,
                                            child: Text(
                                              'Focus on positioning during defensive transitions.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: screenWidth * 0.027,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth * 0.368,
                                    height: screenHeight * 0.150,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFF457B9D),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 8,
                                          top: 39,
                                          child: Text(
                                            'Position-based insight',
                                            style: TextStyle(
                                              color: const Color(0xFFFFFEFE),
                                              fontSize: screenWidth * 0.029,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 11,
                                          top: 56,
                                          child: SizedBox(
                                            width: screenWidth * 0.309,
                                            child: Text(
                                              'Compared to other midfielders, your long passes need work.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: screenWidth * 0.027,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Leaderboard',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFEF7A49),
                              fontSize: screenWidth * 0.048,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: screenHeight * 0.23,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: screenWidth * 0.3838,
                                  top: screenHeight * 0.0,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.2324,
                                        height: screenHeight * 0.105,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://assets.manutd.com/AssetPicker/images/0/0/20/88/1333393/91_Phallon_Tullis_Joyce1719823409273.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(
                                            side: BorderSide(width: 3, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '123',
                                            style: TextStyle(
                                              color: const Color(0xFFEF7A49),
                                              fontSize: screenWidth * 0.037,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'pts',
                                            style: TextStyle(
                                              color: const Color(0xFFEF7A49),
                                              fontSize: screenWidth * 0.037,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: screenWidth * 0.179,
                                        child: Text(
                                          'Phallon Joyce',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.037,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: screenWidth * 0.118,
                                  top: screenHeight * 0.02,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.2324,
                                        height: screenHeight * 0.105,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://assets.manutd.com/AssetPicker/images/0/0/20/87/1333066/Player_Profile_Kobee_Mainoo1719482688199.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(
                                            side: BorderSide(width: 3, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '100',
                                            style: TextStyle(
                                              color: const Color(0xFFEF7A49),
                                              fontSize: screenWidth * 0.037,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'pts',
                                            style: TextStyle(
                                              color: const Color(0xFFEF7A49),
                                              fontSize: screenWidth * 0.037,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: screenWidth * 0.2,
                                        child: Text(
                                          'Kobbie Mainoo',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.037,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: screenWidth * 0.6300,
                                  top: screenHeight * 0.038,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.2324,
                                        height: screenHeight * 0.105,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://www.zerozero.pt/img/jogadores/new/82/17/1048217_alyssa_aherne_20240911165138.png"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(
                                            side: BorderSide(width: 3, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '98',
                                            style: TextStyle(
                                              color: const Color(0xFFEF7A49),
                                              fontSize: screenWidth * 0.037,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'pts',
                                            style: TextStyle(
                                              color: const Color(0xFFEF7A49),
                                              fontSize: screenWidth * 0.037,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: screenWidth * 0.192,
                                        child: Text(
                                          'Alyssa Aherne',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.037,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildLeaderboardItem(screenWidth, '4th', 'Ben Parker', '95 pts'),
                          _buildLeaderboardItem(screenWidth, '5th', 'Johnny Cage', '90 pts'),
                          _buildLeaderboardItem(screenWidth, '6th', 'Matt Dove', '85 pts'),
                          _buildLeaderboardItem(screenWidth, '7th', 'John Doe', '84 pts'),
                          _buildLeaderboardItem(screenWidth, '8th', 'Peter William', '80 pts'),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x3F9E9E9E),
              blurRadius: 36,
              offset: Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFEF7A49),
          unselectedItemColor: const Color(0xFF333333),
          selectedLabelStyle: const TextStyle(
            fontSize: 9,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 9,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Player Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                size: 40,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Past Matches',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Discovery',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(double screenWidth, String rank, String name, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: screenWidth * 0.1,
                child: Text(
                  rank,
                  style: TextStyle(
                    color: const Color(0xFFA5A5A5),
                    fontSize: screenWidth * 0.027,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.4,
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.048,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: screenWidth * 0.2,
            child: Text(
              points,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: const Color(0xFFEF7A49),
                fontSize: screenWidth * 0.037,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}