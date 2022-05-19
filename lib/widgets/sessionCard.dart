import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:study_project/theme.dart';
import 'package:study_project/views/teacher_waiting.dart';
import 'package:study_project/views/view_session.dart';
import '../database/models.dart';
import 'examCard.dart';
import 'package:study_project/database/controler.dart';

class SessionCardsList extends StatefulWidget {
  final Future<List<MySession>> sessionList;
  @override
  SessionCardsList(
      {Key? key, required Future<List<MySession>> this.sessionList})
      : super(key: key);

  State<SessionCardsList> createState() => _SessionCardsListState();
}

class _SessionCardsListState extends State<SessionCardsList> {
  DatabaseHandler dataBaseHandler = DatabaseHandler();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: FutureBuilder(
            future: widget.sessionList,
            builder: (context, AsyncSnapshot<List<MySession>> sessions) {
              if (sessions.hasData) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: sessions.data?.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return SessionCard(
                      session: sessions.data!.reversed.toList()[index],
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class SessionCard extends StatefulWidget {
  MySession session;
  SessionCard({Key? key, required this.session}) : super(key: key);
  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  late DatabaseHandler dataBaseHandler;
  MyExam exam = MyExam();
  final r = 22.0;

  @override
  void initState() {
    dataBaseHandler = DatabaseHandler();
    dataBaseHandler.initializeDB().whenComplete(() async {
      exam = (await dataBaseHandler.retrieveExam(widget.session.examId)).first;
      setState(() {});
    }).then((value) => super.initState);
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
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
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      widget.session.name.toString(),
                      style: Theme.of(context).textTheme.headline6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
                  // Padding(
                  //   padding: EdgeInsets.all(5),
                  //   child: CircularPercentIndicator(
                  //     radius: r,
                  //     lineWidth: r / 8,
                  //     percent: 0.6,
                  //     center: Text(
                  //       "14.73",
                  //       style: Theme.of(context).textTheme.bodySmall,
                  //     ),
                  //     progressColor: Colors.green,
                  //     backgroundColor: Colors.transparent,
                  //   ),
                  // ),
                ],
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Exam: " + exam.name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "subject: " + exam.subject.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "launched: " + widget.session.time.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ))),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewSession(session: widget.session)),
                    );
                  },
                  child: const Text("View")),
            ]),
          ),
        ));
  }
}
