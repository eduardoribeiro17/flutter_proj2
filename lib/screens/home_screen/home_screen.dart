import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int windowPage = 10;
  DateTime currentDay = DateTime.now();
  Map<String, Journal> database = {};
  int? userId;
  String? userToken;

  final ScrollController _listScrollController = ScrollController();
  JournalService service = JournalService();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();

    Navigator.pushReplacementNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
              onPressed: () => refresh(),
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ))
        ],
      ),
      body: (userId != null && userToken != null)
          ? ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                userId: userId!,
                token: userToken!,
                refreshList: refresh,
                windowPage: windowPage,
                currentDay: currentDay,
                database: database,
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () => logout(),
              title: const Text('Sair'),
              leading: const Icon(Icons.logout),
            )
          ],
        ),
      ),
    );
  }

  void refresh() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('accessToken');
    String? email = preferences.getString('email');
    int? id = preferences.getInt('id');

    if (token == null && email == null && id == null) {
      Navigator.pushReplacementNamed(context, 'login');
    }

    List<Journal> journalList =
        await service.getAll(userId: id, userToken: token);

    setState(() {
      userId = id;
      userToken = token;

      database = {};

      for (Journal journal in journalList) {
        database[journal.id] = journal;
      }
    });
  }
}
