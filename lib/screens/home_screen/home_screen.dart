import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';

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

  final ScrollController _listScrollController = ScrollController();
  JournalService service = JournalService();

  @override
  void initState() {
    refresh();
    super.initState();
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
      body: ListView(
        controller: _listScrollController,
        children: generateListJournalCards(
          refreshList: refresh,
          windowPage: windowPage,
          currentDay: currentDay,
          database: database,
        ),
      ),
    );
  }

  void refresh() async {
    // List<Journal> journalList = await service.getAll();

    // setState(() {
    //   database = {};

    //   for (Journal journal in journalList) {
    //     database[journal.id] = journal;
    //   }
    // });
  }
}
