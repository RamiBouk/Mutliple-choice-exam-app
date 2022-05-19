import 'package:flutter/material.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/widgets/choices_list.dart';
import 'package:study_project/database/controler.dart';
import 'choices_view.dart';
import 'result_choices.dart';

class QuestView extends StatefulWidget {
  int? index;
  MyQuest? quest;
  List<MyChoice>? newChoices;
  bool isValid;
  final Map<int?, List<bool>> choicesboxs;
  bool results = false;
  int correct;
  QuestView({
    this.index,
    this.newChoices,
    required this.choicesboxs,
    required this.quest,
    required this.isValid,
    this.correct = 0,
    this.results = false,
    Key? key,
  }) : super(key: key);

  @override
  State<QuestView> createState() => _QuestViewState();
}

class _QuestViewState extends State<QuestView> {
  bool isElevated = true;
  bool isValidChoices = false;
  late int? index = widget.index;
  late DatabaseHandler questHandler;
  late MyQuest newQuest = MyQuest(statement: "Question");
  bool correctQuest = true;
  TextEditingController tc = TextEditingController();

  @override
  void initState() {
    tc.text = widget.quest?.statement ?? '';
    questHandler = DatabaseHandler();
    widget.newChoices?.forEach((element) {
      var r = widget.choicesboxs[element.choiceId];
      if (r![0] != r[1]) {
        correctQuest = false;
      }
    });

    setState(() {});
    questHandler
        .initializeDB()
        .whenComplete(() async {})
        .then((value) => super.initState);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  Widget iconFromResults(MyChoice? choice) {
    var l = widget.choicesboxs[choice?.choiceId];

    if (l?[0] == l?[1]) {
      if (l![0] == true) {
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      }

      return const Icon(
        Icons.minimize_outlined,
      );
    }
    if (l?[1] == true) {
      return const Icon(
        Icons.check,
        color: Colors.green,
      );
    }
    return const RotationTransition(
        turns: AlwaysStoppedAnimation(45 / 360),
        child: Icon(
          Icons.add_circle,
          color: Colors.red,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).canvasColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(00.2),
                  offset: const Offset(10, 10),
                  blurRadius: 15,
                  spreadRadius: 0.01,
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: widget.results
                        ? correctQuest
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 40,
                              )
                            : const RotationTransition(
                                turns: AlwaysStoppedAnimation(45 / 360),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.red,
                                  size: 40,
                                ))
                        : SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (index! + 1).toString() + "-Question:",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          widget.quest?.points.toString() ?? "error",
                          style: Theme.of(context).textTheme.headline6!,

                          // TextField(
                          //   textAlign: TextAlign.center,
                          //   onChanged: (value) {
                          //     widget.quest?.points = int.parse(value);
                          //   },
                          //   style: TextStyle(fontSize: 25),
                          //   controller: tc2,
                          //   keyboardType: TextInputType.number,
                          //   inputFormatters: <TextInputFormatter>[
                          //     FilteringTextInputFormatter.digitsOnly
                          //   ],
                          // ))
                        ))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 10),
                  child: Text(
                    widget.quest?.statement ?? "error",
                    style: Theme.of(context).textTheme.headline5!,
                  ),
                ),
                Row(children: [
                  Text(
                    "Choices:",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                  const Expanded(child: SizedBox()),
                  widget.results
                      ? const SizedBox()
                      : const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.check))
                ]),
                !widget.results
                    ? ChoicesView(
                        choicesboxs: widget.choicesboxs,
                        newchoices: widget.newChoices,
                        isValid: isValidChoices,
                      )
                    : ResultsChoices(
                        choicesboxs: widget.choicesboxs,
                        newchoices: widget.newChoices,
                        isValid: isValidChoices,
                      ),
              ],
            ),
          )),
    );
  }
}
