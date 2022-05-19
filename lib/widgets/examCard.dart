import 'package:flutter/material.dart';
import 'package:study_project/theme.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/views/edit_exam.dart';
import 'package:study_project/views/launch_session_view.dart';

class ExamCard extends StatelessWidget {
  final MyExam exam;
  ExamCard({Key? key, required this.exam}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Stack(children: [
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(5, 5),
                        blurRadius: 5,
                        spreadRadius: 1),
                  ]),
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 25, bottom: 10, right: 25),
                    child: Text(
                      exam.name.toString(),
                      style: Theme.of(context).textTheme.headline5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Subject: " + exam.subject.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              "Created: " + exam.created,
                              style: Theme.of(context).textTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )),
                  )),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditExamPage(exam: exam)),
                        );
                      },
                      child: const Text("View")),
                  ElevatedButton(
                    child: const Text("Launch"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => launchPage(exam: exam)),
                      );
                    },
                  )
                ]),
              )),
          Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 5,
              height: 5,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        ]));
  }
}

class ExamCardsList extends StatefulWidget {
  final Future<List<MyExam>> examsList;
  @override
  ExamCardsList({Key? key, required Future<List<MyExam>> this.examsList})
      : super(key: key);

  State<ExamCardsList> createState() => _ExamCardsListState();
}

class _ExamCardsListState extends State<ExamCardsList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: FutureBuilder(
            future: widget.examsList,
            builder: (context, AsyncSnapshot<List<MyExam>> exams) {
              if (exams.hasData) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: exams.data?.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: EdgeInsets.only(bottom: 15, left: 10),
                        child: Hero(
                            tag: exams.data!.reversed.toList()[index].examId ??
                                0,
                            child: ExamCard(
                                exam: exams.data!.reversed.toList()[index])));
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
              ;
            }));
  }
}

class ExamCard2 extends StatelessWidget {
  final MyExam exam;
  ExamCard2({Key? key, required this.exam}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Stack(children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: (Theme.of(context).colorScheme ==
                              const ColorScheme.dark())
                          ? Colors.grey[900]!
                          : Colors.grey[400]!,
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]),
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 25, bottom: 10, right: 25),
                    child: Text(
                      exam.name.toString(),
                      style: Theme.of(context).textTheme.headline5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Subject: " + exam.subject.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              "Created: " + exam.created,
                              style: Theme.of(context).textTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )),
                  )),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditExamPage(exam: exam)),
                        );
                      },
                      child: const Text("View")),
                ]),
              )),
          Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 5,
              height: 5,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        ]));
  }
}
