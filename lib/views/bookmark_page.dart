import 'package:flutter/material.dart';
import 'package:study_project/widgets/examCard.dart';
import 'package:study_project/widgets/sessionCard.dart';
import '../database/controler.dart';
import 'package:provider/provider.dart';
import '../database/models.dart';
import 'package:study_project/theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

bool a = true;

class _SearchPageState extends State<SearchPage> {
  late DatabaseHandler examHandler;
  var items = <MyExam>[];
  var dulicateItems = <MyExam>[];

  @override
  void initState() {
    super.initState();
    examHandler = DatabaseHandler();
    examHandler.initializeDB().whenComplete(() async {
      setState(() {});
      items = await examHandler.retrieveExams();
      dulicateItems = await examHandler.retrieveExams();
    });
  }

  void filterSearchResults(String query) {
    print(query.toString());
    List<MyExam> dummySearchList = [];
    dummySearchList.addAll(dulicateItems);
    if (query.isNotEmpty) {
      List<MyExam> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(dulicateItems);
      });
    }
  }

  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Bookmarked Exams:",
              ),
            ),
            body: Column(children: [
              Padding(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    onChanged: (value) => filterSearchResults(value),
                    controller: editingController,
                    decoration: const InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  )),
              Expanded(
                  child: GridView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4 / 5,
                ),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Align(
                    alignment: Alignment.center,
                    child: ExamCard(exam: items.reversed.toList()[index]),
                  );
                },
              )),
            ])));
  }
}
