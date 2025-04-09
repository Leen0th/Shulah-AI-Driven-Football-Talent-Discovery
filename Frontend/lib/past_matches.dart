import 'package:flutter/material.dart';
import 'main.dart'; // Import Home page
import 'discovery.dart'; // Import Discovery page
import 'player_analytics.dart'; // Import Player Analytics page
import 'match_details.dart'; // Import Match Details page
import 'upload_page.dart';

class PastMatchesScreen extends StatefulWidget {
  const PastMatchesScreen({super.key});

  @override
  _PastMatchesScreenState createState() => _PastMatchesScreenState();
}

class _PastMatchesScreenState extends State<PastMatchesScreen> {
  int _selectedIndex = 3; // Highlight "Past Matches" tab

  // Mock data for past matches
  final List<Map<String, dynamic>> pastMatches = [
    {
      'team1': 'Red Devils',
      'team2': 'V. Greens',
      'score1': 1,
      'score2': 3,
      'date': '9 Jan 2021',
      'time': '19.45', // Updated to match the format in the image (dot instead of colon)
      'stadium': 'Devils Arena Stadium',
      'goalScorers': {
        'team1': ['Bobo 85\''],
        'team2': ['Alan Berinho 40\'', 'Nailson Sanchez 17\'', 'Mahmoud Nara 71\'']
      },
      'stats': {
        'possession': 45.0,
        'speed': 20.0,
        'passing': 70.0,
      },
    },
    {
      'team1': 'V. Greens',
      'team2': 'Red Devils',
      'score1': 3,
      'score2': 2,
      'date': '21 Nov 2020',
      'time': '21.45', // Updated to match the format in the image
      'stadium': 'Green Field Stadium',
      'goalScorers': {
        'team1': ['Player A 15\'', 'Player B 60\'', 'Player C 88\''],
        'team2': ['Player D 30\'', 'Player E 75\'']
      },
      'stats': {
        'possession': 55.0,
        'speed': 22.0,
        'passing': 75.0,
      },
    },
    {
      'team1': 'Red Devils',
      'team2': 'V. Greens',
      'score1': 1,
      'score2': 5,
      'date': '9 Jul 2021',
      'time': '19.45', // Updated to match the format in the image
      'stadium': 'Devils Arena Stadium',
      'goalScorers': {
        'team1': ['Player F 45\''],
        'team2': ['Player G 10\'', 'Player H 25\'', 'Player I 50\'', 'Player J 70\'', 'Player K 90\'']
      },
      'stats': {
        'possession': 40.0,
        'speed': 18.0,
        'passing': 65.0,
      },
    },
    {
      'team1': 'Red Devils',
      'team2': 'V. Greens',
      'score1': 1,
      'score2': 1,
      'date': '9 Jan 2021',
      'time': '19.45', // Updated to match the format in the image
      'stadium': 'Devils Arena Stadium',
      'goalScorers': {
        'team1': ['Player L 20\''],
        'team2': ['Player M 80\'']
      },
      'stats': {
        'possession': 50.0,
        'speed': 21.0,
        'passing': 72.0,
      },
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PlayerAnalyticsScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UploadPage()));          
        break;
      case 3: // Already on Past Matches
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
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight, // Ensure the container takes the full screen height
          color: const Color(0xFFF9F9F9), // Background color for the entire screen
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.15,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF7A49),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Past Matches',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Main Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Matches',
                        style: TextStyle(
                          color: Color(0xFF24265F),
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pastMatches.length,
                        itemBuilder: (context, index) {
                          final match = pastMatches[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MatchDetailsScreen(match: match),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFFEFEFE),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x02000000),
                                    blurRadius: 14,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center, // Center the content
                                children: [
                                  // Team Names and Scores Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center, // Center the team names and scores
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFFE6D9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            match['score1'].toString(),
                                            style: const TextStyle(
                                              color: Color(0xFFEF7A49),
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${match['team1']} vs ${match['team2']}'.toUpperCase(), // Convert to uppercase
                                        style: const TextStyle(
                                          color: Color(0xFF24265F),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFDFF0D8),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            match['score2'].toString(),
                                            style: const TextStyle(
                                              color: Color(0xFF4CAF50),
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4), // Reduced spacing to match the design
                                  // Date and Time Row (Centered)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center, // Center the date/time
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        color: Color(0xFFB5BCDB),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${match['date']} ${match['time']}',
                                        style: const TextStyle(
                                          color: Color(0xFFB5BCDB),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: verticalPadding), // Add padding at the bottom
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Player Analytics'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Past Matches'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Discovery'),
          ],
        ),
      ),
    );
  }
}