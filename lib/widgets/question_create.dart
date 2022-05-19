import 'package:flutter/material.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/widgets/choices_list.dart';
import 'package:study_project/database/controler.dart';
import 'package:flutter/services.dart';

class QuestCreate extends StatefulWidget {
  int? index;
  MyQuest? quest;
  List<MyChoice>? newChoices;
  QuestCreate({
    this.index,
    this.newChoices,
    required this.quest,
    Key? key,
  }) : super(key: key);

  @override
  State<QuestCreate> createState() => _QuestCreateState();
}

class _QuestCreateState extends State<QuestCreate> {
  bool isElevated = true;
  bool isValidChoices = false;
  late int? index = widget.index;
  late DatabaseHandler questHandler;
  late MyQuest newQuest = MyQuest(statement: "Question");
  TextEditingController tc = TextEditingController();
  TextEditingController tc2 = TextEditingController();

  @override
  void initState() {
    tc.text = widget.quest?.statement ?? '';
    tc2.text = widget.quest?.points.toString() ?? 'Note';

    questHandler = DatabaseHandler();
    questHandler
        .initializeDB()
        .whenComplete(() async {})
        .then((value) => super.initState);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tc.dispose();
    tc2.dispose();

    super.dispose();
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
                    SizedBox(
                        width: 100,
                        // height: 40,
                        child: TextField(
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            widget.quest?.points = int.parse(value);
                          },
                          style: TextStyle(fontSize: 25),
                          controller: tc2,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: tc,
                    onChanged: (value) {
                      widget.quest?.statement = value;
                    },
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
                  const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.check))
                ]),
                ChoicesList(
                  newchoices: widget.newChoices,
                  isValid: isValidChoices,
                ),
              ],
            ),
          )),
    );
  }
}
