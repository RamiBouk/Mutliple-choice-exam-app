import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'Mydb.db'),
      onCreate: (database, version) async {
        // exam table
        await database.execute(
          "CREATE TABLE Exams("
          " examId INTEGER PRIMARY KEY AUTOINCREMENT,"
          " name TEXT NOT NULL,"
          " subject TEXT NOT NULL,"
          " created TEXT NOT NULL,"
          " modified TEXT NOT NULL);",
        );
        // questions table
        await database.execute(
          "CREATE TABLE Quest("
          " questId INTEGER PRIMARY KEY AUTOINCREMENT,"
          " examId INTEGER, "
          " number INTEGER,"
          " points INTEGER,"
          " statement TEXT NOT NULL,"
          " FOREIGN KEY (examId) REFERENCES Exams(examId) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ");",
        );
        //choices table
        await database.execute(
          "CREATE TABLE Choice("
          " choiceId INTEGER PRIMARY KEY AUTOINCREMENT,"
          " statement TEXT NOT NULL,"
          " correct BOOLEAN,"
          " questId INTEGER, "
          " FOREIGN KEY (questId) REFERENCES Quest(questId) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ");",
        );
        //session table
        await database.execute(
          "CREATE TABLE Session("
          " sessionId INTEGER PRIMARY KEY AUTOINCREMENT,"
          " examId INTEGER, "
          " time TEXT,"
          " name TEXT,"
          " grade TEXT, "
          " duration TEXT, "
          " FOREIGN KEY (examId) REFERENCES Exams(examId) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ");",
        );
        database.execute(
          "CREATE TABLE Answer("
          " answerId INTEGER PRIMARY KEY AUTOINCREMENT,"
          " sessionId INTEGER, "
          " correct INTEGER,"
          " wrong INTEGfER,"
          " name TEXT NOT NULL,"
          " grp TEXT NOT NULL,"
          " FOREIGN KEY (sessionId) REFERENCES Session(sessionId) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ");",
        );
        database.execute(
          "CREATE TABLE UserChoice("
          " userChoiceId INTEGER PRIMARY KEY AUTOINCREMENT,"
          " answerId INTEGER, "
          " choiceId INTEGER,"
          " FOREIGN KEY (choiceId) REFERENCES Choice(choiceId) ON DELETE NO ACTION ON UPDATE NO ACTION,"
          " FOREIGN KEY (answerId) REFERENCES Answer(answerId) ON DELETE NO ACTION ON UPDATE NO ACTION"
          ");",
        );

        //session table
      },
      version: 1,
    );
  }

  Future<List<MyUserChoice>> retrieveUserChoices(int? answerId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('UserChoice', where: "answerId = $answerId");
    return queryResult.map((e) => MyUserChoice.fromMap(e)).toList();
  }

  Future<List<MyAnswer>> retrieveAnswers(int? sessionId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('Answer', where: "sessionId = $sessionId");
    return queryResult.map((e) => MyAnswer.fromMap(e)).toList();
  }

  Future<int> insertUserChoice(List<int?> choiceIds, int? answerId) async {
    int result = 0;
    final Database db = await initializeDB();

    for (var choiceId in choiceIds) {
      MyUserChoice uc = MyUserChoice(choiceId: choiceId, answerId: answerId);
      result = await db.insert('UserChoice', uc.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  Future<int> insertSession(List<MySession> sessions) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var session in sessions) {
      result = await db.insert('Session', session.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  Future<int> insertAnswer(List<MyAnswer> answers, int? sessionId) async {
    int result = 0;
    final Database db = await initializeDB();
    for (MyAnswer answer in answers) {
      answer.sessionId = sessionId;
      result = await db.insert('Answer', answer.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  Future<int> insertExams(List<MyExam> exams) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var exam in exams) {
      result = await db.insert('Exams', exam.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  Future<List<MyExam>> retrieveExams() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Exams');
    return queryResult.map((e) => MyExam.fromMap(e)).toList();
  }

  Future<List<MyExam>> retrieveExam(int? examId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('Exams', where: "examId = $examId");
    return queryResult.map((e) => MyExam.fromMap(e)).toList();
  }

  Future<List<MySession>> retrieveSessions() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Session');
    return queryResult.map((e) => MySession.fromMap(e)).toList();
  }

  Future<List<MyQuest>> retrieveQuest(int? examId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query("quest", where: "examId = $examId");
    return queryResult.map((q) => MyQuest.fromMap(q)).toList();
  }

  Future<List<MyChoice>> retrieveChoices(int? questId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query("choice", where: " questId = $questId");
    return queryResult.map((c) => MyChoice.fromMap(c)).toList();
  }

  Future<void> deleteExam(int? id) async {
    final db = await initializeDB();
    await db.delete(
      'Exams',
      where: "examId = ?",
      whereArgs: [id],
    );
  }

  Future<int> insertQuest(List<MyQuest> quests, int? examId) async {
    int result = 0;

    final Database db = await initializeDB();
    for (var quest in quests) {
      quest.examId = examId;

      result = await db.insert('Quest', quest.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  Future<int> insertChoice(List<MyChoice> choices, int? questId) async {
    int result = 0;

    final Database db = await initializeDB();
    for (var choice in choices) {
      if (choice.statement == '') choice.statement = '_';
      choice.questId = questId;

      result = await db.insert('Choice', choice.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  Future<List<MyQuest>> retrieveQuests() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Exams');
    return queryResult.map((e) => MyQuest.fromMap(e)).toList();
  }

  Future<void> deleteQuest(int id) async {
    final db = await initializeDB();
    await db.delete(
      'Exams',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

//_______________________________________________________________________________________________
//_______________________________________________________________________________________________
