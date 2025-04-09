import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'main.dart'; // Import Home page
import 'discovery.dart'; // Import Discovery page
import 'past_matches.dart'; // Import Past Matches page
import 'upload_page.dart';

class PlayerAnalyticsScreen extends StatefulWidget {
  const PlayerAnalyticsScreen({super.key});

  @override
  _PlayerAnalyticsScreenState createState() => _PlayerAnalyticsScreenState();
}

class _PlayerAnalyticsScreenState extends State<PlayerAnalyticsScreen> {
  int _selectedIndex = 1; // Highlight "Player Analytics" tab

  // Mock data for player analytics (aggregated from posts and matches)
  final Map<String, double> overallStats = {
    'Speed': 12.0,
    'Passing Accuracy': 85.0,
    'Possession Time': 78.0,
  };

  // Units for each stat to be used only in Detailed Breakdown
  final Map<String, String> statUnits = {
    'Speed': 'km/h',
    'Passing Accuracy': '%',
    'Possession Time': 's',
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
        break;
      case 1: // Already on Player Analytics
        break;
      case 2:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UploadPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PastMatchesScreen()));
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
                      'Player Analytics',
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
                      _buildOverallScoreCard(screenWidth, screenHeight, horizontalPadding),
                      SizedBox(height: verticalPadding),
                      _buildKeyStatsChart(screenWidth, screenHeight, horizontalPadding),
                      SizedBox(height: verticalPadding),
                      _buildDetailedBreakdown(screenWidth, horizontalPadding),
                      SizedBox(height: verticalPadding),
                      _buildTrendsSection(screenWidth, screenHeight, horizontalPadding),
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

  // Overall Performance Score (No units shown)
  Widget _buildOverallScoreCard(double screenWidth, double screenHeight, double horizontalPadding) {
    double overallScore = (overallStats.values.reduce((a, b) => a + b) / overallStats.length) / 10; // Example calculation
    return Container(
      width: screenWidth - 2 * horizontalPadding,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: const Color(0xFFFEFEFE),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: const [
          BoxShadow(color: Color(0x02000000), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overall Performance',
                style: TextStyle(
                  color: Color(0xFF24265F),
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your Career Stats',
                style: TextStyle(
                  color: const Color(0xFF534C4C),
                  fontSize: screenWidth * 0.035,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            width: screenWidth * 0.25,
            height: screenWidth * 0.25,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEF7A49), Color(0xFFFFA07A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                overallScore.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.08,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Key Stats Overview (Bar Chart with fixed overlapping labels)
Widget _buildKeyStatsChart(double screenWidth, double screenHeight, double horizontalPadding) {
  // Map for abbreviated labels to improve readability
  final Map<String, String> shortLabels = {
    'Speed': 'Speed',
    'Passing Accuracy': 'Passing \n Accuracy' ,
    'Possession Time': 'Possession \n Time',
  };

  return Container(
    height: screenHeight * 0.3,
    width: screenWidth - 2 * horizontalPadding,
    padding: const EdgeInsets.all(16),
    decoration: ShapeDecoration(
      color: const Color(0xFFFEFEFE),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadows: const [
        BoxShadow(color: Color(0x02000000), blurRadius: 14, offset: Offset(0, 4)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Stats Overview',
          style: TextStyle(
            color: Color(0xFF24265F),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly, // Ensure even spacing
              barGroups: overallStats.entries.toList().asMap().entries.map((entry) {
                int index = entry.key;
                double value = entry.value.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      color: const Color(0xFFEF7A49),
                      width: 20, // Slightly wider bars for better tap target
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60, // Increase reserved space for rotated labels
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < overallStats.keys.length) {
                        final statName = overallStats.keys.elementAt(index);
                        final shortLabel = shortLabels[statName] ?? statName;
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8, // Add space between label and chart
                          child: Text(
                            shortLabel,
                            style: const TextStyle(
                              color: Color(0xFF24265F),
                              fontSize: 10, // Slightly smaller font size
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false, // Only horizontal lines
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                    dashArray: [4, 4], // Dashed lines
                  );
                },
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.grey.withOpacity(0.8),
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final statName = overallStats.keys.elementAt(group.x);
                    return BarTooltipItem(
                      '$statName\n${rod.toY}',
                      const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  // Detailed Breakdown Section (Units added here only)
  Widget _buildDetailedBreakdown(double screenWidth, double horizontalPadding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed Breakdown',
          style: TextStyle(
            color: Color(0xFF24265F),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: overallStats.entries.map((stat) {
            final unit = statUnits[stat.key] ?? ''; // Get the unit for this stat
            return Container(
              width: (screenWidth - 2 * horizontalPadding - 10) / 2, // Two items per row
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE6D9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat.key,
                    style: TextStyle(
                      color: const Color(0xFF24265F),
                      fontSize: screenWidth * 0.035,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stat.value} $unit', // Append the unit here
                    style: TextStyle(
                      color: const Color(0xFFEF7A49),
                      fontSize: screenWidth * 0.045,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Trends Over Time (Line Chart - No units in tooltips)
  Widget _buildTrendsSection(double screenWidth, double screenHeight, double horizontalPadding) {
    final List<FlSpot> speedData = [
      FlSpot(1, 12.0), FlSpot(2, 15.5), FlSpot(3, 9.0), FlSpot(4, 14.0),
      FlSpot(5, 11.0), FlSpot(6, 16.0), FlSpot(7, 10.5), FlSpot(8, 13.5), FlSpot(9, 12.0),
    ];

    final List<FlSpot> passingAccuracyData = [
      FlSpot(1, 85.0), FlSpot(2, 90.0), FlSpot(3, 78.0), FlSpot(4, 88.0),
      FlSpot(5, 82.0), FlSpot(6, 91.0), FlSpot(7, 79.0), FlSpot(8, 87.0), FlSpot(9, 84.0),
    ];

    final List<FlSpot> possessionTimeData = [
      FlSpot(1, 78.0), FlSpot(2, 65.0), FlSpot(3, 82.0), FlSpot(4, 70.0),
      FlSpot(5, 85.0), FlSpot(6, 68.0), FlSpot(7, 80.0), FlSpot(8, 72.0), FlSpot(9, 77.0),
    ];

    return Container(
      width: screenWidth - 2 * horizontalPadding,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: const Color(0xFFFEFEFE),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: const [
          BoxShadow(color: Color(0x02000000), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Trends',
            style: TextStyle(
              color: Color(0xFF24265F),
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEF7A49))),
                  const SizedBox(width: 4),
                  const Text('Speed', style: TextStyle(color: Color(0xFF24265F), fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF4CAF50))),
                  const SizedBox(width: 4),
                  const Text('Passing Accuracy', style: TextStyle(color: Color(0xFF24265F), fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2196F3))),
                  const SizedBox(width: 4),
                  const Text('Possession Time', style: TextStyle(color: Color(0xFF24265F), fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.04),
          SizedBox(
            height: screenHeight * 0.2,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(spots: speedData, isCurved: true, color: const Color(0xFFEF7A49), barWidth: 4, dotData: FlDotData(show: true)),
                  LineChartBarData(spots: passingAccuracyData, isCurved: true, color: const Color(0xFF4CAF50), barWidth: 4, dotData: FlDotData(show: true)),
                  LineChartBarData(spots: possessionTimeData, isCurved: true, color: const Color(0xFF2196F3), barWidth: 4, dotData: FlDotData(show: true)),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (value, meta) => value % 10 == 0 && value >= 0 && value <= 100 ? Text(value.toInt().toString(), style: const TextStyle(color: Color(0xFF24265F), fontSize: 12, fontFamily: 'Poppins')) : const SizedBox.shrink())),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (value, meta) => value.toInt() >= 1 && value.toInt() <= 9 && value.toInt() % 2 == 1 ? Padding(padding: const EdgeInsets.only(top: 8.0), child: Text('Match ${value.toInt()}', style: const TextStyle(color: Color(0xFF24265F), fontSize: 10, fontFamily: 'Poppins'))) : const SizedBox.shrink())),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1, dashArray: [4, 4])),
                minX: 1,
                maxX: 9,
                minY: 0,
                maxY: 100,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => Colors.grey.withOpacity(0.8),
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                      final matchNumber = spot.x.toInt();
                      final score = spot.y;
                      String metricName = spot.barIndex == 0 ? 'Speed' : spot.barIndex == 1 ? 'Passing Accuracy' : 'Possession Time';
                      return LineTooltipItem('$metricName\nMatch $matchNumber: $score', const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14)); // No units here
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}