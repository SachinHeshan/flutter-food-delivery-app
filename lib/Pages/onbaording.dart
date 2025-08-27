import 'package:flutter/material.dart';
import 'signin.dart';

void main() {
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery',
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Poppins'),
      home: const Onboarding(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _onboardingPages = [
    const OnboardingPage(
      title: "All your favorites",
      description:
          "Get all your loved foods in one once place, you just place the order we do the rest",
      image: "assets/images/food delevary.jpg",
    ),
    const OnboardingPage(
      title: "Order from chosen chef",
      description:
          "Get all your loved foods in one once place, you just place the order we do the rest",
      image: "assets/images/food delevary.jpg",
    ),
    const OnboardingPage(
      title: "Free delivery offers",
      description:
          "Get all your loved foods in one once place, you just place the order we do the rest",
      image: "assets/images/food delevary.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button at top right
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {
                    // Skip to last page
                    _pageController.jumpToPage(_onboardingPages.length - 1);
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color:
                          _currentPage == _onboardingPages.length - 1
                              ? Colors.transparent
                              : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            // Image and content area
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingPages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingScreen(page: _onboardingPages[index]);
                },
              ),
            ),

            // Page indicator
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
            ),

            // Next/Get Started button
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child:
                  _currentPage == _onboardingPages.length - 1
                      ? _buildGetStartedButton()
                      : _buildNextButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 89, 0),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          "NEXT",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          "GET STARTED",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _onboardingPages.length; i++) {
      indicators.add(
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i ? const Color.fromARGB(255, 255, 0, 0) : Colors.grey.shade300,
          ),
        ),
      );
    }
    return indicators;
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });
}

class OnboardingScreen extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingScreen({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            height: 300,
            margin: const EdgeInsets.only(bottom: 40),
            child: Image.asset(
              page.image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.fastfood,
                    size: 100,
                    color: Colors.orange,
                  ),
                );
              },
            ),
          ),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
