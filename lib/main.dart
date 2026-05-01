
import 'package:animations/color_shades.dart';
import 'package:animations/screens/life_line_animation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetStartedButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color color;

  const GetStartedButton({
    super.key,
    required this.onTap,
    this.color = const Color(0xFFEF5388),
  });

  @override
  State<GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<GetStartedButton>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  late final AnimationController _pressController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 80),
  );

  late final Animation<double> _shadowOffset = Tween<double>(
    begin: 4.5,
    end: 1.5,
  ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));

  Animation<double> _shine1(double width) =>
      Tween<double>(begin: -40.0, end: width + 20.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  Animation<double> _shine2(double width) =>
      Tween<double>(begin: -22.0, end: width + 38.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  Color get _shadowColor => Color.lerp(widget.color, Colors.black, 0.30)!;
  Color get _bottomColor => Color.lerp(widget.color, Colors.white, 0.1)!;

  @override
  void dispose() {
    _controller.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        widget.onTap.call();
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => CartAnimationScreen())
        // );
      },
      onTapDown: (_) {
        // print("Tapped down");
        _pressController.forward();
      },
      onTapUp: (_) {
        // print("Tapped up");
        _pressController.reverse();
      },
      onTapCancel: () {
        // print("Tapped cancel");
        _pressController.reverse();
      },
      child: AnimatedBuilder(
        animation: _shadowOffset,
        builder: (context, child) => Container(
          height: 50,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [widget.color, _bottomColor],
            ),
            boxShadow: [
              BoxShadow(
                color: _shadowColor,
                offset: Offset(0, _shadowOffset.value),
                blurRadius: 0,
              ),
            ],
          ),
          child: child,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Positioned(
                        left: _shine1(w).value,
                        top: 0,
                        child: Transform.rotate(
                          alignment: Alignment.topRight,
                          angle: 25 * 3.14159 / 180,
                          child: Container(width: 13, height: 100, color: Colors.white.withValues(alpha: 0.3)),
                        ),
                      ),
                      Positioned(
                        left: _shine2(w).value,
                        top: 0,
                        child: Transform.rotate(
                          alignment: Alignment.topRight,
                          angle: 25 * 3.14159 / 180,
                          child: Container(width: 8, height: 100, color: Colors.white.withValues(alpha: 0.1)),
                        ),
                      ),
                      child!,
                    ],
                  );
                },
                child: Center(
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Candal',
                      letterSpacing: 0.15,
                      shadows: [Shadow(color: _shadowColor, offset: const Offset(0, 2.5))],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      builder: (context, child) {
      return SafeArea(
        top: false,
        child: child!,
      );
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  final ScrollController scrollController = ScrollController();
  late AnimationController animationController = AnimationController(vsync: this);

  @override
  void dispose() {
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  double minMaxNormalize(double value, {double min = 0, double max = 210}) {
    return (value - min) / (max - min);
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset <= 210) {
        final normalized = minMaxNormalize(scrollController.offset);
        animationController.value = normalized;
        print('scroll offset: ${scrollController.offset}, normalized: $normalized');
      }
      else {
        if (animationController.value != 1.0) {
          
        animationController.value = 1.0;
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
      top: false,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(onPressed: () {

        //   Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => CartAnimationScreen())
        //   );
        // }),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: GetStartedButton(onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => LifeLineAnimationScreen())
                  );
                }),
              ),
            )

          ],
        ),
        // body: Padding(
        //   padding: EdgeInsetsGeometry.only(
        //     top: MediaQuery.of(context).padding.top
        //   ),
        //   child: _ShadesList(),
        // ),
      ),
    );
  }
}

class _ShadesList extends StatelessWidget {
  static const _primary = Color(0xFFEF5388);
  static const _tones = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 98, 99, 100];

  @override
  Widget build(BuildContext context) {
    final shades = ColorShades(_primary);
    return ListView.builder(
      itemCount: _tones.length,
      itemBuilder: (context, index) {
        final tone = _tones[index];
        final color = shades.shade(tone);
        return Container(
          height: 72,
          color: color,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            'Tone $tone',
            style: TextStyle(
              color: tone >= 40 ? Colors.black87 : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }
}
