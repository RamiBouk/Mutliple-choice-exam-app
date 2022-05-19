import 'package:flutter/material.dart';
import 'package:study_project/constants.dart';
import 'package:study_project/widgets/examCard.dart';
import 'package:study_project/widgets/sessionCard.dart';
import 'package:study_project/widgets/bottomNavbar.dart';
import '../database/controler.dart';
import '../theme.dart';
import 'package:provider/provider.dart';
import 'package:particles_flutter/particles_flutter.dart';

import 'student.dart';
import 'dart:math' as math; // import this

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool a = false;

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late DatabaseHandler examHandler;
  late AnimationController controller;
  bool lightTheme = true;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
    examHandler = DatabaseHandler();
    examHandler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 30,
                ),
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Student()),
                    )),
            body: Stack(
              children: [
                CircularParticle(
                  width: w,
                  height: h,
                  awayRadius: w / 1,
                  numberOfParticles: 20,
                  speedOfParticles: 0.5,
                  maxParticleSize: 20,
                  particleColor:
                      Theme.of(context).brightness == Brightness.light
                          ? MyConsts.BLUE.withOpacity(0.1)
                          : MyConsts.LIGHT_BLUE.withOpacity(0.1),
                  awayAnimationDuration: Duration(milliseconds: 60000),
                  awayAnimationCurve: Curves.easeInOutBack,
                  onTapAnimation: true,
                  isRandSize: true,
                  isRandomColor: false,
                  connectDots: true,
                  // randColorList: [
                  // Colors.red.withAlpha(210),
                  // Colors.white.withAlpha(210),
                  // Colors.yellow.withAlpha(210),
                  // Colors.green.withAlpha(210),
                  // ],
                  enableHover: true,
                  hoverColor: Colors.black,
                  hoverRadius: 90,
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Rami Boukaroura',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          const Expanded(child: SizedBox()),
                          Container(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    final provider = Provider.of<ThemeProvider>(
                                        context,
                                        listen: false);
                                    a = !a;
                                    provider.toggleTheme(a);
                                  });
                                },
                                icon: Icon(Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Icons.brightness_2
                                    : Icons.brightness_4)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Exams',
                                style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 240,
                        child: ExamCardsList(
                          examsList: examHandler.retrieveExams(),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Sessions',
                                style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 240,
                      child: SessionCardsList(
                        sessionList: examHandler.retrieveSessions(),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
                BottomNavBarV2(),
              ],
            )));
  }
}
