import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/add_jornal_screen/add_journal_screen.dart';
import 'package:flutter_webapi_first_course/screens/login_screen/login_screen.dart';

import 'screens/home_screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool logged = await userTokenExists();
  runApp(MyApp(isLogged: logged));
}

Future<bool> userTokenExists() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String? token = preferences.getString('accessToken');

  return token != null;
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({Key? key, required this.isLogged}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Simple Journal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white),
          ),
          textTheme: GoogleFonts.bitterTextTheme(),
          actionIconTheme: ActionIconThemeData(
              backButtonIconBuilder: (context) =>
                  const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
        initialRoute: (isLogged) ? 'home' : 'login',
        routes: {
          'home': (context) => const HomeScreen(),
          'login': (context) => LoginScreen()
        },
        onGenerateRoute: (settings) {
          if (settings.name == "add-journal") {
            final Journal journal = settings.arguments as Journal;

            return MaterialPageRoute(
              builder: (context) => AddJournalScreen(journal: journal),
            );
          }

          return null;
        },
      );
}
