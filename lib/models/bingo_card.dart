import 'task.dart';

class BingoCard {
  final DateTime startTime;
  DateTime endTime;
  final List<Task> tasksList;

  // I tried to look into how to make a more robust constructor,
  // but the language does not really allow for it
  BingoCard(this.startTime, this.endTime, this.tasksList);

  static DateTime calculateEndTime(String duration, DateTime curr) {
    switch (duration) {
      case "d":
        return curr.add(const Duration(hours: 24));
      case "w":
        return curr.add(const Duration(days: 7));
      case "m":
        return curr.add(const Duration(days: 30));
    }
    return curr;
  }
}
