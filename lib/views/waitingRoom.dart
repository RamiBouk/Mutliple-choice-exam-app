import 'package:flutter/material.dart';
import 'package:study_project/constants.dart';
import 'package:study_project/database/models.dart';
import 'package:wifi/wifi.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'package:study_project/database/controler.dart';
import 'teacher_waiting.dart';
import 'package:avatar_glow/avatar_glow.dart';

class waitingRoom extends StatefulWidget {
  MyExam exam;
  MySession session;
  waitingRoom({Key? key, required this.exam, required this.session})
      : super(key: key);

  @override
  State<waitingRoom> createState() => _waitingRoomState();
}

class _waitingRoomState extends State<waitingRoom> {
  String serverStatus = '';
  int port = 55555;
  bool done = false;
  Set<String> clientIPs = {};
  String message = '';
  int connected = 0;
  bool ready = false;
  String address = "0.0.0.0";
  TcpSocketConnection socketConnection = TcpSocketConnection("0.0.0.0", 55555);
  String dots = "   ";

  search() async {
    // startServer();
    // print(await Wifi.ip);
    address = await Wifi.ip;
    final String subnet = address.substring(0, address.lastIndexOf('.'));
    connected = clientIPs.length;
    while (!done) {
      clientIPs = {};
      await Future.delayed(const Duration(seconds: 3), () {});
      NetworkAnalyzer.discover2(subnet, port).listen((NetworkAddress addr) {
        if (addr.exists && addr.ip != address) {
          clientIPs.add(addr.ip);
        }
      });
      if (clientIPs.length != connected) {
        setState(() {
          connected = clientIPs.length;
        });
      }
      if (done) break;
    }
  }

  //receiving and sending back a custom message

  //starting the connection and listening to the socket asynchronously
  // void startConnection() async {
  //   for (var clientip in clientIPs) {
  //     socketConnection = TcpSocketConnection(clientip, port);
  //     socketConnection.enableConsolePrint(
  //         true); //use this to see in the console what's happening
  //     if (await socketConnection.canConnect(1000, attempts: 3)) {
  //       //check if it's possible to connect to the endpoint
  //       await socketConnection.connect(1000, "", messageReceived, attempts: 3);
  //       socketConnection.sendMessage((await Wifi.ip));
  //     }
  //   }
  // }

  void sendExam() async {
    done = true;
    await Future.delayed(Duration(seconds: 1));

    ExamInfo examInfo = ExamInfo(exam: widget.exam, ip: address);
    examInfo.fromExam(widget.exam).then((e) async {
      for (var clientip in clientIPs) {
        socketConnection = TcpSocketConnection(clientip, port);
        socketConnection.enableConsolePrint(
            true); //use this to see in the console what's happening
        if (await socketConnection.canConnect(1000, attempts: 3)) {
          //check if it's possible to connect to the endpoint
          await socketConnection.connect(1000, "", () {}, attempts: 3);
          socketConnection.sendMessage(jsonEncode(examInfo.toMap()));
        }
      }
    });
    socketConnection.disconnect();
  }

  void serching() async {
    int counter = 0;
    while (!done) {
      await Future.delayed(Duration(seconds: 1));
      switch (counter) {
        case 0:
          dots = ".  ";
          break;
        case 1:
          dots = ".. ";
          break;
        case 2:
          dots = "...";
          break;
      }
      try {
        setState(() {});
      } catch (e) {}
      counter++;
      if (counter == 4) {
        this.dots = '   ';

        counter = 0;
      }
      ;
    }
  }

  @override
  void initState() {
    super.initState();

    search();
    serching();
  }

  @override
  void dispose() {
    done = true;
    socketConnection.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("waiting room")),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(
                  "  searching" + dots,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Builder(builder: (context) {
                  return Text(
                    connected.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  );
                }),
                const AvatarGlow(
                  glowColor: MyConsts.LIGHT_BLUE,
                  endRadius: 120,
                  duration: Duration(seconds: 2),
                  repeat: true,
                  showTwoGlows: true,
                  curve: Curves.easeOut,
                  child: Icon(
                    Icons.wifi,
                    size: 50,
                    color: Colors.green,
                  ),
                ),
                OutlinedButton(
                    child: const Text("cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                ElevatedButton(
                    child: const Text("Launch Session"),
                    onPressed: () {
                      sendExam();
                      done = true;
                      socketConnection.disconnect();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherWaiting(
                                  session: widget.session,
                                  exam: widget.exam,
                                )),
                      );
                    }),
              ]))),
    );
  }
}
