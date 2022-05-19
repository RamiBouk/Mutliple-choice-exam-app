import 'package:flutter/material.dart';
import 'package:study_project/constants.dart';
import 'package:study_project/views/bookmark_page.dart';
import 'package:study_project/views/home_page.dart';
import 'package:study_project/views/add_exam.dart';
import 'package:study_project/views/add_exam.dart';

class BottomNavBarV2 extends StatefulWidget {
  @override
  _BottomNavBarV2State createState() => _BottomNavBarV2State();
}

class _BottomNavBarV2State extends State<BottomNavBarV2> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: SizedBox(
            width: size.width,
            height: 60,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(size.width, 80),
                  painter: BNBCustomPainter(),
                ),
                SizedBox(
                  width: size.width,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            splashRadius: 25,
                            icon: const Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddExamPage()),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.20,
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            splashRadius: 25,
                            icon: const Icon(
                              Icons.bookmark,
                              size: 27,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage()),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = MyConsts.BLUE
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BNBCustomPainterTEST extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = MyConsts.DARK_BLUE
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(00, 15); // Start
    path.lineTo(size.width * 0.40, 15);

    path.arcToPoint(Offset(size.width * 0.6, 15),
        radius: const Radius.circular(5), clockwise: false);

    path.lineTo(size.width, 15);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class card extends StatefulWidget {
  card({Key? key}) : super(key: key);

  @override
  State<card> createState() => _cardState();
}

class _cardState extends State<card> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
