import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'views/home_page.dart';
import 'views/launch_session_view.dart';
import 'package:study_project/networking.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'Flutter Demo',
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            themeMode: themeProvider.themeMode,
            home: MyHomePage(),
          );
        });
  }
}
