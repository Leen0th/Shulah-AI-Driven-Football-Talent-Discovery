import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // Import the video_player package
import 'main.dart'; // Import the Home page
import 'discovery.dart'; // Import Discovery page
import 'player_analytics.dart'; // Import Player Analytics page
import 'past_matches.dart'; // Import Past Matches page
import 'upload_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 0; // Highlight "Home" tab to indicate navigation back to Home
  late VideoPlayerController _videoController; // Controller for the video player
  bool _isVideoInitialized = false; // Track if the video is initialized
  String? _errorMessage; // Store any error message during initialization

  @override
  void initState() {
    super.initState();
    // Initialize the video player controller with a different video URL
    _videoController = VideoPlayerController.network(
      'https://videos.pexels.com/video-files/15436954/15436954-hd_1906_1080_30fps.mp4', // A reliable test video URL
    )..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          print('Video initialized successfully');
        });
      }).catchError((error) {
        setState(() {
          _errorMessage = 'Failed to initialize video: $error';
          print(_errorMessage);
        });
      });
    _videoController.setLooping(true); // Optional: Loop the video
  }

  @override
  void dispose() {
    _videoController.dispose(); // Dispose of the video controller to free resources
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0: // Navigate to Home page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PlayerAnalyticsScreen()));
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
    // Get the screen width and height using MediaQuery
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive padding and positions
    final double horizontalPadding = screenWidth * 0.032; // Approx 12/375
    final double verticalPadding = screenHeight * 0.030; // Approx 24/1601

    // Profile picture size and position
    final double profilePicSize = screenWidth * 0.35;
    final double headerHeight = screenHeight * 0.185;
    final double profilePicTopOffset = headerHeight - (profilePicSize / 2); // Position the profile pic so half is in the header

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Set Scaffold background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight), // Ensure full height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section with Profile Picture
                Stack(
                  clipBehavior: Clip.none, // Allow the profile picture to overflow the header
                  children: [
                    // Header with circular cutout
                    ClipPath(
                      clipper: HeaderClipper(
                        profilePicSize: profilePicSize,
                        profilePicTopOffset: profilePicTopOffset,
                        screenWidth: screenWidth,
                      ),
                      child: Container(
                        width: screenWidth,
                        height: headerHeight,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF7A49),
                        ),
                      ),
                    ),
                    // Profile Picture
                    Positioned(
                      left: (screenWidth - profilePicSize) / 2, // Center the profile picture
                      top: profilePicTopOffset,
                      child: Container(
                        width: profilePicSize,
                        height: profilePicSize,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://assets.manutd.com/AssetPicker/images/0/0/20/87/1333066/Player_Profile_Kobee_Mainoo1719482688199.jpg"),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(profilePicSize / 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // User Details Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: profilePicSize / 2), // Space for the bottom half of the profile picture
                      Text(
                        'Kobbie Mainoo',
                        style: TextStyle(
                          color: const Color(0xFF24265F),
                          fontSize: screenWidth * 0.048,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kobbie.sports23@email.com',
                        style: TextStyle(
                          color: const Color(0xFF534C4C),
                          fontSize: screenWidth * 0.035,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Market Value: ',
                              style: TextStyle(
                                color: const Color(0xFF534C4C),
                                fontSize: screenWidth * 0.035,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: '€750K',
                              style: TextStyle(
                                color: const Color(0xFFEF7A49),
                                fontSize: screenWidth * 0.035,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Divider
                      Container(
                        width: screenWidth - 2 * horizontalPadding,
                        height: 1,
                        color: const Color(0xFFCAC4C4),
                      ),
                      const SizedBox(height: 16),
                      // Post Section
                      Container(
                        width: screenWidth - 2 * horizontalPadding,
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFEFEFE),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                            // Post Header (Profile Pic, Username, Timestamp)
                            Row(
                              children: [
                                Container(
                                  width: screenWidth * 0.11,
                                  height: screenWidth * 0.11,
                                  decoration: ShapeDecoration(
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                          "https://assets.manutd.com/AssetPicker/images/0/0/20/87/1333066/Player_Profile_Kobee_Mainoo1719482688199.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(screenWidth * 0.055),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kobbie Mainoo',
                                        style: TextStyle(
                                          color: const Color(0xFF24265F),
                                          fontSize: screenWidth * 0.048,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '6h ago',
                                        style: TextStyle(
                                          color: const Color(0xFFB5BCDB),
                                          fontSize: screenWidth * 0.027,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Caption
                            Text(
                              'One shot, one goal ⚽🔥',
                              style: TextStyle(
                                color: const Color(0xFF3D5480),
                                fontSize: screenWidth * 0.037,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Video Player
                            Center(
                              child: _errorMessage != null
                                  ? Container(
                                      width: screenWidth * 0.65,
                                      height: screenHeight * 0.23,
                                      decoration: ShapeDecoration(
                                        color: Colors.grey[300],
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _errorMessage!,
                                          style: const TextStyle(color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : _isVideoInitialized
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: screenWidth * 0.65,
                                              height: screenHeight * 0.23,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: VideoPlayer(_videoController),
                                              ),
                                            ),
                                            // Play/Pause Button Overlay
                                            IconButton(
                                              icon: Icon(
                                                _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (_videoController.value.isPlaying) {
                                                    _videoController.pause();
                                                  } else {
                                                    _videoController.play();
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      : Container(
                                          width: screenWidth * 0.65,
                                          height: screenHeight * 0.23,
                                          decoration: ShapeDecoration(
                                            color: Colors.grey[300],
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: const Center(child: CircularProgressIndicator()),
                                        ),
                            ),
                            const SizedBox(height: 16),
                            // Like and Comment Counts
                            Row(
                              children: [
                                const Icon(
                                  Icons.favorite_border,
                                  color: Color(0xFFB5BCDB),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '334',
                                  style: TextStyle(
                                    color: const Color(0xFFB5BCDB),
                                    fontSize: screenWidth * 0.032,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.comment,
                                  color: Color(0xFFB5BCDB),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '234',
                                  style: TextStyle(
                                    color: const Color(0xFFB5BCDB),
                                    fontSize: screenWidth * 0.032,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // AI Rating Section with Background and Adjusted Width
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE6D9), // Light orange background as in the screenshot
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '🔥 AI Rating: 8.7/10\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenWidth * 0.034,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'Shot Accuracy: 92/100 – Well-placed, tough for the keeper.\n'
                                          'Shot Power: 88/100 – Strong, fast strike.\n'
                                          'Positioning: 85/100 – Smart movement before the shot.\n'
                                          'Quick Tip: Improve shot variety & read the keeper’s positioning!',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenWidth * 0.028,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.030), // Bottom padding
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
}

// Custom Clipper for the header with a circular cutout
class HeaderClipper extends CustomClipper<Path> {
  final double profilePicSize;
  final double profilePicTopOffset;
  final double screenWidth;

  HeaderClipper({
    required this.profilePicSize,
    required this.profilePicTopOffset,
    required this.screenWidth,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();
    final double radius = profilePicSize / 2;
    final double centerX = size.width / 2;
    final double centerY = profilePicTopOffset + radius;

    // Draw the header with rounded bottom corners
    path.moveTo(0, 0);
    path.lineTo(0, size.height - screenWidth * 0.08);
    path.quadraticBezierTo(0, size.height, screenWidth * 0.08, size.height);
    path.lineTo(size.width - screenWidth * 0.08, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - screenWidth * 0.08);
    path.lineTo(size.width, 0);
    path.close();

    // Create a circular cutout for the profile picture
    Path circlePath = Path();
    circlePath.addOval(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius + 7));
    path = Path.combine(PathOperation.difference, path, circlePath);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}