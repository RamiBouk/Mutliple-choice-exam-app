import 'package:flutter/material.dart';
import 'package:study_project/constants.dart';
import 'package:study_project/database/models.dart';

import '../database/controler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:study_project/widgets/question_create.dart';
import 'package:study_project/theme.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:study_project/widgets/slider.dart';

class AddExamPage extends StatefulWidget {
  const AddExamPage({Key? key}) : super(key: key);

  @override
  State<AddExamPage> createState() => _AddExamPageState();
}

bool a = false;

class _AddExamPageState extends State<AddExamPage> {
  late DatabaseHandler dataBaseHandler;
  bool isValid = false;

  List<MyQuest> newQuests = [MyQuest(statement: ""), MyQuest(statement: "")];
  List<List<MyChoice>> newchoices = [
    [MyChoice(), MyChoice()],
    [MyChoice(), MyChoice()]
  ];

  late MyExam newExam = MyExam(
      name: "name",
      subject: "subject",
      created: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      modified: "modified");

  @override
  void initState() {
    dataBaseHandler = DatabaseHandler();
    dataBaseHandler
        .initializeDB()
        .whenComplete(() async {})
        .then((value) => super.initState);
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
          "Create Exam:",
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
                  newExam.name = value;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.text_snippet_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelText: 'Exam Name',
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  newExam.subject = value;
                },
                decoration: const InputDecoration().copyWith(
                  isDense: true,
                  prefixIcon: const Icon(Icons.book),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelText: 'Subject',
                ),
              )),
          ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: newQuests.length - 1,
            itemBuilder: (BuildContext context, int index) {
              return QuestCreate(
                index: index,
                quest: newQuests[index],
                newChoices: newchoices[index],
              );
            },
          ),
          Center(
            child: MaterialButton(
                shape: const CircleBorder(),
                child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.add, color: MyConsts.BLUE, size: 30)),
                onPressed: () {
                  setState(
                    () {
                      newQuests.add(MyQuest(statement: ""));
                      newchoices.add([MyChoice(), MyChoice()]);
                    },
                  );

                  sc.animateTo(sc.position.maxScrollExtent + 200,
                      curve: Curves.linear,
                      duration: const Duration(milliseconds: 400));
                }),
          ),
          const Divider(
            height: 30,
          ),
          Center(
              child: SizedBox(
                  width: 300,
                  child: MySlider(
                    onSlide: () async {
                      setState(() {
                        final provider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        a = !a;
                        provider.reload();
                      });

                      var id = await dataBaseHandler.insertExams([newExam]);

                      for (var i = 0; i < newQuests.length - 1; i++) {
                        if (newQuests[i].statement.isNotEmpty) {
                          int questId = await dataBaseHandler
                              .insertQuest([newQuests[i]], id);

                          newchoices[i].removeWhere(
                              (element) => element.statement.isEmpty);
                          await dataBaseHandler.insertChoice(
                              newchoices[i], questId);
                        }
                      }
                      Navigator.of(context).pop();
                    },
                    text: "Slide to add exam",
                  )))
        ],
      ),
    ));
  }
}
