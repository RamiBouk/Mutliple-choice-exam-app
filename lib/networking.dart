import 'dart:io';
import 'dart:convert';
import 'database/models.dart';

class Networkking {
  static int switcher = 0;
  static late MyQuest question;
  static receivedExam(MyExam exam, List<int> data) {
    exam = MyExam.fromMap(jsonDecode(String.fromCharCodes(data)));
  }

  static receivedQuest(Map<MyQuest, List<MyChoice>> examData, List<int> data) {
    var quest = MyQuest.fromMap(jsonDecode(String.fromCharCodes(data)));
    question = quest;
    examData.addAll({quest: []});
    print(quest);
  }

  static receivedChoice(Map<MyQuest, List<MyChoice>> examData, List<int> data) {
    var choice = MyChoice.fromMap(jsonDecode(String.fromCharCodes(data)));
    examData[question]?.add(choice);
    print(choice);
  }

  static networkData(
      MyExam exam, Map<MyQuest, List<MyChoice>> examData, List<int> data) {
    switch (switcher) {
      case 0:
        receivedExam(exam, data);
        return;
      case 1:
        receivedQuest(examData, data);
        return;
      case 2:
        receivedChoice(examData, data);
        return;
    }
  }
}
