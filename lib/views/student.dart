import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:study_project/database/models.dart';
import 'package:study_project/views/edit_exam.dart';
import 'package:study_project/views/passExam.dart';
import 'dart:io';
import 'package:wifi/wifi.dart';
import 'package:provider/provider.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'dart:convert';
import 'package:study_project/networking.dart';
import 'package:study_project/theme.dart';

class Student extends StatefulWidget {
  Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  TcpSocketConnection socketConnection = TcpSocketConnection("0.0.0.0", 55555);
  Future<ServerSocket> serverFuture = ServerSocket.bind('0.0.0.0', 55555);
  String serverIP = '';
  String data = '';
  bool first = true;

  Map<MyQuest, List<MyChoice>> examData = {};
  // for receiving
  void startServer() {
    serverFuture.then((ServerSocket server) {
      print("listening");

      server.listen((Socket socket) {
        socket.listen((List<int> data) {
          setState(() {
            this.data = String.fromCharCodes(data);
            print(data.toString());
            ExamInfo examInfo = ExamInfo.fromMap(json.decode(this.data));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PassExamPage(
                      ip: examInfo.ip,
                      exam: examInfo.exam,
                      newQuests: examInfo.questions,
                      newchoices: examInfo.choices)),
            );
          });
        });
      }, onError: (e) {
        print(e);
      });
    });
  }

  // for sending

  void finish() async {
    (await serverFuture).close();
  }

  @override
  void initState() {
    // TODO: implement initState
    startServer();

    super.initState();
  }

  @override
  void dispose() {
    finish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("wait until exam starts")),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Padding(
                    child: CircularProgressIndicator(),
                    padding: EdgeInsets.all(20),
                  ),
                  Text(
                    "  Please wait,\nYour exam will start soon!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ]))));
  }
}
  //  MaterialButton(
  //               child: const Text("cancel"),
  //               onPressed: Navigator.of(context).pop),