import 'task.dart';

class BingoCard<T extends Task> {
  final DateTime startTime;
  DateTime endTime;
  final List<T> tasksList;
  late final List<int> tasksOrder;

  // I tried to look into how to make a more robust constructor,
  // but the language does not really allow for it
  BingoCard(this.startTime, this.endTime, this.tasksList);

  void generateTaskOrder() {
    tasksOrder = [];
    for (int i = 0; i < tasksList.length; i++) {
      tasksOrder.add(i);
    }
    tasksOrder.shuffle();
  }
}
