import 'dart:convert';
import '../database/controler.dart';

class MyExam {
  int? examId;
  String name;
  String subject;
  String created;
  String modified;

  MyExam(
      {this.examId,
      this.name = 'uknown',
      this.subject = 'exam sub',
      this.created = 'created',
      this.modified = 'modified'});

  MyExam.fromMap(Map<String, dynamic> res)
      : examId = res["examId"],
        name = res["name"],
        subject = res["subject"],
        created = res["created"],
        modified = res["modified"];

  Map<String, Object?> toMap() {
    return {
      'examId': examId,
      'name': name,
      'subject': subject,
      'created': created,
      'modified': modified
    };
  }
}

class MyQuest {
  int? questId;
  int? examId;
  int? number;
  int points;
  String statement;

  MyQuest({
    this.questId,
    required this.statement,
    this.points = 1,
  });

  MyQuest.fromMap(Map<String, dynamic> res)
      : questId = res["questId"],
        examId = res["examId"],
        number = res["number"],
        points = res["points"],
        statement = res["statement"];

  Map<String, Object?> toMap() {
    return {
      'questId': questId,
      'examId': examId,
      'number': number,
      'points': points,
      'statement': statement,
    };
  }
}

class MyChoice {
  int? choiceId;
  int? questId;
  String statement;
  int? correct = 0;

  MyChoice({
    this.choiceId,
    this.questId,
    this.statement = '',
    this.correct = 0,
  });

  MyChoice.fromMap(Map<String, dynamic> res)
      : choiceId = res["choiceId"],
        questId = res["questId"],
        statement = res["statement"],
        correct = res["correct"];

  Map<String, Object?> toMap() {
    return {
      'choiceId': choiceId,
      'questId': questId,
      'statement': statement,
      'correct': correct,
    };
  }
}

class MyUserChoice {
  int? userChoiceId;
  int? answerId;
  int? choiceId;

  MyUserChoice({this.userChoiceId, this.answerId, this.choiceId});

  MyUserChoice.fromMap(Map<String, dynamic> res)
      : userChoiceId = res["userChoiceId"],
        answerId = res["answerId"],
        choiceId = res["choiceId"];

  Map<String, Object?> toMap() {
    return {
      'userChoiceId': userChoiceId,
      'answerId': answerId,
      'choiceId': choiceId,
    };
  }
}

class MySession {
  int? sessionId;
  int? examId;
  String time;
  String name;
  String? duration;
  String? grade;

  MySession({
    this.sessionId,
    this.examId,
    this.time = "uknown",
    this.name = "session name",
    this.duration,
    this.grade,
  });

  MySession.fromMap(Map<String, dynamic> res)
      : sessionId = res["sessionId"],
        examId = res["examId"],
        time = res["time"],
        name = res["name"],
        grade = res["grade"],
        duration = res["duration"];

  Map<String, Object?> toMap() {
    return {
      'sessionId': sessionId,
      'examId': examId,
      'time': time,
      'name': name,
      'grade': grade,
      'duration': duration,
    };
  }
}

class MyAnswer {
  int? sessionId;
  int? answerId;
  int correct;
  int wrong;
  String name;
  String grp;

  MyAnswer({
    this.sessionId,
    this.answerId,
    this.correct = 0,
    this.wrong = 0,
    this.name = "uknown",
    this.grp = "uknown",
  });

  MyAnswer.fromMap(Map<String, dynamic> res)
      : sessionId = res["sessionId"],
        answerId = res["answerId"],
        correct = res["correct"],
        wrong = res["wrong"],
        name = res["name"],
        grp = res["grp"];

  Map<String, Object?> toMap() {
    return {
      'sessionId': sessionId,
      'answerId': answerId,
      'correct': correct,
      'wrong': wrong,
      'name': name,
      'grp': grp,
    };
  }
}

class ExamInfo {
  MyExam? exam;
  List<MyQuest> questions = [];
  List<List<MyChoice>> choices = [];
  String ip;
  ExamInfo({this.exam, this.ip = ''});

  static List<MyQuest> _genQuests(Map<String, dynamic> res) {
    List<MyQuest> results = [];
    for (Map<String, Object?> quest in res["questions"]) {
      results.add(MyQuest.fromMap(quest));
    }
    return results;
  }

  static List<List<MyChoice>> _genChoices(Map<String, dynamic> res) {
    List<List<MyChoice>> results = [];
    for (List<dynamic> choices in res["choices"]) {
      List<MyChoice> myChoices = [];
      for (Map<String, Object?> choice in choices) {
        myChoices.add(MyChoice.fromMap(choice));
      }
      results.add(myChoices);
    }
    return results;
  }

  fromExam(MyExam exam) {
    DatabaseHandler dataBaseHandler;
    dataBaseHandler = DatabaseHandler();
    return dataBaseHandler.initializeDB().whenComplete(() async {
      questions = await dataBaseHandler.retrieveQuest(exam.examId);
      for (MyQuest quest in questions) {
        List<MyChoice> choices =
            await dataBaseHandler.retrieveChoices(quest.questId);
        this.choices.add(choices);
      }
    });
  }

  ExamInfo.fromMap(Map<String, dynamic> res)
      : ip = res['ip'],
        exam = MyExam.fromMap(res["exam"]),
        questions = _genQuests(res),
        choices = _genChoices(res);
// List<Post> posts = List<Post>.from(l.map((model)=> Post.fromJson(model)));

  Map<String, dynamic> toMap() {
    return {
      'ip': ip,
      'exam': exam?.toMap(),
      'questions': questions.map((quest) => quest.toMap()).toList(),
      'choices': choices
          .map(
              (qchoices) => qchoices.map((choices) => choices.toMap()).toList())
          .toList(),
    };
  }
}

class JsonAnswer {
  MyAnswer answer;
  Map<int?, List<bool>>? choicesboxs = {};
  List<dynamic> choicesIds = [];

  JsonAnswer({required this.answer, this.choicesboxs});
  List<int?> genChoicesMap(Map<int?, List<bool>>? choicesboxs) {
    List<int?> l = [];
    choicesboxs?.forEach((key, value) {
      if (value[0] == true) l.add(key);
    });
    return l;
  }

  Map<String, Object?> toMap() {
    return {'answer': answer.toMap(), 'choices': genChoicesMap(choicesboxs)};
  }

  JsonAnswer.fromMap(Map<String, dynamic> res)
      : answer = MyAnswer.fromMap(res["answer"]),
        choicesboxs = null,
        choicesIds = res["choices"];
}
