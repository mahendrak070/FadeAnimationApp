import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  // Global text color for both screens
  Color _globalTextColor = Colors.white;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void updateGlobalTextColor(Color color) {
    setState(() {
      _globalTextColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        toggleTheme: toggleTheme,
        globalTextColor: _globalTextColor,
        updateGlobalTextColor: updateGlobalTextColor,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final Color globalTextColor;
  final Function(Color) updateGlobalTextColor;
  const HomeScreen({
    Key? key,
    required this.toggleTheme,
    required this.globalTextColor,
    required this.updateGlobalTextColor,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Animation states for home screen
  bool _textVisible = true;
  bool _fadingImageVisible = true;
  double _rotationAngle = 0.0;
  bool _showFrame = false;
  double _animationDuration = 1.0;
  bool _isNavigating = false;
  static const double imageSize = 220; // All images use this size

  void toggleTextVisibility() {
    setState(() {
      _textVisible = !_textVisible;
    });
  }

  void toggleFadingImage() {
    setState(() {
      _fadingImageVisible = !_fadingImageVisible;
    });
  }

  void rotateImage() {
    setState(() {
      _rotationAngle += math.pi / 2; // Rotate 90° each tap
    });
  }

  void toggleFrame() {
    setState(() {
      _showFrame = !_showFrame;
    });
  }

  void updateAnimationDuration(double value) {
    setState(() {
      _animationDuration = value;
    });
  }

  void pickColor() {
    // Extended palette of colors
    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a Text Color'),
          content: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors.map((color) {
              return GestureDetector(
                onTap: () {
                  widget.updateGlobalTextColor(color);
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 22,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Swipe left to navigate to the second screen.
  void _handleSwipe(DragUpdateDetails details) {
    if (details.delta.dx < -10 && !_isNavigating) {
      _isNavigating = true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SecondScreen(globalTextColor: widget.globalTextColor),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Adjust the gradient based on current theme brightness.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundGradient = LinearGradient(
      colors: isDark
          ? [Colors.grey.shade900, Colors.black87]
          : [Colors.indigo.shade700, Colors.blue.shade300],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: GestureDetector(
            onPanUpdate: _handleSwipe,
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Custom header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Animations',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.palette_outlined,
                                color: Colors.white),
                            onPressed: pickColor,
                          ),
                          IconButton(
                            icon: Icon(
                              isDark
                                  ? Icons.light_mode_outlined
                                  : Icons.dark_mode_outlined,
                              color: Colors.white,
                            ),
                            onPressed: widget.toggleTheme,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Fading Text Animation Section
                  SectionTitle(
                      title: 'Fading Text Animation',
                      textColor: widget.globalTextColor),
                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    opacity: _textVisible ? 1.0 : 0.0,
                    duration: Duration(
                        seconds: _animationDuration.toInt()),
                    curve: Curves.easeInOut,
                    child: Text(
                      'Hello, Creative Flutter!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: widget.globalTextColor,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: toggleTextVisibility,
                    child: const Text('Toggle Text'),
                  ),
                  const Divider(
                      height: 40, thickness: 1.5, color: Colors.white70),
                  // Fading Image Animation Section
                  SectionTitle(
                      title: 'Fading Image Animation',
                      textColor: widget.globalTextColor),
                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    opacity: _fadingImageVisible ? 1.0 : 0.0,
                    duration: Duration(
                        seconds: _animationDuration.toInt()),
                    curve: Curves.easeIn,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/image1.png',
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: toggleFadingImage,
                    child: const Text('Toggle Image'),
                  ),
                  const Divider(
                      height: 40, thickness: 1.5, color: Colors.white70),
                  // Rotating Image Animation Section
                  SectionTitle(
                      title: 'Rotating Image Animation',
                      textColor: widget.globalTextColor),
                  const SizedBox(height: 8),
                  AnimatedRotation(
                    turns: _rotationAngle / (2 * math.pi),
                    duration: Duration(
                        seconds: _animationDuration.toInt()),
                    curve: Curves.elasticOut,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/image1.png',
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: rotateImage,
                    child: const Text('Rotate Image'),
                  ),
                  const Divider(
                      height: 40, thickness: 1.5, color: Colors.white70),
                  // Toggleable Image Frame Section
                  SectionTitle(
                      title: 'Image with Toggleable Frame',
                      textColor: widget.globalTextColor),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text(
                      'Show Frame',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: _showFrame,
                    onChanged: (value) => toggleFrame(),
                  ),
                  Container(
                    decoration: _showFrame
                        ? BoxDecoration(
                            border: Border.all(
                                color: Colors.white70, width: 3),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
                          )
                        : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/image1.png',
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Divider(
                      height: 40, thickness: 1.5, color: Colors.white70),
                  // Animation Duration Slider Section
                  Text(
                    'Animation Duration: ${_animationDuration.toStringAsFixed(1)} sec',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Slider(
                    value: _animationDuration,
                    min: 1,
                    max: 5,
                    divisions: 8,
                    label: _animationDuration.toStringAsFixed(1),
                    onChanged: updateAnimationDuration,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white54,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Swipe left for more!',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final Color textColor;
  const SectionTitle({Key? key, required this.title, required this.textColor})
      : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final Color globalTextColor;
  const SecondScreen({Key? key, required this.globalTextColor})
      : super(key: key);
  
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
    with SingleTickerProviderStateMixin {
  bool _textVisible = true;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    );
    _controller.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void toggleVisibility() {
    setState(() {
      _textVisible = !_textVisible;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Adjust the background gradient based on current theme.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundGradient = LinearGradient(
      colors: isDark
          ? [Colors.deepOrange.shade700, Colors.amber.shade700]
          : [Colors.deepOrange.shade300, Colors.amber.shade200],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Center(
            child: AnimatedOpacity(
              opacity: _textVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  'Welcome to the Second Screen!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: widget.globalTextColor,
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        foregroundColor: Colors.black87,
        onPressed: toggleVisibility,
        child: const Icon(Icons.visibility),
      ),
    );
  }
}