import 'package:quickstart/models/bingo_card.dart';
import 'package:web/web.dart' as web;

mixin BingoMonitor {
  int getSize(int numTasks) {
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

  void bingoNotify(BingoCard bingo, web.HTMLDivElement bingoNoti) {
    int bingos = _bingoCheck(bingo);
    if (bingos > 0) {
      if (bingos == getSize(bingo.tasksList.length) * 2 + 2) {
        bingoNoti.innerText = "FULL BINGO!";
      } else {
        bingoNoti.innerText = "$bingos BINGO!";
      }
    } else {
      bingoNoti.innerText = "";
    }
  }

  int _bingoCheck(BingoCard bingo) {
    int size = getSize(bingo.tasksList.length);
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
}
