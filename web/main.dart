import 'package:web/web.dart' as web;
import 'package:quickstart/utils/generate.dart';

void main() {
  final now = DateTime.now();
  final element = web.document.querySelector('#output') as web.HTMLDivElement;
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
    element.text =
        "This exists at ${now.hour}:${now.minute}! ${numTasks.value}";
    Generate.generateBoard(int.parse(numTasks.value), bingo);
    Generate.generateInputs(int.parse(numTasks.value), tasksInput);
  });

  startButton.onClick.listen((data) => print('Start!'));
}
