import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/widgets/examCard.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:study_project/constants.dart';
import 'package:study_project/widgets/slider.dart';
import 'waitingRoom.dart';
import 'package:intl/intl.dart';
import 'package:study_project/widgets/widgets.dart';

class launchPage extends StatefulWidget {
  MyExam exam;
  launchPage({Key? key, required this.exam}) : super(key: key);

  @override
  State<launchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<launchPage> {
  Duration duration = const Duration(minutes: 15);
  late MySession session;

  @override
  void initState() {
    // TODO: implement initState
    session = MySession(
        examId: widget.exam.examId,
        time: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        duration: Duration(minutes: 15).toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Launch session "),
        ),
        body: Column(children: [
          SizedBox(
            height: 200,
            child: Hero(
                tag: widget.exam.examId ?? 0,
                child: ExamCard2(exam: widget.exam)),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  session.name = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelText: 'give the session a name',
                ),
              )),
          Center(
            child: Text(
              "Duration:   ",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 150,
            child: CupertinoTimerPicker(
              initialTimerDuration: duration,
              mode: CupertinoTimerPickerMode.hm,
              onTimerDurationChanged: (value) {
                print(value);
                session.duration = value.toString();
              },
            ),
          ),
          const Expanded(child: SizedBox()),
          Padding(
              padding: EdgeInsets.all(20).copyWith(bottom: 100),
              child: Center(
                  child: SizedBox(
                      width: 300,
                      child: MySlider(
                        onSlide: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => waitingRoom(
                                      session: session,
                                      exam: widget.exam,
                                    )),
                          );
                        },
                        text: "Slide to start Session",
                      ))))
        ]));
  }
}
