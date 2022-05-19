import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/constants.dart';
import '../database/controler.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:study_project/widgets/question_create.dart';
import 'package:study_project/theme.dart';
import 'package:study_project/widgets/slider.dart';

class EditExamPage extends StatefulWidget {
  MyExam exam;
  EditExamPage({
    required this.exam,
    Key? key,
  }) : super(key: key);

  @override
  State<EditExamPage> createState() => _EditExamPageState();
}

bool a = false;

class _EditExamPageState extends State<EditExamPage> {
  late DatabaseHandler dataBaseHandler;
  bool isValid = true;
  List<MyQuest> newQuests = [];
  List<List<MyChoice>> newchoices = [];
  List<MyQuest> quests = [];
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
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
      setState(() {});
    }).then((value) => super.initState);
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
          "Edit Exam:",
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
                  widget.exam.name = value;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.text_snippet_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: widget.exam.name,
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  widget.exam.subject = value;
                },
                decoration: const InputDecoration().copyWith(
                  isDense: true,
                  prefixIcon: const Icon(Icons.book),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: widget.exam.subject,
                ),
              )),
          newQuests.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newQuests.length,
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
                child: const Padding(
                    padding: EdgeInsets.all(0),
                    child: Icon(Icons.add, size: 30)),
                onPressed: () {
                  setState(() {
                    newQuests.add(MyQuest(statement: ""));
                    newchoices.add([MyChoice(), MyChoice()]);
                    print(newQuests.toString());
                  });
                  sc.animateTo(sc.position.maxScrollExtent + 200,
                      curve: Curves.linear,
                      duration: const Duration(milliseconds: 400));
                }),
          ),
          const SizedBox(height: 20),
          Center(
              child: SizedBox(
                  width: 300,
                  child: MySlider(
                    onSlide: () async {
                      Navigator.of(context).pop();
                      var id = await dataBaseHandler.insertExams([widget.exam]);
                      for (var i = 0; i < newQuests.length; i++) {
                        int questId = await dataBaseHandler
                            .insertQuest([newQuests[i]], id);

                        newchoices[i].removeWhere(
                            (element) => element.statement == null);
                        await dataBaseHandler.insertChoice(
                            newchoices[i], questId);
                      }
                      setState(() {
                        final provider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        a = !a;
                        provider.reload();
                      });
                    },
                    text: "Slide to add exam",
                  )))
        ],
      ),
    ));
  }
}
