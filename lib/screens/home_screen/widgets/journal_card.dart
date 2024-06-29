import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/common/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';

class JournalCard extends StatelessWidget {
  final Journal? journal;
  final DateTime showedDate;
  final Function refreshList;

  const JournalCard({
    Key? key,
    this.journal,
    required this.showedDate,
    required this.refreshList,
  }) : super(key: key);

  callAddJournalScreen(BuildContext context, {Journal? target}) {
    Journal newJ = Journal(
      id: '',
      content: '',
      createdAt: showedDate,
      updatedAt: showedDate,
    );
    Journal journal = target ?? newJ;

    Navigator.pushNamed(context, 'add-journal', arguments: journal).then(
      (value) {
        if (value != null && value == true) {
          refreshList();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro efetuado com sucesso!'),
            ),
          );
        }
      },
      onError: (e) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro ao salvar'),
        ),
      ),
    );
  }

  removeJournal(BuildContext context, String id) async {
    JournalService service = JournalService();

    final dynamic confirm = await showConfirmationDialog(
      context,
      content: 'Deseja realmente remover este item?',
      okOption: 'Remover',
    );

    if (confirm) {
      service.delete(id).then(
        (value) {
          if (value) {
            refreshList();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro deletado com sucesso!'),
              ),
            );
          }
        },
        onError: (e) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocorreu um erro ao salvar'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (journal != null) {
      return InkWell(
        onTap: () => callAddJournalScreen(context, target: journal),
        child: Container(
          height: 115,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black87,
            ),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      border: Border(
                          right: BorderSide(color: Colors.black87),
                          bottom: BorderSide(color: Colors.black87)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      journal!.createdAt.day.toString(),
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black87),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(WeekDay(journal!.createdAt.weekday).short),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    journal!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => removeJournal(context, journal!.id),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () => callAddJournalScreen(context, target: journal),
        child: Container(
          height: 115,
          alignment: Alignment.center,
          child: Text(
            "${WeekDay(showedDate.weekday).short} - ${showedDate.day}",
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
