import 'package:quickstart/utils/generate.dart';
import "package:quickstart/utils/storage.dart";
import 'package:quickstart/models/bingo_card.dart';
import 'package:quickstart/models/task.dart';
import 'package:web/web.dart' as web;

void main() {
  print("A");
  final bingoTest = BingoCard(DateTime.now(), DateTime.now(), [
    Task(name: "Task 1"),
    Task(name: "Task 2"),
  ]);
  print("B");
  final storage = Storage("bingo.json");
  storage.save(bingoTest);
  print("C");
  storage.load();
  print("D");

  final bingo = web.document.querySelector("#bingo-card") as web.HTMLDivElement;
  final tasksInput =
      web.document.querySelector("#tasks-input") as web.HTMLDivElement;
  final numTasks =
      web.document.querySelector("#numTasks") as web.HTMLSelectElement;
  final startButton =
      web.document.querySelector("#start") as web.HTMLButtonElement;

  Generate.generateBoard(int.parse(numTasks.value), bingo);
  Generate.generateInputs(int.parse(numTasks.value), tasksInput);

  numTasks.onChange.listen((data) {
    Generate.generateBoard(int.parse(numTasks.value), bingo);
    Generate.generateInputs(int.parse(numTasks.value), tasksInput);
  });

  startButton.onClick.listen((data) => print('Start!'));
}
