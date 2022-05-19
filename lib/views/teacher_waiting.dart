import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/database/controler.dart';

import 'package:study_project/views/edit_exam.dart';
import 'package:study_project/views/passExam.dart';
import 'dart:io';
import 'package:wifi/wifi.dart';
import 'package:provider/provider.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'dart:convert';
import 'package:study_project/networking.dart';
import 'view_results.dart';
import 'package:study_project/theme.dart';
import '';

bool a = false;

class TeacherWaiting extends StatefulWidget {
  MyExam exam;
  MySession session;
  TeacherWaiting({required this.exam, required this.session, Key? key})
      : super(key: key);

  @override
  State<TeacherWaiting> createState() => _TeacherWaitingState();
}

class _TeacherWaitingState extends State<TeacherWaiting> {
  Duration parseDuration(String? s) {
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    List<String> parts = s!.split(':');
    print(parts);
    hours = int.parse(parts[0]);
    minutes = int.parse(parts[1]);
    seconds = double.parse(parts[2]).toInt();
    print("seconds $seconds.toInt()");
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  List<MyAnswer> answers = [];
  List<JsonAnswer?> jsonAnswers = [];
  bool done = false;

  Future<ServerSocket> serverFuture = ServerSocket.bind('0.0.0.0', 55555);
  dynamic ss;

  String serverIP = '';
  String data = '';
  bool first = true;
  TextStyle? correctstyle, wrongstyle;
  late DatabaseHandler dataBaseHandler;
  List<MyQuest> newQuests = [];
  List<List<MyChoice>> newchoices = [];
  final Map<int?, List<bool>> choicesboxs = {};

  Map<MyQuest, List<MyChoice>> examData = {};
  void finish() async {
    (await serverFuture).close();
  }

  // for receiving
  void startServer() {
    serverFuture.then((ServerSocket server) {
      this.ss = server;
      server.listen(
        (Socket socket) {
          socket.listen((List<int> data) {
            this.data = String.fromCharCodes(data);
            JsonAnswer jsonAnswer = JsonAnswer.fromMap(json.decode(this.data));
            print(jsonAnswer.toMap());
            print("receibinh");

            jsonAnswers.add(jsonAnswer);
            answers.add(jsonAnswer.answer);
            print("_____________added");
            Map<int?, List<bool>> choicesbox = {};

            //for an answer

            setState(() {});

            dataBaseHandler.initializeDB().whenComplete(() async {
              int? id = await dataBaseHandler.insertAnswer(
                  answers, widget.session.sessionId);
              List<int?> ids = jsonAnswer.choicesIds.cast<int?>();
              dataBaseHandler.insertUserChoice(ids, id);
              List<MyUserChoice> userChoices = await dataBaseHandler
                  .retrieveUserChoices(jsonAnswer.answer.answerId);
              newchoices.forEach((choices) {
                choices.forEach((choice) {
                  bool isin = false;
                  for (var userChoice in userChoices) {
                    if (choice.choiceId == userChoice.choiceId) {
                      isin = true;
                      break;
                    }
                    isin = false;
                  }
                  choicesbox[choice.choiceId] = [isin, choice.correct == 1];
                });
              });
            });

            try {
              setState(() {});
            } catch (e) {
              print(e);
            }

            if (done) {
              server.close();
              return;
            }
          });
          return;
        },
      );
    });
  }

  @override
  void initState() {
    dataBaseHandler = DatabaseHandler();
    dataBaseHandler.initializeDB().whenComplete(() async {
      newQuests = await dataBaseHandler.retrieveQuest(widget.exam.examId);
      for (MyQuest quest in newQuests) {
        List<MyChoice> choices =
            await dataBaseHandler.retrieveChoices(quest.questId);
        newchoices.add(choices);
      }
      widget.session.examId = widget.exam.examId;
      widget.session.sessionId =
          await dataBaseHandler.insertSession([widget.session]);
      setState(() {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        a = !a;
        provider.reload();
      });
    }).then((value) => super.initState);
    startServer();
  }

  @override
  void dispose() {
    done = true;
    finish();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(parseDuration(widget.session.duration));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
      ),
      body: Column(children: [
        TweenAnimationBuilder<Duration>(
            duration: Duration(minutes: 15),
            tween: Tween(begin: Duration(minutes: 15), end: Duration.zero),
            onEnd: () {
              print('Timer ended');
            },
            builder: (BuildContext context, Duration value, Widget? child) {
              final minutes = value.inMinutes;
              final seconds = value.inSeconds % 60;
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text('$minutes:$seconds',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 30)));
            }),
        ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          itemCount: answers.length,
          itemBuilder: (BuildContext context, int index) {
            // int correct = 0, tottale = 0;

            // newQuests.forEach((element) {
            //   print(element.points);
            //   tottale += element.points;
            // });
            // for (int i = 0; i < newQuests.length; i++) {
            //   bool questcrct = true;
            //   correct += newQuests[i].points;
            //   newchoices[i].forEach((element) {
            //     var r = choicesboxs[element.choiceId];
            //     if (r![0] != r[1]) {
            //       questcrct = false;
            //     }
            //   });
            //   if (!questcrct) correct -= newQuests[i].points;
            // }
            return ListTile(
              leading: Text(
                answers[index].name.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text(correct.toString(),
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .headline6!
                  //         .copyWith(color: Colors.green)),
                  // Text("   "),
                  // Text(answers[index].wrong.toString(),
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .headline6!
                  //         .copyWith(color: Colors.red)),
                ],
              ),
              onTap: () {
                for (var list in newchoices) {
                  for (var choice in list) {
                    int? id = choice.choiceId;

                    choicesboxs[id] = [
                      jsonAnswers[index]!.choicesIds.contains(id),
                      choice.correct == 1
                    ];
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewResults(
                          name: answers[index].name,
                          group: answers[index].grp,
                          choicesboxs: choicesboxs,
                          exam: widget.exam,
                          newQuests: newQuests,
                          newchoices: newchoices)),
                );
              },
            );
          },
        )
      ]),
    );
  }
}
