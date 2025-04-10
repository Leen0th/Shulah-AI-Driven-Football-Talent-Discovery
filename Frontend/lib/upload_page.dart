import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'discovery.dart';
import 'player_analytics.dart';
import 'past_matches.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  int _selectedIndex = 2;
  final bool _isMatchVideo = false;
  File? _selectedVideo;
  final TextEditingController _captionController = TextEditingController();
  String? _selectedTag;
  String? _analysisResult;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _backendResponse;

  final List<String> tags = ['Dribbling', 'Shooting', 'Passing', 'Defense'];
  final String backendUrl = 'http://localhost:8080'; // Update with your backend URL

  Future<void> _pickVideo() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedVideo = File(pickedFile.path);
          _analysisResult = null;
          _backendResponse = null;
        });
        print('Video selected: ${pickedFile.path}');
      } else {
        print('No video selected');
      }
    } catch (e) {
      print('Error picking video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
      );
    }
  }

  Future<void> _submitVideoForAnalysis() async {
    if (_selectedVideo == null || _captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video and add a caption')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
      _backendResponse = null;
    });

    try {
      // Prepare the multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$backendUrl/api/uploadVideo'),
      );

      // Add video file
      request.files.add(
        await http.MultipartFile.fromPath('file', _selectedVideo!.path),
      );

      // Add caption and tag
      request.fields['caption'] = _captionController.text;
      if (_selectedTag != null) {
        request.fields['tag'] = _selectedTag!;
      }

      // Send the request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResult = jsonDecode(responseData);

      if (response.statusCode == 200) {
        setState(() {
          _backendResponse = jsonResult;
          var analysis = jsonResult['analysisResult'];
          _analysisResult = "Passing Accuracy: ${(analysis['passingAccuracy'] * 100).toStringAsFixed(2)}%\n" "Player Speeds: ${analysis['playerSpeeds'].toString()}\n" "Ball Possession: ${analysis['ballPossessionTime'].toString()}";
        });
      } else {
        setState(() {
          _analysisResult = 'Error: Server responded with status ${response.statusCode}';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to analyze video: ${jsonResult['error']}')),
        );
      }
    } catch (e) {
      setState(() {
        _analysisResult = 'Error: Failed to connect to the server. Please ensure the backend is running. Error: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to the server. Please try again later.')),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _confirmPost() async {
    if (_backendResponse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please analyze the video first')),
      );
      return;
    }

    try {
      // Construct the video URL from the local path
      String videoPath = _backendResponse!['videoPath'];
      String fileName = videoPath.split('/').last; // Extract the filename
      String videoUrl = '$backendUrl/uploads/$fileName'; // Construct the URL

      // Send confirmation to backend
      var response = await http.post(
        Uri.parse('$backendUrl/api/confirm-post'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'caption': _backendResponse!['caption'],
          'tag': _backendResponse!['tag'],
          'videoPath': videoUrl, // Use the constructed URL
        }),
      );

      var jsonResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResult['message'])),
        );
        // Reset the form
        setState(() {
          _selectedVideo = null;
          _captionController.clear();
          _selectedTag = null;
          _analysisResult = null;
          _backendResponse = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload post: Status ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to confirm post. Please try again.')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
        break;
      case 1:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const PlayerAnalyticsScreen()));
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const PastMatchesScreen()));
        break;
      case 4:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Discovery()));
        break;
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.032;
    final double verticalPadding = screenHeight * 0.030;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      'Upload',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildToggleButton('Match Video', _isMatchVideo, () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Coming Soon! Match Video uploads will be available in a future update.'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }),
                          const SizedBox(width: 8),
                          _buildToggleButton('Training Session', !_isMatchVideo, () {
                            // No action needed since Training Session is the default
                          }),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickVideo,
                        child: Container(
                          width: screenWidth - 2 * horizontalPadding,
                          height: screenHeight * 0.2,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFE0E0E0), style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  color: const Color(0xFFEF7A49),
                                  size: screenWidth * 0.08,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Click to Upload Video',
                                  style: TextStyle(
                                    color: Color(0xFFEF7A49),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  '(Max. File size: 25 MB)',
                                  style: TextStyle(
                                    color: Color(0xFFB5BCDB),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (_selectedVideo != null)
                                  const Text(
                                    'Video Selected',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Caption',
                        style: TextStyle(
                          color: Color(0xFF24265F),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _captionController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          hintText: 'Write a caption...',
                          hintStyle: const TextStyle(color: Color(0xFFB5BCDB)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Tags',
                        style: TextStyle(
                          color: Color(0xFF24265F),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedTag,
                        style: const TextStyle(color: Colors.black),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                        ),
                        hint: const Text('Select a tag', style: TextStyle(color: Color(0xFFB5BCDB))),
                        items: tags.map((tag) {
                          return DropdownMenuItem<String>(
                            value: tag,
                            child: Text(
                              tag,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTag = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_isAnalyzing)
                        const Center(child: CircularProgressIndicator())
                      else if (_analysisResult != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3F9E9E9E),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Analysis Results',
                                style: TextStyle(
                                  color: Color(0xFF24265F),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _analysisResult!,
                                style: const TextStyle(
                                  color: Color(0xFF24265F),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _confirmPost,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF7A49),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Confirm and Upload Post',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _submitVideoForAnalysis,
        backgroundColor: const Color(0xFFEF7A49),
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }

  Widget _buildToggleButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEF7A49) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF333333),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}