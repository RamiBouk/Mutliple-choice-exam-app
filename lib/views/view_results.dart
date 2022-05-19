import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/constants.dart';
import 'package:study_project/widgets/questio_view.dart';
import 'package:study_project/widgets/sessionCard.dart';
import '../database/controler.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:study_project/widgets/question_create.dart';
import 'package:study_project/theme.dart';

class ViewResults extends StatefulWidget {
  String? name;
  String? group;
  MyExam? exam;
  List<MyQuest> newQuests;
  List<List<MyChoice>> newchoices;
  Map<int?, List<bool>> choicesboxs;

  ViewResults({
    required this.exam,
    required this.newQuests,
    required this.newchoices,
    required this.choicesboxs,
    required this.name,
    required this.group,
    Key? key,
  }) : super(key: key);

  @override
  State<ViewResults> createState() => _ViewResultsState();
}

bool a = false;

class _ViewResultsState extends State<ViewResults> {
  late DatabaseHandler dataBaseHandler;
  bool isValid = true;
  final int rightChoice = 1;
  final int wrongChoice = -1;
  int correct = 0;
  int tottale = 0;
  late MyExam newExam = MyExam(
      name: "name",
      subject: "subject",
      created: "created",
      modified: "modified");

  @override
  void initState() {
    widget.newQuests.forEach((element) {
      print(element.points);
      tottale += element.points;
    });
    for (int i = 0; i < widget.newQuests.length; i++) {
      bool questcrct = true;
      correct += widget.newQuests[i].points;
      print("correct $correct");
      widget.newchoices[i].forEach((element) {
        var r = widget.choicesboxs[element.choiceId];
        if (r![0] != r[1]) {
          questcrct = false;
        }
      });
      if (!questcrct) {
        correct -= widget.newQuests[i].points;
      }
    }
    super.initState();
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
          "Results of  Exam:",
        ),
      ),
      body: ListView(
        controller: sc,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  correct.toString() + "/" + tottale.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold),
                )),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Name: " + widget.name.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 20),
              )),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Group: " + widget.group.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 20),
              )),
          ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.newQuests.length,
            itemBuilder: (BuildContext context, int index) {
              return QuestView(
                correct: correct,
                results: true,
                choicesboxs: widget.choicesboxs,
                index: index,
                quest: widget.newQuests[index],
                newChoices: widget.newchoices[index],
                isValid: true,
              );
            },
          ),
        ],
      ),
    ));
  }
}
