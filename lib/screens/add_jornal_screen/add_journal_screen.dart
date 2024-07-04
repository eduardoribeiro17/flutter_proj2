import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/exceptions/token_not_valid_exception.dart';
import 'package:flutter_webapi_first_course/helpers/logout.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/common/exception_dialog.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  AddJournalScreen({super.key, required this.journal});

  final TextEditingController _contentController = TextEditingController();

  registerJournal(BuildContext context) async {
    JournalService service = JournalService();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('accessToken');

    journal.content = _contentController.text;

    if (token != null) {
      bool result = journal.id.isEmpty
          ? await service.register(journal, token).catchError(
              (error) {
                showExceptionDialog(context, content: error.message);
                logout(context);
                return false;
              },
              test: (error) => error is TokenNotValidException,
            ).catchError(
              (error) {
                showExceptionDialog(context, content: error.message);
                return false;
              },
              test: (error) => error is HttpException,
            )
          : await service.edit(journal.id, journal, token).catchError(
              (error) {
                showExceptionDialog(context, content: error.message);
                logout(context);
                return false;
              },
              test: (error) => error is TokenNotValidException,
            ).catchError(
              (error) {
                showExceptionDialog(context, content: error.message);
                return false;
              },
              test: (error) => error is HttpException,
            );

      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    _contentController.text = journal.content;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${WeekDay(journal.createdAt.weekday).long} | ${journal.createdAt.day} | ${journal.createdAt.month} | ${journal.createdAt.year}'),
        actions: [
          IconButton(
            onPressed: () => registerJournal(context),
            icon: const Icon(Icons.check, color: Colors.white),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          minLines: null,
          maxLines: null,
        ),
      ),
    );
  }
}
