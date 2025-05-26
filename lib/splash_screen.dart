import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controllers for different elements
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  // Animations for smooth transitions
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Create animations with curves for smooth motion
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Start the splash sequence
    _startSplashSequence();
  }

  // Orchestrates the splash screen animations and navigation
  void _startSplashSequence() async {
    // Start logo animation immediately
    _logoController.forward();

    // Wait 500ms then start text animation
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    // Wait another 500ms then start progress animation
    await Future.delayed(const Duration(milliseconds: 500));
    _progressController.forward();

    // Wait for all animations to complete plus extra time for viewing
    await Future.delayed(const Duration(milliseconds: 3000));

    // Navigate to next screen (replace with your login/home screen)
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PlaceholderHomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    // Clean up animation controllers to prevent memory leaks
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Create gradient background matching the design
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF312e81), // Indigo-900
              Color(0xFF581c87), // Purple-900
              Color(0xFF9d174d), // Pink-800
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spacer to push content up slightly
                const Spacer(flex: 2),

                // Animated Logo Section
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: Opacity(
                        opacity: _logoAnimation.value,
                        child: _buildLogoSection(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Animated App Name and Tagline
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _textAnimation.value)),
                        child: _buildAppNameSection(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 60),

                // Feature Icons Row
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textAnimation.value,
                      child: _buildFeatureIcons(),
                    );
                  },
                ),

                const Spacer(flex: 2),

                // Animated Progress Section
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _progressAnimation.value,
                      child: _buildProgressSection(),
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the main logo with accent icon
  Widget _buildLogoSection() {
    return Stack(
      children: [
        // Main logo container
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            // Add subtle backdrop blur effect
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.school,
            size: 50,
            color: Colors.white,
          ),
        ),
        // Accent QR code icon in top-right corner
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF10b981), // Emerald-500
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.qr_code,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Builds the app name and tagline section
  Widget _buildAppNameSection() {
    return Column(
      children: [
        // Main app name
        const Text(
          'Geleza',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        // Tagline
        Text(
          'GET EDUCATED',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 3,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  // Builds the row of feature icons
  Widget _buildFeatureIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFeatureIcon(Icons.access_time),
        const SizedBox(width: 24),
        _buildFeatureIcon(Icons.qr_code_scanner),
        const SizedBox(width: 24),
        _buildFeatureIcon(Icons.people),
      ],
    );
  }

  // Helper to build individual feature icons
  Widget _buildFeatureIcon(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        size: 24,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }

  // Builds the progress indicator and loading text
  Widget _buildProgressSection() {
    return Column(
      children: [
        // Progress bar container
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                width: 200 * _progressAnimation.value,
                height: 4,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF34d399), // Emerald-400
                      Color(0xFF22d3ee), // Cyan-400
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Loading text
        Text(
          'Streamlining your attendance experience...',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 24),
        // Footer text
        Text(
          'Secure • Efficient • Modern',
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.4),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

// Placeholder screen for navigation - replace with your actual login/home screen
class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geleza - Home'),
        backgroundColor: const Color(0xFF312e81),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 64,
              color: Color(0xFF312e81),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to Geleza!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF312e81),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Replace this with your login/home screen',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
