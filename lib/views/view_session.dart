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

class ViewSession extends StatefulWidget {
  MySession session;
  ViewSession({required this.session, Key? key}) : super(key: key);

  @override
  State<ViewSession> createState() => _ViewSessionState();
}

class _ViewSessionState extends State<ViewSession> {
  List<MyAnswer> answers = [];
  MyExam exam = MyExam();

  String serverIP = '';
  String data = '';
  bool first = true;
  TextStyle? correctstyle, wrongstyle;
  late DatabaseHandler dataBaseHandler;
  List<MyQuest> newQuests = [];
  List<List<MyChoice>> newchoices = [];
  List<Map<int?, List<bool>>> choicesboxs = [];

  Map<MyQuest, List<MyChoice>> examData = {};
  // for receiving

  @override
  void initState() {
    dataBaseHandler = DatabaseHandler();
    dataBaseHandler.initializeDB().whenComplete(() async {
      exam = (await dataBaseHandler.retrieveExam(widget.session.examId)).first;
      newQuests = await dataBaseHandler.retrieveQuest(exam.examId);
      for (MyQuest quest in newQuests) {
        List<MyChoice> choices =
            await dataBaseHandler.retrieveChoices(quest.questId);
        newchoices.add(choices);
      }
      //exam choices and questions retrieved
      //retrieving answers and choicesbox
      answers = await dataBaseHandler.retrieveAnswers(widget.session.sessionId);
      //got the answers
      for (var answer in answers) {
        Map<int?, List<bool>> choicesbox = {};

        //for an answer
        List<MyUserChoice> userChoices =
            await dataBaseHandler.retrieveUserChoices(answer.answerId);
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
        choicesboxs.add(choicesbox);
        setState(() {});
      }
    }).then((value) => super.initState);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
      ),
      body: Column(children: [
        ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          itemCount: answers.length,
          itemBuilder: (BuildContext context, int index) {
            int correct = 0, tottale = 0;
            newQuests.forEach((element) {
              print(element.points);
              tottale += element.points;
            });
            for (int i = 0; i < newQuests.length; i++) {
              bool questcrct = true;
              correct += newQuests[i].points;
              newchoices[i].forEach((element) {
                var r = choicesboxs[index][element.choiceId];
                if (r![0] != r[1]) {
                  questcrct = false;
                }
              });
              if (!questcrct) correct -= newQuests[i].points;
            }

            return ListTile(
              leading: Text(
                answers[index].name.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(correct.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.green)),
                  Text("/"),
                  Text(tottale.toString(),
                      style: Theme.of(context).textTheme.headline6)
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewResults(
                          name: answers[index].name,
                          group: answers[index].grp,
                          choicesboxs: choicesboxs[index],
                          exam: exam,
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
