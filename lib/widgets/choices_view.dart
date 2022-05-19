import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_project/constants.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/widgets/choices_list.dart';
import 'package:study_project/database/controler.dart';

class ChoicesView extends StatefulWidget {
  List<MyChoice>? newchoices;
  bool isValid;
  final Map<int?, List<bool>> choicesboxs;

  ChoicesView({
    required this.choicesboxs,
    required this.newchoices,
    required this.isValid,
    Key? key,
  }) : super(key: key);

  @override
  State<ChoicesView> createState() => _ChoicesListState();
}

class _ChoicesListState extends State<ChoicesView> {
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

  addChoiceToList(int index) {
    TextEditingController tc = TextEditingController();
    tc.text = widget.newchoices?[index].statement ?? '';
    print("ADDED widhet num $index");
    setState(() {
      choices.add(StatefulBuilder(builder: (BuildContext context, setState) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(
              child:
                  Padding(padding: EdgeInsets.all(10), child: Text(tc.text))),
          Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Checkbox(
                  value: widget.choicesboxs[widget.newchoices?[index].choiceId]
                      ?[0],
                  onChanged: (value) {
                    setState(() {
                      widget.choicesboxs
                          .update(widget.newchoices?[index].choiceId, (v) {
                        return [!v[0], v[1]];
                      });
                    });
                  })),
        ]);
      }));
    });
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
