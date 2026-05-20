
import 'package:animations/color_shades.dart';
import 'package:animations/color_tokens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetStartedButton extends StatefulWidget {
  final VoidCallback onTap;


  const GetStartedButton({
    super.key,
    required this.onTap,
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
            // color: widget.color,
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,

              //
              colors: [ColorTokens.primary.s60,ColorTokens.primary.s70],//primary60, primary70, primary40 (Shadow color)
            ),
            boxShadow: [
              BoxShadow(
                color: ColorTokens.primary.s40,//tone40
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
                      shadows: [
                        
                        Shadow(color: ColorTokens.primary.s40, offset: const Offset(0, 2.5))],
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
        colorScheme: ColorTokens.lightScheme(),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorTokens.darkScheme(),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
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
        appBar: AppBar(
          title: const Text('Color Shades Explorer'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              GetStartedButton(
                onTap: () {})

              // IconButton(onPressed: () async{

              //  await showDialog(context: context, builder: (context) => AlertDialog(
              //     title: Text("Color Shades Explorer"),
              //     content: Text("This is a demo of the ColorShades class, which generates color shades using both linear interpolation and HCT methods. Check the console for tone maps."),
              //     actions: [
              //       TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Close")),
              //       TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Do not close")),
              //     ],
              //   ));
              // }, icon: Icon(Icons.ad_units))
              // ElevatedButton(
              //   onPressed: () => Navigator.of(context).push(
              //     CupertinoPageRoute(builder: (_) => const _LerpShadesScreen()),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //   ),
              //   child: const Text('Color Lerp', style: TextStyle(fontSize: 16)),
              // ),
              // const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () => Navigator.of(context).push(
              //     CupertinoPageRoute(builder: (_) => const _HctShadesScreen()),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //   ),
              //   child: const Text('Color HCT', style: TextStyle(fontSize: 16)),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LerpShadesScreen extends StatelessWidget {
  const _LerpShadesScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Color Lerp'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        body: _ShadesList(useHct: false),
      );
}

class _HctShadesScreen extends StatelessWidget {
  const _HctShadesScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Color HCT'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        body: _ShadesList(useHct: true),
      );
}

class _ShadesList extends StatelessWidget {
  final bool useHct;

  const _ShadesList({required this.useHct});

  static const _primary =  Color(0xFF34C759);//; Color(0xFFEF5388);
  static const _tones = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 98, 99, 100];

  static String _hex(Color c) =>
      '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  void _printToneMap(ColorShades shades) {
    final label = useHct ? 'HCT' : 'Lerp';
    final map = {for (final t in _tones) t: _hex(useHct ? shades.shadeHct(t) : shades.shade(t))};
    debugPrint('=== Color Tone Map ($label) ===');
    map.forEach((tone, hex) => debugPrint('  Tone $tone: $hex'));
    debugPrint('================================');
  }

  @override
  Widget build(BuildContext context) {
    final shades = ColorShades(_primary);
    _printToneMap(shades);

    return ListView.builder(
      itemCount: _tones.length,
      itemBuilder: (context, index) {
        final tone = _tones[index];
        final color = useHct ? shades.shadeHct(tone) : shades.shade(tone);
        return Container(
          height: 72,
          color: color,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tone $tone',
                style: TextStyle(
                  color: tone >= 40 ? Colors.black87 : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                '${_hex(color)}  •  rgb(${(color.r * 255).round()}, ${(color.g * 255).round()}, ${(color.b * 255).round()})',
                style: TextStyle(
                  color: (tone >= 40 ? Colors.black87 : Colors.white).withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
