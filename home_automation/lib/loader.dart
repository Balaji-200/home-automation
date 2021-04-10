import 'package:flutter/material.dart';
class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(seconds: 2))
      ..repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.black54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 180,
              height: 180,
              child: Center(
                  child: Container(
                    height: 180,
                    width: 180,
                    child: Icon(
                      Icons.lightbulb,
                      size: 100,
                      color: Colors.white,
                    ),
                    decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.indigo),
                  )),
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                    color: Colors.yellow,
                    blurRadius: _animation.value,
                    spreadRadius: _animation.value),
              ]),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Text(
                'No Internet',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
