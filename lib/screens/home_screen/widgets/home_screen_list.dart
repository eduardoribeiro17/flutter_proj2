import '../../../models/journal.dart';
import 'journal_card.dart';

List<JournalCard> generateListJournalCards({
  required int windowPage,
  required DateTime currentDay,
  required Map<String, Journal> database,
  required int userId,
  required String token,
  required Function refreshList,
}) {
  List<JournalCard> list = List.generate(
    windowPage + 1,
    (index) => JournalCard(
      userId: userId,
      token: token,
      showedDate: currentDay.subtract(Duration(days: (windowPage) - index)),
      refreshList: refreshList,
    ),
  );

  database.forEach((key, value) {
    if (value.createdAt
        .isAfter(currentDay.subtract(Duration(days: windowPage)))) {
      int difference = value.createdAt
          .difference(currentDay.subtract(Duration(days: windowPage)))
          .inDays
          .abs();

      list[difference] = JournalCard(
        userId: userId,
        token: token,
        refreshList: refreshList,
        showedDate: list[difference].showedDate,
        journal: value,
      );
    }
  });

  return list;
}
