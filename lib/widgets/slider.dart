import 'package:flutter/material.dart';
import 'package:study_project/constants.dart';
import 'package:study_project/database/controler.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class MySlider extends StatefulWidget {
  Function() onSlide;
  String text;

  MySlider({
    required this.onSlide,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  State<MySlider> createState() => _ChoicesListState();
}

class _ChoicesListState extends State<MySlider> {
  late DatabaseHandler choiceHandler;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfirmationSlider(
      width: 300,
      height: 75,
      foregroundColor: Theme.of(context).primaryColor,
      backgroundColor: Theme.of(context).canvasColor,
      textStyle: Theme.of(context).textTheme.bodyText1,
      sliderButtonContent: const Icon(
        Icons.arrow_forward_ios_sharp,
        color: Colors.black,
      ),
      text: widget.text,
      onConfirmation: widget.onSlide,
    );
  }
}
