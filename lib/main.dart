import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a text color'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _textColor = Colors.red;
                  });
                  Navigator.of(context).pop();
                },
                child: const CircleAvatar(backgroundColor: Colors.red),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _textColor = Colors.green;
                  });
                  Navigator.of(context).pop();
                },
                child: const CircleAvatar(backgroundColor: Colors.green),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _textColor = Colors.blue;
                  });
                  Navigator.of(context).pop();
                },
                child: const CircleAvatar(backgroundColor: Colors.blue),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Swipe left to navigate to the second screen
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          navigateToSecondScreen();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fading Text Animation'),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: widget.toggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: pickColor,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: Text(
                  'Hello, Flutter!',
                  style: TextStyle(fontSize: 24, color: _textColor),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Toggle image frame:'),
              Switch(
                value: _showFrame,
                onChanged: (value) {
                  setState(() {
                    _showFrame = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Container(
                decoration: _showFrame
                    ? BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://via.placeholder.com/150',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: toggleVisibility,
          child: const Icon(Icons.play_arrow),
        ),
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
      appBar: AppBar(
        title: const Text('Second Fading Animation'),
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(seconds: 2),
          child: const Text(
            'Welcome to the second screen!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}