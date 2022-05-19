import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_project/constants.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/widgets/choices_list.dart';
import 'package:study_project/database/controler.dart';

class ResultsChoices extends StatefulWidget {
  List<MyChoice>? newchoices;
  bool isValid;
  final Map<int?, List<bool>> choicesboxs;

  ResultsChoices({
    required this.choicesboxs,
    required this.newchoices,
    required this.isValid,
    Key? key,
  }) : super(key: key);

  @override
  State<ResultsChoices> createState() => _ChoicesListState();
}

class _ChoicesListState extends State<ResultsChoices> {
  late DatabaseHandler choiceHandler;
  @override
  void initState() {
    super.initState();
    choiceHandler = DatabaseHandler();
    choiceHandler.initializeDB().whenComplete(() async {
      int l = widget.newchoices?.length ?? 2;
      for (var i = 0; i < l; i++) {
        addChoiceToList(i);
      }
    }).then((value) => {});
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  bool first = false;
  bool last = false;
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

  Color colorFromResults(MyChoice? choice) {
    var l = widget.choicesboxs[choice?.choiceId];

    if (l?[0] != l?[1]) {
      if (l?[0] == true) return Colors.red;
      return const Color.fromARGB(255, 255, 255, 255);
    }
    if (l?[0] == true) {
      return Colors.green;
    } else {
      return const Color.fromARGB(255, 255, 255, 255);
    }
    ;
  }

  addChoiceToList(int index) {
    TextEditingController tc = TextEditingController();
    tc.text = widget.newchoices?[index].statement ?? '';
    setState(() {
      choices.add(StatefulBuilder(builder: (BuildContext context, setState) {
        return Padding(
            padding: EdgeInsets.only(bottom: 5, top: 5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                    color: colorFromResults(widget.newchoices?[index])
                        .withOpacity(0.2),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(tc.text))),
                          Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Checkbox(
                                  activeColor: Colors.grey,
                                  value: widget.choicesboxs[
                                      widget.newchoices?[index].choiceId]?[0],
                                  onChanged: (value) {})),
                          Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child:
                                  iconFromResults(widget.newchoices?[index])),
                        ]))));
      }));
    });
  }

  List<Widget> choices = [];
  List<bool?> rightChoice = [];
  bool hey = true;
  @override
  Widget build(BuildContext context) {
    return choices.isEmpty
        ? const SizedBox()
        : ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: choices.length,
            itemBuilder: (BuildContext context, int index) {
              return choices[index];
            },
          );
  }
}
