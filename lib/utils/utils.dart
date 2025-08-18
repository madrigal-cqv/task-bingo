import 'package:quickstart/models/bingo_card.dart';
import 'package:quickstart/models/task.dart';
import 'package:quickstart/utils/storage.dart';
import 'package:web/web.dart' as web;

mixin Utils {
  static int _getSize(int numTasks) {
    int size;
    switch (numTasks) {
      case 9:
        size = 3;
        break;
      case 16:
        size = 4;
        break;
      case 25:
        size = 5;
        break;
      default:
        size = 0;
        break;
    }
    return size;
  }

  // Generate the bingo board based on the number of tasks
  static void generateBoard(int numTasks, web.HTMLDivElement bingo) {
    bingo.innerHTML = "";
    web.HTMLDivElement curRow;
    int size = _getSize(numTasks);
    int numButton = 0;
    for (int c = 0; c < size; c++) {
      bingo.insertAdjacentHTML('beforeend', "<div class='col' id='c$c'></div>");
      curRow = web.document.querySelector('#c$c') as web.HTMLDivElement;
      for (int r = 0; r < size; r++) {
        curRow.insertAdjacentHTML('beforeend', """<div class='row'>
              <button class='bingo-button' id='r$numButton'></button>
              </div>""");
        numButton++;
      }
    }
  }

  static void generateInputs(int numTasks, web.HTMLDivElement tasksInput) {
    int trueNum = numTasks;
    tasksInput.innerHTML = "";
    tasksInput.insertAdjacentHTML(
      'beforeend',
      "<p>Input your tasks: </p> <br>",
    );
    if (numTasks == 9 || numTasks == 25) {
      trueNum = numTasks - 1;
    }
    for (int i = 0; i < trueNum; i++) {
      tasksInput.insertAdjacentHTML(
        'beforeend',
        "<p>${i + 1} <input class='input' id='input$i' type='text'></input></p>",
      );
    }
  }

  // populate the board based on bingo data
  static void populateBoard(BingoCard bingo, Storage storage) {
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
        markAsDone(button, storage, bingo, bingo.tasksOrder[i]);
      });
    }
  }

  // mark tile as done. Update bingo board and memory. Check for bingos if any
  static void markAsDone(
    web.HTMLButtonElement button,
    Storage storage,
    BingoCard bingo,
    int pos,
  ) {
    button.style
      ..backgroundColor = "green"
      ..color = "white";
    bingo.tasksList[pos].markAsDone();
    bingoNotify(bingo);
    storage.save(bingo);
  }

  static void bingoNotify(BingoCard bingo) {
    final bingoNoti =
        web.document.querySelector("#bingo-notif") as web.HTMLDivElement;
    int bingos = _bingoCheck(bingo);
    if (bingos > 0) {
      if (bingos == _getSize(bingo.tasksList.length) * 2 + 2) {
        bingoNoti.innerText = "FULL BINGO!";
      } else {
        bingoNoti.innerText = "$bingos BINGO!";
      }
    } else {
      bingoNoti.innerText = "";
    }
  }

  static int _bingoCheck(BingoCard bingo) {
    int size = _getSize(bingo.tasksList.length);
    int res = 0;
    bool checkDiagLeft = true;
    bool checkDiagRight = true;

    for (int c = 0; c < size; c++) {
      bool checkCol = true;
      bool checkRow = true;
      for (int r = 0; r < size; r++) {
        // column check
        checkCol =
            checkCol &&
            bingo.tasksList[bingo.tasksOrder[size * c + r]].isDone();
        // row check
        checkRow =
            checkRow &&
            bingo.tasksList[bingo.tasksOrder[size * r + c]].isDone();
        // top left to bottom right check
        if (r == c) {
          checkDiagLeft =
              checkDiagLeft &&
              bingo.tasksList[bingo.tasksOrder[size * c + r]].isDone();
        }
        // top right to bottom left check
        if (r + c == size - 1) {
          checkDiagRight =
              checkDiagRight &&
              bingo.tasksList[bingo.tasksOrder[size * c + r]].isDone();
        }
      }
      if (checkCol) {
        res++;
      }
      if (checkRow) {
        res++;
      }
    }
    if (checkDiagLeft) {
      res++;
    }
    if (checkDiagRight) {
      res++;
    }

    return res;
  }

  // generate bingo board once user presses start
  static BingoCard onStart(int numTasks, String duration, Storage storage) {
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
      BingoCard.calculateEndTime(duration, DateTime.now()),
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
    populateBoard(bingo, storage);
    return bingo;
  }

  static void onClear(Storage storage) {
    storage.clear();
    final bingoNoti =
        web.document.querySelector("#bingo-notif") as web.HTMLDivElement;
    bingoNoti.innerText = "";
  }
}
