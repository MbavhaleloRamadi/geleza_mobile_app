import 'package:flutter/material.dart';
import 'package:geleza_mobile_app_student_use/splash_screen.dart';
// Import the splash screen (you'll need to create splash_screen.dart file)
// import 'screens/splash_screen.dart';

void main() {
  runApp(const GelezaApp());
}

class GelezaApp extends StatelessWidget {
  const GelezaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App configuration
      title: 'Geleza - Student Timesheet App',
      debugShowCheckedModeBanner: false, // Remove debug banner for cleaner look

      // App theme configuration
      theme: ThemeData(
        // Primary color scheme based on our splash screen
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF312e81), // Indigo-900 from our design
          brightness: Brightness.light,
        ),
        useMaterial3: true,

        // Custom app bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF312e81),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        // Custom elevated button theme for consistency
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF312e81),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),

      // Set splash screen as the initial route
      home: const SplashScreen(),

      // Define named routes for navigation (you can expand this later)
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const PlaceholderHomeScreen(),
        // Add more routes as you build other screens
        // '/login': (context) => const LoginScreen(),
        // '/qr-scanner': (context) => const QRScannerScreen(),
        // '/leave-request': (context) => const LeaveRequestScreen(),
      },
    );
  }
}

// Splash Screen Widget
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

    // Initialize animation controllers with different durations
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

    // Create smooth animations with easing curves
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

    // Start the splash screen sequence
    _startSplashSequence();
  }

  // Orchestrates the animation sequence and navigation
  void _startSplashSequence() async {
    // Start logo animation immediately
    _logoController.forward();

    // Delay then start text animation
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    // Delay then start progress animation
    await Future.delayed(const Duration(milliseconds: 500));
    _progressController.forward();

    // Wait for animations to complete plus viewing time
    await Future.delayed(const Duration(milliseconds: 3000));

    // Navigate to home screen (replace with login screen later)
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PlaceholderHomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Create the gradient background matching our design
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
                // Push content slightly above center
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

  // Builds the main logo with QR accent icon
  Widget _buildLogoSection() {
    return Stack(
      children: [
        // Main logo container with glassmorphism effect
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.school, // Education/graduation icon
            size: 50,
            color: Colors.white,
          ),
        ),
        // QR code accent icon positioned in top-right
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF10b981), // Emerald-500 accent color
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
        // Main app name with custom styling
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
        // Tagline explaining the app name
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

  // Builds the row of feature icons representing app capabilities
  Widget _buildFeatureIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFeatureIcon(Icons.access_time), // Time tracking
        const SizedBox(width: 24),
        _buildFeatureIcon(Icons.qr_code_scanner), // QR scanning
        const SizedBox(width: 24),
        _buildFeatureIcon(Icons.people), // User management
      ],
    );
  }

  // Helper method to build consistent feature icons
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

  // Builds the animated progress bar and loading text
  Widget _buildProgressSection() {
    return Column(
      children: [
        // Progress bar with gradient fill
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
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
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
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Loading message
        Text(
          'Streamlining your attendance experience...',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 24),
        // Footer tagline
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

// Temporary placeholder screen - replace with actual screens later
class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geleza - Home'),
        centerTitle: true,
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
              'Your timesheet management solution',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Next: Implement login and dashboard screens',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
