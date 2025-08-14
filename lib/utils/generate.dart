import 'package:quickstart/models/bingo_card.dart';
import 'package:quickstart/models/task.dart';
import 'package:quickstart/utils/storage.dart';
import 'package:web/web.dart' as web;

mixin Generate {
  static int trueNumTasks(int numTasks) {
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
    int size = trueNumTasks(numTasks);
    int numButton = 0;
    for (int c = 0; c < size; c++) {
      bingo.insertAdjacentHTML('beforeend', "<div class='col' id='c$c'></div>");
      curRow = web.document.querySelector('#c$c') as web.HTMLDivElement;
      for (int r = 0; r < size; r++) {
        curRow.insertAdjacentHTML(
          'beforeend',
          "<div class='row'><button class='bingo-button' id='r$numButton'>Row $r</button></div>",
        );
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
  static void populateBoard(BingoCard bingo) {
    for (int i = 0; i < bingo.tasksList.length; i++) {
      final button = web.document.querySelector("r$i") as web.HTMLButtonElement;
      button.innerText = bingo.tasksList[i].getName();
      if (bingo.tasksList[i].isDone()) {
        button.style.backgroundColor = "green";
      }
    }
  }

  static void onStart(int numTasks, String duration, Storage storage) {
    List<Task> tasksList = [];
    for (int i = 0; i < numTasks; i++) {
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

    storage.save(bingo);
    populateBoard(bingo);
  }
}
