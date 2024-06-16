import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  late Animation _animation;
  late AnimationController _animationController;
  var _size = [100.0,150.0,200.0,250.0];

  @override
  void initState(){
    super.initState();

    _animationController = AnimationController(vsync:this,duration: Duration(seconds: 3));
    _animation = Tween(begin: 0.0,end: 1.0).animate(_animationController);

    _animationController.addListener(() { });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6A5BEC),
      body: Center(
        child: Stack(
            alignment: Alignment.center,
            children: _size.map((radius) => Container(
              width: radius * _animation.value,
              height: radius * _animation.value,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade900.withOpacity(1.0 - _animation.value)
              ),
            )
            ).toList()
        ),
      ),
    );
  }
}