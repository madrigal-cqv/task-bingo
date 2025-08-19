import 'package:quickstart/models/bingo_card.dart';
import 'package:quickstart/models/bingo_card_extension.dart';
import 'package:quickstart/models/task.dart';
import 'package:quickstart/utils/bingo_monitor.dart';
import 'package:quickstart/utils/generate.dart';
import 'package:quickstart/utils/storage.dart';
import 'package:web/web.dart' as web;

class Utils with Generate, BingoMonitor {
  // populate the board based on bingo data
  void populateBoard(
    BingoCard bingo,
    Storage storage,
    web.HTMLDivElement bingoNoti,
  ) {
    for (int i = 0; i < bingo.tasksList.length; i++) {
      final button =
          web.document.querySelector("#r$i") as web.HTMLButtonElement;
      button.innerText = bingo.tasksList[bingo.tasksOrder[i]].getName();
      if (bingo.tasksList[bingo.tasksOrder[i]].isDone()) {
        button.style
          ..backgroundColor = "green"
          ..color = "white";
      } else {
        button.style
          ..backgroundColor = "white"
          ..color = "black";
      }
      button.onClick.listen((data) {
        markAsDone(button, storage, bingo, bingo.tasksOrder[i], bingoNoti);
      });
    }
  }

  // mark tile as done. Update bingo board and memory. Check for bingos if any
  void markAsDone(
    web.HTMLButtonElement button,
    Storage storage,
    BingoCard bingo,
    int pos,
    web.HTMLDivElement bingoNoti,
  ) {
    button.style
      ..backgroundColor = "green"
      ..color = "white";
    bingo.tasksList[pos].markAsDone();
    bingoNotify(bingo, bingoNoti);
    storage.save(bingo);
  }

  // generate bingo board once user presses start
  BingoCard onStart(
    int numTasks,
    String duration,
    Storage storage,
    web.HTMLDivElement bingoNoti,
  ) {
    List<Task> tasksList = [];
    int size;
    switch (numTasks) {
      case 9:
        size = 8;
        break;
      case 25:
        size = 24;
        break;
      default:
        size = numTasks;
        break;
    }
    for (int i = 0; i < size; i++) {
      final task =
          (web.document.querySelector("#input$i") as web.HTMLInputElement)
              .value;
      tasksList.add(Task(name: task));
    }

    final bingo = BingoCard(
      DateTime.now(),
      BingoCardExtension.calculateEndTime(duration, DateTime.now()),
      tasksList,
    );

    // all of these should have been handled in constructor if possible
    bingo.generateTaskOrder();
    // add middle free space for board of size 9 and 25
    if (bingo.tasksList.length == 8 || bingo.tasksList.length == 24) {
      bingo.tasksOrder.add(bingo.tasksOrder[bingo.tasksList.length ~/ 2]);
      bingo.tasksOrder[bingo.tasksList.length ~/ 2] = bingo.tasksList.length;
      bingo.tasksList.add(Task(name: "Free space"));
      bingo.tasksList[bingo.tasksList.length - 1].markAsDone();
    }

    // save the newly created bingo board and populate the frontend
    storage.save(bingo);
    populateBoard(bingo, storage, bingoNoti);
    return bingo;
  }

  // function to invoke when clear button is clicked
  void onClear(Storage storage, web.HTMLDivElement bingoNoti) {
    storage.clear();
    bingoNoti.innerText = "";
  }
}
