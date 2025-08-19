import 'package:web/web.dart' as web;

mixin Generate {
  // Generate the bingo board based on the number of tasks
  void generateBoard(int numTasks, web.HTMLDivElement bingo) {
    bingo.innerHTML = "";
    web.HTMLDivElement curRow;
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

  void generateInputs(int numTasks, web.HTMLDivElement tasksInput) {
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
}
