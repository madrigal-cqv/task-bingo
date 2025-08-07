import 'package:web/web.dart' as web;

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
  for (int r = 0; r < size; r++) {
    bingo.insertAdjacentHTML('beforeend', "<div class='row' id='r$r'></div>");
    curRow = web.document.querySelector('#r$r') as web.HTMLDivElement;
    for (int c = 0; c < size; c++) {
      curRow.insertAdjacentHTML(
        'beforeend',
        "<div class='col' id='c$c'>col $c</div>",
      );
    }
  }
}

void generateInputs(int numTasks, web.HTMLDivElement tasksInput) {
  int trueNum = numTasks;
  tasksInput.innerHTML = "";
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

void main() {
  final now = DateTime.now();
  final element = web.document.querySelector('#output') as web.HTMLDivElement;
  final bingo = web.document.querySelector("#bingo-card") as web.HTMLDivElement;
  final tasksInput =
      web.document.querySelector("#tasks-input") as web.HTMLDivElement;
  var numTasks =
      web.document.querySelector("#numTasks") as web.HTMLSelectElement;
  generateBoard(int.parse(numTasks.value), bingo);
  generateInputs(int.parse(numTasks.value), tasksInput);
  numTasks.onChange.listen((data) {
    element.text =
        "This exists at ${now.hour}:${now.minute}! ${numTasks.value}";
    generateBoard(int.parse(numTasks.value), bingo);
    generateInputs(int.parse(numTasks.value), tasksInput);
  });
}
