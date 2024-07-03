import 'package:flutter/material.dart';

Future<dynamic> showExceptionDialog(
  BuildContext context, {
  String title = 'Atenção!',
  String content = 'Ocorreu um erro',
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
