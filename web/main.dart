import 'package:web/web.dart' as web;

void generateBoard(int numTasks, web.HTMLDivElement bingo) {
  switch (numTasks) {
    case 9:
      break;
    case 16:
      break;
    case 25:
      break;
  }
}

void main() {
  final now = DateTime.now();
  final element = web.document.querySelector('#output') as web.HTMLDivElement;
  final bingo = web.document.querySelector("#bingo-card") as web.HTMLDivElement;
  var numTasks =
      web.document.querySelector("#numTasks") as web.HTMLSelectElement;
  numTasks.onChange.listen(
    (data) => element.text =
        'This exists at ${now.hour}:${now.minute}! ${numTasks.value}',
  );
}
