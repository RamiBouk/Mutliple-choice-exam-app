import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/widgets/questio_view.dart';
import 'package:study_project/widgets/slider.dart';
import '../database/controler.dart';
import 'view_results.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class PassExamPage extends StatefulWidget {
  String ip;
  MyExam? exam;
  List<MyQuest> newQuests;
  List<List<MyChoice>> newchoices;
  PassExamPage({
    required this.exam,
    required this.newQuests,
    required this.newchoices,
    this.ip = "0.0.0.0",
    Key? key,
  }) : super(key: key);

  @override
  State<PassExamPage> createState() => _PassExamPageState();
}

bool a = false;

class _PassExamPageState extends State<PassExamPage> {
  late DatabaseHandler dataBaseHandler;
  TcpSocketConnection socketConnection = TcpSocketConnection("0.0.0.0", 55555);

  bool isValid = true;
  final int rightChoice = 1;
  final int wrongChoice = -1;
  final Map<int?, List<bool>> choicesboxs = {};
  MyAnswer answer = MyAnswer();
  late MyExam newExam = MyExam(
      name: "name",
      subject: "subject",
      created: "created",
      modified: "modified");

  @override
  void initState() {
    for (var list in widget.newchoices) {
      for (var choice in list) {
        int? id = choice.choiceId;
        print(choice.correct);
        choicesboxs[id] = [false, choice.correct == 1];
      }
    }
    startConnection(widget.ip);
    super.initState();
  }

  void startConnection(String ip) async {
    socketConnection = TcpSocketConnection(ip, 55555);
    socketConnection.enableConsolePrint(
        true); //use this to see in the console what's happening
    if (await socketConnection.canConnect(1000, attempts: 5)) {
      //check if it's possible to connect to the endpoint
      await socketConnection.connect(1000, "", () {}, attempts: 3);
    }
  }

  int n = 1;

  bool isElevated = false;
  ScrollController sc = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pass Exam:",
        ),
      ),
      body: ListView(
        controller: sc,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  answer.name = value;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.text_snippet_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelText: 'Name',
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  answer.grp = value;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.text_snippet_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelText: 'Group',
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Exam: " + widget.exam!.name,
                style: Theme.of(context).textTheme.headline5,
              )),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Subject: " + widget.exam!.subject,
                style: Theme.of(context).textTheme.headline5,
              )),
          ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.newQuests.length,
            itemBuilder: (BuildContext context, int index) {
              return QuestView(
                choicesboxs: choicesboxs,
                index: index,
                quest: widget.newQuests[index],
                newChoices: widget.newchoices[index],
                isValid: true,
              );
            },
          ),
          const SizedBox(height: 20),
          Center(
              child: SizedBox(
                  width: 300,
                  child: MySlider(
                    onSlide: () async {
                      choicesboxs.forEach((key, value) {
                        if (value[0] == value[1] && value[0] == true)
                          answer.correct++;
                        if (value[0] != value[1] && value[0] == true)
                          answer.wrong++;
                      });
                      JsonAnswer jsonAnswer =
                          JsonAnswer(answer: answer, choicesboxs: choicesboxs);
                      socketConnection
                          .sendMessage(json.encode(jsonAnswer.toMap()));
                      Navigator.of(context).popUntil((route) => route.isFirst);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewResults(
                                name: jsonAnswer.answer.name,
                                group: jsonAnswer.answer.grp,
                                choicesboxs: choicesboxs,
                                exam: widget.exam,
                                newQuests: widget.newQuests,
                                newchoices: widget.newchoices)),
                      );
                    },
                    text: "Slide if done",
                  )))
        ],
      ),
    ));
  }
}
