import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum LifeLine {
  fiftyFifty,
  userPoll,
  reset,
  skip,
}

class LifeLineAnimationScreen extends StatefulWidget {
  const LifeLineAnimationScreen({super.key});

  @override
  State<LifeLineAnimationScreen> createState() => _LifeLineAnimationScreenState();
}

class _LifeLineAnimationScreenState extends State<LifeLineAnimationScreen> {
  final Set<LifeLine> _usedLifeLines = {};

  void _useLifeLine(LifeLine lifeLine) {
    if (_usedLifeLines.contains(lifeLine)) return;
    setState(() {
      _usedLifeLines.add(lifeLine);
    });
  }

  bool _isUsed(LifeLine lifeLine) => _usedLifeLines.contains(lifeLine);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _LifeLinesBar(
              usedLifeLines: _usedLifeLines,
              onUse: _useLifeLine,
              isUsed: _isUsed,
            ),
          ),
        ],
      ),
    );
  }
}

class _LifeLinesBar extends StatelessWidget {
  const _LifeLinesBar({
    required this.usedLifeLines,
    required this.onUse,
    required this.isUsed,
  });

  final Set<LifeLine> usedLifeLines;
  final void Function(LifeLine) onUse;
  final bool Function(LifeLine) isUsed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 5.0
      ),
      height: 100,
      color: const Color(0xFFC9C9C9),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = (constraints.maxWidth)  * (0.2);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LifeLineCard(
                lifeLine: LifeLine.fiftyFifty,
                assetPath: 'assets/fifty_fifty.svg',
                label: '50/50',
                used: isUsed(LifeLine.fiftyFifty),
                onTap: () => onUse(LifeLine.fiftyFifty),
                width: cardWidth,   
              ),
              _LifeLineCard(
                width: cardWidth,
                lifeLine: LifeLine.userPoll,
                assetPath: 'assets/user_poll.svg',
                label: 'User Poll',
                used: isUsed(LifeLine.userPoll),
                onTap: () => onUse(LifeLine.userPoll),
              ),
              _LifeLineCard(
                width: cardWidth,
                lifeLine: LifeLine.reset,
                assetPath: 'assets/reset.svg',
                label: 'Reset',
                used: isUsed(LifeLine.reset),
                onTap: () => onUse(LifeLine.reset),
              ),
              _LifeLineCard(
                width: cardWidth,
                lifeLine: LifeLine.skip,
                assetPath: 'assets/skip.svg',
                label: 'Skip',
                used: isUsed(LifeLine.skip),
                onTap: () => onUse(LifeLine.skip),
              ),
            ],
          );
        }
      ),
    );
  }
}

class _LifeLineCard extends StatefulWidget {
  const _LifeLineCard({
    required this.lifeLine,
    required this.assetPath,
    required this.label,
    required this.used,
    required this.onTap,
    required this.width,
  });

  final LifeLine lifeLine;
  final String assetPath;
  final String label;
  final bool used;
  final VoidCallback onTap;
  final double width;

  @override
  State<_LifeLineCard> createState() => _LifeLineCardState();
}

class _LifeLineCardState extends State<_LifeLineCard> with TickerProviderStateMixin {
  
  final Duration animationDuration = const Duration(milliseconds: 400);
  late final  Duration iconEndAnimationDuration =  Duration(milliseconds: animationDuration.inMilliseconds ~/ 10);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: animationDuration,
  );

   late final AnimationController _iconEndController = AnimationController(
    vsync: this,
    duration: iconEndAnimationDuration,
  );


  late final Animation<double> _animation = Tween<double>(begin: iconContainerHeight * (-1), end: 0).animate(CurvedAnimation(parent: _controller, curve: Interval(0, 0.9, curve: Curves.easeOut)));
  
  final double iconContainerHeight = 50.0;

  late final Animation<double> _coinAnimation = Tween<double>(begin: -iconContainerHeight, end: 5).animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.9, curve: Curves.easeOut)));

  late final Animation<double> _coinAnimationEnd = Tween<double>(begin: 0, end: 5).animate(CurvedAnimation(parent: _controller, curve: Interval(0.9, 1.0, curve: Curves.easeOut)));


  late final Animation<double> _iconAnimation = Tween<double>(begin: 0, end: -50).animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.9, curve: Curves.easeOut)));


  late final Animation<double> _iconAnimationEnd = Tween<double>(begin: 0, end: 5).animate(CurvedAnimation(parent: _iconEndController, curve: Curves.easeOut));

  @override
  void dispose() {
    _controller.dispose();
    _iconEndController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: AnimatedOpacity(
         duration: const Duration(milliseconds: 250),
              opacity: widget.used ? 0.35 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: widget.used ? null : () async{
                await _controller.forward();
                await _iconEndController.forward();
                await Future.delayed( const Duration(milliseconds: 500));
             
                await _controller.reverse();
                await _iconEndController.reverse();
        
                widget.onTap();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Container(
                     height: 50,
                      width: widget.width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                      ),
                      
                    ),
                    
                    
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Positioned(
                          bottom: _animation.value,
                          child: child!,
                        );
                      },
                      child: Container(
                           height: iconContainerHeight,
                            width: widget.width,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEFCF0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            
                          ),
                    ),


                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    
                    
                    return AnimatedBuilder(
                      animation: _iconEndController,
                      builder: (context,_) {

                        
                        

                        return Positioned(
                          

                          top : _iconAnimation.value + _iconAnimationEnd.value,
                          child: child!,
                        );
                      }
                    );
                  },
                  child: Container(
                   padding: EdgeInsets.all(12),
                   width: widget.width,
                             height: 50,
                             child: SvgPicture.asset(
                               widget.assetPath,
                               width: 24,
                               height: 24,
                             ),
                           ),
                ),

                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                final double coinY = _coinAnimation.value - _coinAnimationEnd.value;
                                return Positioned(
                                  bottom: coinY,
                                  child: child!,
                                 );
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                width: widget.width,
                                    height: 50,
                                     child: SvgPicture.asset(
                                        'assets/coin.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                   ),
                              
                            )
                
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF151719),
                letterSpacing: 0.5,
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
