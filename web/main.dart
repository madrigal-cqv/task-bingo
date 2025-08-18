import 'package:quickstart/models/bingo_card.dart';
import 'package:quickstart/utils/utils.dart';
import "package:quickstart/utils/storage.dart";
import 'package:web/web.dart' as web;

bool stopTimer = false;

Future<void> updateTimer(BingoCard bingo) async {
  Duration timeLeft = bingo.endTime.difference(DateTime.now());
  final timer = web.document.querySelector("#timer") as web.HTMLDivElement;
  timer.innerText = "";

  // Actual timer part
  // Could have used Timer class, but this gives me a bit more flexibility
  while (timeLeft != Duration.zero && !stopTimer) {
    timer.innerText = timeLeft.toString().split('.').first.padLeft(8, "0");
    await Future.delayed(const Duration(seconds: 1));
    timeLeft = DateTime.now().difference(bingo.endTime);
  }

  // disable buttons when done
  for (int i = 0; i < bingo.tasksList.length; i++) {
    final button = web.document.querySelector("#r$i") as web.HTMLButtonElement;
    button.disabled = true;
  }
}

void main() {
  final inputPage =
      web.document.querySelector("#input-page") as web.HTMLDivElement;
  final bingoPage =
      web.document.querySelector("#bingo-page") as web.HTMLDivElement;

  final bingo = web.document.querySelector("#bingo-card") as web.HTMLDivElement;
  final tasksInput =
      web.document.querySelector("#tasks-input") as web.HTMLDivElement;
  final numTasks =
      web.document.querySelector("#numTasks") as web.HTMLSelectElement;
  final startButton =
      web.document.querySelector("#start") as web.HTMLButtonElement;
  final duration =
      web.document.querySelector("#duration") as web.HTMLSelectElement;
  final clearButton =
      web.document.querySelector("#end-button")?.firstElementChild
          as web.HTMLButtonElement;

  Utils.generateBoard(int.parse(numTasks.value), bingo);
  Utils.generateInputs(int.parse(numTasks.value), tasksInput);

  final storage = Storage();
  var bingoCard = storage.load();
  if (bingoCard == null) {
    bingoPage.style.display = 'none';
  } else {
    inputPage.style.display = 'none';
    Utils.populateBoard(bingoCard, storage);
    Utils.bingoNotify(bingoCard);
    updateTimer(bingoCard);
  }

  numTasks.onChange.listen((data) {
    Utils.generateBoard(int.parse(numTasks.value), bingo);
    Utils.generateInputs(int.parse(numTasks.value), tasksInput);
  });

  startButton.onClick.listen((data) {
    bingoPage.removeAttribute("style");
    inputPage.style.display = 'none';
    final newBingo = Utils.onStart(
      int.parse(numTasks.value),
      duration.value,
      storage,
    );
    stopTimer = false;
    updateTimer(newBingo);
  });

  clearButton.onClick.listen((data) {
    Utils.onClear(storage);
    bingoPage.style.display = 'none';
    inputPage.removeAttribute("style");
    stopTimer = true;
  });
}
