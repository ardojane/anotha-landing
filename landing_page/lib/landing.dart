import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(NaviGoApp());
}

class NaviGoApp extends StatelessWidget {
  const NaviGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NaviGo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  List<Map<String, String>> introData = [
    {
      "title": "NaviGo",
      "subtitle": "Your smart, real-time navigation assistant",
      "image": "assets/logo.png",
      "buttonText": "Get Started",
    },
    {
      "title": "Stay ahead with real-time updates",
      "image": "assets/real_time.gif",
      "buttonText": "Next",
    },
    {
      "title": "Customized navigation",
      "image": "assets/custom_navigation.gif",
      "buttonText": "Next",
    },
    {
      "title":
          "Navigate with options to reduce fuel consumption and carbon emissions.",
      "image": "assets/setting_lp.gif",
      "buttonText": "Next",
    },
    {
      "title": "A quick guide on how to use the application",
      "image": "assets/search_lp.jpg",
      "subtitle": "Step 1: Search for your destination",
      "buttonText": "Next",
    },
    {
      "title": "A quick guide on how to use the application",
      "image": "assets/destination_lp.jpg",
      "subtitle":
          "Step 2: Click the check ✓ button to confirm your destination",
      "buttonText": "Next",
    },
    {
      "title": "A quick guide on how to use the application",
      "image": "assets/transpo.jpg",
      "subtitle": "Step 3: Choose your mode of transportation",
      "buttonText": "Next",
    },
    {
      "title": "A quick guide on how to use the application",
      "image": "assets/go_lp.jpg",
      "subtitle": "Step 4: Click the 'Start Session' & your route is ready!",
      "buttonText": "Next",
    },
    {
      "title": "Allow us to access your location",
      "image": "",
      "buttonText": "Allow",
    },
  ];

  void _nextPage() {
    if (_currentPage < introData.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // When finished, navigate to the home screen or another page
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle denied permission
    }
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: introData.length,
        itemBuilder: (context, index) {
          if (index == introData.length - 1) {
            return _buildLocationAccessPage(); // Show the location permission page
          }
          return IntroContent(
            title: introData[index]['title'],
            subtitle: introData[index]['subtitle'],
            image: introData[index]['image'],
            buttonText: introData[index]['buttonText'],
            onNext: _nextPage,
          );
        },
      ),
    );
  }

  Widget _buildLocationAccessPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on, size: 100, color: Colors.blue),
        SizedBox(height: 20),
        Text("Allow us to access your location", textAlign: TextAlign.center),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text("Deny"),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _requestLocationPermission,
              child: Text("Allow"),
            ),
          ],
        ),
      ],
    );
  }
}

class IntroContent extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? image;
  final String? buttonText;
  final VoidCallback onNext;

  const IntroContent({
    super.key,
    this.title,
    this.subtitle,
    this.image,
    this.buttonText,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Ensure each page has a white background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (image != null && image!.isNotEmpty)
              Image.asset(image!, width: 250, height: 250, fit: BoxFit.contain),
            SizedBox(height: 20),
            if (title != null)
              Text(
                title!,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  subtitle!,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(
                  0xFF4169E1,
                ), // Set button color to #4169E1
                foregroundColor: Colors.white, // Set text color to white
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Optional: Rounded corners
                ),
              ),
              child: Text(buttonText ?? "Next", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
