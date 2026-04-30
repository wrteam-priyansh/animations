import 'package:flutter/material.dart';


class CartAnimationScreen extends StatefulWidget {
  const CartAnimationScreen({super.key});

  @override
  State<CartAnimationScreen> createState() => _CartAnimationScreenState();
}

class _CartAnimationScreenState extends State<CartAnimationScreen> with TickerProviderStateMixin{
  late AnimationController _animationController;

 late  Animation<Offset> _slideAnimation;

 late Animation<double> _opacityAnimatable ;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this,duration: Duration(milliseconds:250));
    _slideAnimation =  Tween<Offset>(
    begin: Offset(0, -1.0),
    end: Offset.zero
  ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  _opacityAnimatable = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        title: Text("S**k my kiss"),
        actions: [
          IconButton(onPressed: () {
              _animationController.forward();
          }, icon: Icon(Icons.forest))
        ],
      ),
      body: Stack(
        children: [

          
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                bottom: 100
              ),
              height: 50,
              width: MediaQuery.of(context).size.width * (0.5),
              decoration: BoxDecoration(
                color: Colors.grey ,
               borderRadius: BorderRadius.circular(20) 

              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsetsGeometry.only(
                bottom: 105
              ),
              child: FadeTransition(
                opacity: _opacityAnimatable,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: CircleAvatar(
                    radius: 20,
                  ),
                ),
              ),
            ),
          )



        ],
      ),
    );
  }
}