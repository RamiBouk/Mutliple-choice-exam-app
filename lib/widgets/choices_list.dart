import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_project/constants.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/widgets/choices_list.dart';
import 'package:study_project/database/controler.dart';

class ChoicesList extends StatefulWidget {
  List<MyChoice>? newchoices;
  bool isValid;
  ChoicesList({
    required this.newchoices,
    required this.isValid,
    Key? key,
  }) : super(key: key);

  @override
  State<ChoicesList> createState() => _ChoicesListState();
}

class _ChoicesListState extends State<ChoicesList> {
  late DatabaseHandler choiceHandler;
  @override
  void initState() {
    choiceHandler = DatabaseHandler();
    choiceHandler.initializeDB().whenComplete(() async {
      int l = widget.newchoices?.length ?? 2;
      for (var i = 0; i < l; i++) {
        addChoiceToList(i);
      }
    }).then((value) => super.initState);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  bool first = false;
  bool last = false;

  addChoiceToList(int index) {
    TextEditingController tc = TextEditingController();
    tc.text = widget.newchoices?[index].statement ?? '';
    print("ADDED widhet num $index");
    choices.add(StatefulBuilder(builder: (BuildContext context, setState) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: tc,
            onChanged: (value) {
              print("______________________________$index");
              if (index == 0) this.first = true;
              if (index + 1 == choices.length) widget.isValid = true;

              widget.newchoices?[index].statement = value;
              if (
                  // index + 1 == choices.length &&
                  widget.isValid && first) {
                widget.isValid = false;
                widget.newchoices?.add(MyChoice());
                addChoiceToList(choices.length);
                setState((() {}));
              }
            },
            onTap: () {},
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                isDense: true,
                hintText: "choice",
                helperText: (index + 1 == choices.length && index > 1)
                    ? "*Leave empty if done"
                    : ""),
          ),
        )),
        Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Checkbox(
                value: widget.newchoices?[index].correct == 0 ? false : true,
                onChanged: (value) {
                  setState(() {
                    widget.newchoices?[index].correct = value! ? 1 : 0;
                  });
                })),
      ]);
    }));
    setState(() {});
  }

  List<Widget> choices = [];
  List<bool?> rightChoice = [];
  bool hey = true;
  @override
  Widget build(BuildContext context) {
    return choices.isEmpty
        ? SizedBox()
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
