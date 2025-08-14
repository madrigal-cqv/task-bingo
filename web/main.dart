import 'package:quickstart/utils/generate.dart';
import "package:quickstart/utils/storage.dart";
import 'package:web/web.dart' as web;

void main() {
  final inputPage =
      web.document.querySelector("#input-page") as web.HTMLDivElement;
  final bingoPage =
      web.document.querySelector("#bingo-page") as web.HTMLDivElement;

  final storage = Storage();
  storage.clear();
  var bingoCard = storage.load();
  if (bingoCard == null) {
    bingoPage.style.display = 'none';
  } else {
    inputPage.style.display = 'none';
  }

  final bingo = web.document.querySelector("#bingo-card") as web.HTMLDivElement;
  final tasksInput =
      web.document.querySelector("#tasks-input") as web.HTMLDivElement;
  final numTasks =
      web.document.querySelector("#numTasks") as web.HTMLSelectElement;
  final startButton =
      web.document.querySelector("#start") as web.HTMLButtonElement;
  final duration =
      web.document.querySelector("#duration") as web.HTMLSelectElement;

  Generate.generateBoard(int.parse(numTasks.value), bingo);
  Generate.generateInputs(int.parse(numTasks.value), tasksInput);

  numTasks.onChange.listen((data) {
    Generate.generateBoard(int.parse(numTasks.value), bingo);
    Generate.generateInputs(int.parse(numTasks.value), tasksInput);
  });

  startButton.onClick.listen((data) {
    bingoPage.removeAttribute("style");
    inputPage.style.display = 'none';
    Generate.onStart(int.parse(numTasks.value), duration.value, storage);
  });
}
