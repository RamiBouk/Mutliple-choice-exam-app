// import 'package:flutter/material.dart';
// import 'package:study_project/database/models.dart';
// import 'package:study_project/widgets/choices_list.dart';

// class QuestEdit extends StatefulWidget {
//   int index;
//   MyExam exam;
//   QuestEdit({
//     required this.index,
//     required this.exam,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<QuestEdit> createState() => _QuestEditState();
// }

// class _QuestEditState extends State<QuestEdit> {
//   bool isElevated = false;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(20),
//         child: Focus(
//           onFocusChange: (value) => {
//             setState((() {
//               isElevated = !isElevated;
//             }))
//           },
//           child: AnimatedContainer(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Theme.of(context).canvasColor,
//                   boxShadow: isElevated
//                       ? [
//                           BoxShadow(
//                             color: (Theme.of(context).colorScheme ==
//                                     const ColorScheme.dark())
//                                 ? Colors.grey[900]!
//                                 : Colors.grey[400]!,
//                             offset: const Offset(4, 4),
//                             blurRadius: 10,
//                             spreadRadius: 1,
//                           ),
//                           BoxShadow(
//                             color: (Theme.of(context).colorScheme ==
//                                     const ColorScheme.dark())
//                                 ? Colors.grey[800]!
//                                 : Colors.grey[100]!,
//                             offset: const Offset(-4, -4),
//                             blurRadius: 10,
//                             spreadRadius: 1,
//                           ),
//                         ]
//                       : null),
//               duration: const Duration(milliseconds: 500),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(bottom: 10),
//                       child: TextField(
//                         keyboardType: TextInputType.multiline,
//                         maxLines: null,
//                         decoration: InputDecoration(
//                           hintText: "Question",
//                         ),
//                       ),
//                     ),
//                     Row(children: [
//                       Text(
//                         "Choices:",
//                         style: Theme.of(context)
//                             .textTheme
//                             .headline6!
//                             .copyWith(fontWeight: FontWeight.normal),
//                       ),
//                       const Expanded(child: SizedBox()),
//                       const Padding(
//                           padding: EdgeInsets.only(right: 12),
//                           child: Icon(Icons.check))
//                     ]),
//                     ChoicesList(
//                       newchoices: [],
//                       isValid: widget.isValid,
//                     )
//                   ],
//                 ),
//               )),
//         ));
//   }
// }
