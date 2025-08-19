import 'package:quickstart/models/bingo_card.dart';
import 'package:quickstart/utils/utils.dart';
import "package:quickstart/utils/storage.dart";
import 'package:web/web.dart' as web;

class Facade extends Utils {
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
  final bingoNoti =
      web.document.querySelector("#bingo-notif") as web.HTMLDivElement;

  bool stopTimer = false;

  // disable interactions with the bingo board
  void disableButtons(BingoCard bingo) {
    for (int i = 0; i < bingo.tasksList.length; i++) {
      final button =
          web.document.querySelector("#r$i") as web.HTMLButtonElement;
      button.disabled = true;
    }
  }

  // enable interactions with the bingo board
  void enableButtons(BingoCard bingo) {
    for (int i = 0; i < bingo.tasksList.length; i++) {
      final button =
          web.document.querySelector("#r$i") as web.HTMLButtonElement;
      button.disabled = false;
    }
  }

  Future<void> updateTimer(BingoCard bingo) async {
    Duration timeLeft = bingo.endTime.difference(DateTime.now());
    final timer = web.document.querySelector("#timer") as web.HTMLDivElement;
    timer.innerText = timeLeft.toString().split('.').first.padLeft(8, "0");

    // Actual timer part
    // Could have used Timer class, but this gives me a bit more flexibility
    while (timeLeft > Duration.zero && !stopTimer) {
      timer.innerText = timeLeft.toString().split('.').first.padLeft(8, "0");
      await Future.delayed(const Duration(seconds: 1));
      timeLeft = bingo.endTime.difference(DateTime.now());
    }

    // disable buttons when done
    disableButtons(bingo);
    timer.innerText = "00:00:00";
  }

  void run() {
    generateBoard(int.parse(numTasks.value), bingo);
    generateInputs(int.parse(numTasks.value), tasksInput);

    final storage = Storage();
    var bingoCard = storage.load();
    if (bingoCard == null) {
      bingoPage.style.display = 'none';
    } else {
      inputPage.style.display = 'none';
      populateBoard(bingoCard, storage, bingoNoti);
      bingoNotify(bingoCard, bingoNoti);
      updateTimer(bingoCard);
    }

    numTasks.onChange.listen((data) {
      generateBoard(int.parse(numTasks.value), bingo);
      generateInputs(int.parse(numTasks.value), tasksInput);
    });

    startButton.onClick.listen((data) {
      bingoPage.removeAttribute("style");
      inputPage.style.display = 'none';
      final newBingo = onStart(
        int.parse(numTasks.value),
        duration.value,
        storage,
        bingoNoti,
      );
      stopTimer = false;
      enableButtons(newBingo);
      updateTimer(newBingo);
    });

    clearButton.onClick.listen((data) {
      onClear(storage, bingoNoti);
      bingoPage.style.display = 'none';
      inputPage.removeAttribute("style");
      stopTimer = true;
    });
  }
}
