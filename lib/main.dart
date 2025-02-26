import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fading Text Animation',
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
      home: FadingTextAnimation(toggleTheme: toggleTheme),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final VoidCallback toggleTheme;
  const FadingTextAnimation({Key? key, required this.toggleTheme})
      : super(key: key);

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  bool _showFrame = false;
  Color _textColor = Colors.black;
  bool _isNavigating = false; // Prevent multiple navigations

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void navigateToSecondScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondFadingAnimation()),
    );
  }

  void pickColor() {
    // Extended list of colors for modern design
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
          title: const Text('Pick a text color'),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _textColor = color;
                  });
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 20,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use Theme.of(context).brightness to set a modern toggle icon.
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50, // New background color for main screen
      appBar: AppBar(
        title: const Text('Fading Text Animation'),
        actions: [
          IconButton(
            icon: Icon(
              isLight ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            ),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: pickColor,
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) {
          if (details.delta.dx < -10 && !_isNavigating) {
            _isNavigating = true;
            navigateToSecondScreen();
          }
        },
        onPanEnd: (details) {
          _isNavigating = false;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      AnimatedOpacity(
                        opacity: _isVisible ? 1.0 : 0.0,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        child: Text(
                          'Hello, Flutter!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: _textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Toggle image frame:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Switch(
                        value: _showFrame,
                        onChanged: (value) {
                          setState(() {
                            _showFrame = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: _showFrame
                            ? BoxDecoration(
                                border: Border.all(
                                  color: Colors.deepPurple,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              )
                            : null,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/image1.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: const Icon(Icons.animation_outlined),
      ),
    );
  }
}

class SecondFadingAnimation extends StatefulWidget {
  @override
  _SecondFadingAnimationState createState() => _SecondFadingAnimationState();
}

class _SecondFadingAnimationState extends State<SecondFadingAnimation> {
  bool _isVisible = true;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50, // New background color for second screen
      appBar: AppBar(
        title: const Text('Second Fading Animation'),
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(seconds: 2),
          child: const Text(
            'Welcome to the second screen!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: const Icon(Icons.animation_outlined),
      ),
    );
  }
}
