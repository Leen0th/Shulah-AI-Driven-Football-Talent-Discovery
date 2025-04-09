import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'main.dart'; // Import the Home page
import 'player_analytics.dart'; // Import Player Analytics page
import 'past_matches.dart'; // Import Past Matches page
import 'upload_page.dart';

class Discovery extends StatefulWidget {
  const Discovery({super.key});

  @override
  _DiscoveryState createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  int _selectedIndex = 4; // Highlight "Discovery" tab
  String _selectedFilter = 'Most Viewed'; // Track the selected filter

  // Mock data for the feed
  final List<Map<String, dynamic>> posts = [
    {
      'username': 'Kobbie Mainoo',
      'profilePic': 'https://assets.manutd.com/AssetPicker/images/0/0/20/87/1333066/Player_Profile_Kobee_Mainoo1719482688199.jpg',
      'timestamp': '6h ago',
      'caption': 'One shot, one goal ⚽🔥',
      'videoUrl': 'https://videos.pexels.com/video-files/15436954/15436954-hd_1906_1080_30fps.mp4',
      'likes': 334,
      'comments': 234,
      'aiRating': '8.7/10',
      'aiDetails': 'Shot Accuracy: 92/100 – Well-placed, tough for the keeper.\n'
          'Shot Power: 88/100 – Strong, fast strike.\n'
          'Positioning: 85/100 – Smart movement before the shot.\n'
          'Quick Tip: Improve shot variety & read the keeper’s positioning!',
    },
    {
      'username': 'Phallon Joyce',
      'profilePic': 'https://assets.manutd.com/AssetPicker/images/0/0/20/88/1333393/91_Phallon_Tullis_Joyce1719823409273.jpg',
      'timestamp': '2h ago',
      'caption': 'Dribbling drill session! Any tips to improve my close control?',
      'videoUrl': 'https://videos.pexels.com/video-files/5449935/5449935-uhd_2560_1440_30fps.mp4',
      'likes': 0,
      'comments': 0,
      'aiRating': '7.5/10',
      'aiDetails': 'Close Control: 78/100 – Good ball retention under pressure.\n'
          'Dribbling Speed: 72/100 – Decent pace, but can be quicker.\n'
          'Body Feints: 70/100 – Effective, but needs more variety.\n'
          'Quick Tip: Focus on quick changes of direction & use both feet!',
    },
  ];

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
      case 4: // Already on Discovery page
        break;
    }
  }

  void _onFilterTapped(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    // In a real app, you would fetch posts based on the selected filter
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
                // Header
                Container(
  width: screenWidth,
  height: screenHeight * 0.15,
  decoration: ShapeDecoration(
    color: const Color(0xFFEF7A49),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(screenWidth * 0.08),
        bottomRight: Radius.circular(screenWidth * 0.08),
      ),
    ),
  ),
  child: const Center(
    child: Text(
      'Discover', 
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),
                // Filter Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFilterButton('Most Viewed', Icons.visibility),
                        const SizedBox(width: 8), // Add spacing between buttons
                        _buildFilterButton('Recent', Icons.access_time),
                        const SizedBox(width: 8),
                        _buildFilterButton('Highest Rated', Icons.star),
                      ],
                    ),
                  ),
                ),
                // Feed of Posts
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostItem(
                      username: post['username'],
                      profilePic: post['profilePic'],
                      timestamp: post['timestamp'],
                      caption: post['caption'],
                      videoUrl: post['videoUrl'],
                      likes: post['likes'],
                      comments: post['comments'],
                      aiRating: post['aiRating'],
                      aiDetails: post['aiDetails'],
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      horizontalPadding: horizontalPadding,
                      key: ValueKey(post['caption']), // Add a unique key to ensure proper state management
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.030),
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

  Widget _buildFilterButton(String filter, IconData icon) {
    final bool isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => _onFilterTapped(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Reduced padding
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEF7A49) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14, // Reduced icon size
              color: isSelected ? Colors.white : const Color(0xFF333333),
            ),
            const SizedBox(width: 6), // Reduced spacing
            Text(
              filter,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF333333),
                fontSize: 12, // Reduced font size
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Post Item Widget
class PostItem extends StatefulWidget {
  final String username;
  final String profilePic;
  final String timestamp;
  final String caption;
  final String videoUrl;
  final int likes;
  final int comments;
  final String? aiRating;
  final String? aiDetails;
  final double screenWidth;
  final double screenHeight;
  final double horizontalPadding;

  const PostItem({
    super.key,
    required this.username,
    required this.profilePic,
    required this.timestamp,
    required this.caption,
    required this.videoUrl,
    required this.likes,
    required this.comments,
    this.aiRating,
    this.aiDetails,
    required this.screenWidth,
    required this.screenHeight,
    required this.horizontalPadding,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          print('Video initialized successfully for ${widget.caption}');
        });
      }).catchError((error) {
        setState(() {
          _errorMessage = 'Failed to initialize video: $error';
          print(_errorMessage);
        });
      });
    _videoController.setLooping(true);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Debug print to verify AI rating data
    print('Post: ${widget.caption}, AI Rating: ${widget.aiRating}, AI Details: ${widget.aiDetails}');

    return Container(
      width: widget.screenWidth - 2 * widget.horizontalPadding,
      margin: const EdgeInsets.only(bottom: 16),
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
                width: widget.screenWidth * 0.11,
                height: widget.screenWidth * 0.11,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.profilePic),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.screenWidth * 0.055),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: TextStyle(
                        color: const Color(0xFF24265F),
                        fontSize: widget.screenWidth * 0.048,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.timestamp,
                      style: TextStyle(
                        color: const Color(0xFFB5BCDB),
                        fontSize: widget.screenWidth * 0.027,
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
            widget.caption,
            style: TextStyle(
              color: const Color(0xFF3D5480),
              fontSize: widget.screenWidth * 0.037,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          // Video Player
          Center(
            child: _errorMessage != null
                ? Container(
                    width: widget.screenWidth * 0.65,
                    height: widget.screenHeight * 0.23,
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
                            width: widget.screenWidth * 0.65,
                            height: widget.screenHeight * 0.23,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: VideoPlayer(_videoController),
                            ),
                          ),
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
                        width: widget.screenWidth * 0.65,
                        height: widget.screenHeight * 0.23,
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
                widget.likes.toString(),
                style: TextStyle(
                  color: const Color(0xFFB5BCDB),
                  fontSize: widget.screenWidth * 0.032,
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
                widget.comments.toString(),
                style: TextStyle(
                  color: Color(0xFFB5BCDB),
                  fontSize: widget.screenWidth * 0.032,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (widget.aiRating != null && widget.aiDetails != null) ...[
            const SizedBox(height: 16),
            // AI Rating Section
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE6D9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '🔥 AI Rating: ${widget.aiRating}\n',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: widget.screenWidth * 0.034,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: widget.aiDetails,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: widget.screenWidth * 0.028,
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
        ],
      ),
    );
  }
}