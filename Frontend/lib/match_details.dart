import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart for radar chart
import 'main.dart'; // Import Home page
import 'discovery.dart'; // Import Discovery page
import 'player_analytics.dart'; // Import Player Analytics page
import 'past_matches.dart'; // Import Past Matches page
import 'upload_page.dart';

class MatchDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> match;

  const MatchDetailsScreen({super.key, required this.match});

  @override
  _MatchDetailsScreenState createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  int _selectedIndex = 3; // Highlight "Past Matches" tab

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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PastMatchesScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Discovery()));
        break;
    }
  }
double _normalize(dynamic value, double min, double max, double outputMax) {
  double val = value.toDouble(); // Convert to double
  val = val.clamp(min, max); // Clamp to the expected range
  double normalized = ((val - min) / (max - min)) * outputMax; // Normalize to 0-outputMax
  return normalized;
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
          height: screenHeight,
          color: const Color(0xFFF9F9F9),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Section with Back Arrow
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
                      child: Stack(
                        children: [
                          Positioned(
                            left: 16,
                            top: screenHeight * 0.05,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const Center(
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
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.25), // Space to prevent overlap
                    // Rest of the content
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Skill Distribution (Radar Chart) 
                          // Inside the build method, under the "Skill Distribution" Container:
// Inside the build method, under the "Skill Distribution" Container:
Container(
  width: screenWidth * 0.85, // Reduced width to match ticket
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
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Skill Distribution',
        style: TextStyle(
          color: Color(0xFF24265F),
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: screenHeight * 0.3,
        child: RadarChart(
          RadarChartData(
            radarShape: RadarShape.polygon, // Ensures a triangle for 3 data points
            dataSets: [
              RadarDataSet(
                fillColor: const Color(0xFFEF7A49).withOpacity(0.3),
                borderColor: const Color(0xFFEF7A49),
                borderWidth: 2,
                dataEntries: [
                  RadarEntry(value: _normalize(widget.match['stats']['possession'], 0, 100, 5)),
                  RadarEntry(value: _normalize(widget.match['stats']['speed'], 0, 100, 5)),
                  RadarEntry(value: _normalize(widget.match['stats']['passing'], 0, 100, 5)),
                ],
              ),
              // Dummy dataset to enforce a max scale of 5
              RadarDataSet(
                fillColor: Colors.transparent,
                borderColor: Colors.transparent,
                dataEntries: [
                  RadarEntry(value: 5),
                  RadarEntry(value: 5),
                  RadarEntry(value: 5),
                ],
              ),
            ],
            radarBorderData: const BorderSide(color: Colors.transparent),
            gridBorderData: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
            titlePositionPercentageOffset: 0.15,
            titleTextStyle: const TextStyle(
              color: Color(0xFF24265F),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            getTitle: (index, angle) {
              switch (index) {
                case 0:
                  return const RadarChartTitle(text: 'POSSESSION');
                case 1:
                  return const RadarChartTitle(text: 'SPEED');
                case 2:
                  return const RadarChartTitle(text: 'PASSING');
                default:
                  return const RadarChartTitle(text: '');
              }
            },
            tickCount: 3, // Adjusted for 0-5 scale (0, 2.5, 5)
            ticksTextStyle: const TextStyle(color: Colors.transparent),
            radarTouchData: RadarTouchData(
              touchCallback: (FlTouchEvent event, RadarTouchResponse? response) {},
            ),
          ),
        ),
      ),
    ],
  ),
),
                          const SizedBox(height: 24),
                          // AI Insights & Recommendations
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'AI Insights & Recommendations:',
                                style: TextStyle(
                                  color: Color(0xFF353535),
                                  fontSize: 18,
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
                                                textAlign: TextAlign.right,
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
                                                textAlign: TextAlign.right,
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
                                                textAlign: TextAlign.right,
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
                          SizedBox(height: screenHeight * 0.030),
                        ],
                      ),
                    ),
                  ],
                ),
                // Positioned Ticket Container - Reduced Width
                Positioned(
                  top: screenHeight * 0.11, // Adjust to overlap 1/4 of the header
                  left: (screenWidth - (screenWidth * 0.85)) / 2, // Center the narrower ticket
                  right: (screenWidth - (screenWidth * 0.85)) / 2,
                  child: ClipPath(
                    clipper: TicketClipper(),
                    child: Container(
                      width: screenWidth * 0.75, // Further reduced width for a narrower look
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                        children: [
                          Text(
                            widget.match['stadium'],
                            style: const TextStyle(
                              color: Color(0xFF24265F),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.match['date'],
                            style: const TextStyle(
                              color: Color(0xFFB5BCDB),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage('https://img.freepik.com/premium-vector/football-club-logo-design-concept_761413-8099.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '${widget.match['score1']} - ${widget.match['score2']}',
                                style: const TextStyle(
                                  color: Color(0xFF24265F),
                                  fontSize: 24,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage('https://img.freepik.com/premium-vector/green-badge-soccer-football-logo_9645-2768.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Goal Scorers - Aligned to the left
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Align to left
                                children: (widget.match['goalScorers']['team1'] as List<String>)
                                    .map((scorer) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Row(
                                            children: [
                                              const Text(
                                                '⚽',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                scorer,
                                                style: const TextStyle(
                                                  color: Color(0xFFEF7A49),
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Align to left
                                children: (widget.match['goalScorers']['team2'] as List<String>)
                                    .map((scorer) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Row(
                                            children: [
                                              const Text(
                                                '⚽',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                scorer,
                                                style: const TextStyle(
                                                  color: Color(0xFF4CAF50),
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

// Custom Clipper for the ticket-like shape with zigzag bottom
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double zigzagHeight = 10.0; // Height of each zigzag
    const double zigzagWidth = 20.0; // Width of each zigzag segment

    // Start from the top-left corner
    path.moveTo(0, 0);
    path.lineTo(size.width, 0); // Top edge
    path.lineTo(size.width, size.height - zigzagHeight); // Right edge down to zigzag start

    // Draw the zigzag pattern at the bottom
    int numZigzags = (size.width / zigzagWidth).floor();
    for (int i = 0; i < numZigzags; i++) {
      double x = size.width - (i * zigzagWidth);
      if (i % 2 == 0) {
        path.lineTo(x, size.height - zigzagHeight); // Up point
      } else {
        path.lineTo(x, size.height); // Down point
      }
    }

    path.lineTo(0, size.height - zigzagHeight); // Left edge up to zigzag start
    path.lineTo(0, 0); // Left edge back to top
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}