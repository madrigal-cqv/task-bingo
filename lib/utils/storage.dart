import 'package:quickstart/models/bingo_card.dart';
import 'dart:convert';
import 'package:web/web.dart' as web;
import 'package:quickstart/models/task.dart';

class Storage {
  // clear the content of storage
  void clear() {
    web.window.localStorage["startTime"] = '';
    web.window.localStorage["endTime"] = '';
    web.window.localStorage["tasks"] = '';
    web.window.localStorage["order"] = '';
  }

  // save latest bingo card
  void save(BingoCard bingo) {
    clear();
    web.window.localStorage["startTime"] = bingo.startTime.toString();
    web.window.localStorage["endTime"] = bingo.endTime.toString();
    final tasksJson = bingo.tasksList.map((task) => task.toString()).toList();
    final tasksFormatted = JsonEncoder.withIndent(' ').convert(tasksJson);
    web.window.localStorage["tasks"] = tasksFormatted;
    web.window.localStorage["order"] = bingo.tasksOrder.toString();
  }

  // load the latest bingo card
  BingoCard? load() {
    String? startTime = web.window.localStorage["startTime"];
    String? endTime = web.window.localStorage["endTime"];
    String? tasksListJson = web.window.localStorage["tasks"];
    String? tasksOrderJson = web.window.localStorage["order"];

    if (startTime == null ||
        endTime == null ||
        tasksListJson == null ||
        tasksOrderJson == null ||
        startTime == '' ||
        endTime == '' ||
        tasksListJson == '' ||
        tasksOrderJson == '') {
      return null;
    }

    List<Task> taskListDecoded = [];
    final List<dynamic> tasksList = jsonDecode(tasksListJson);
    for (int i = 0; i < tasksList.length; i++) {
      final taskJson = jsonDecode(tasksList[i]);
      taskListDecoded.add(Task(name: taskJson["name"]));
      if (taskJson["done"]) {
        taskListDecoded.last.markAsDone();
      }
    }

    List<int> taskOrderDecoded = jsonDecode(tasksOrderJson).cast<int>();

    final result = BingoCard(
      DateTime.parse(startTime),
      DateTime.parse(endTime),
      taskListDecoded,
    );
    result.tasksOrder = taskOrderDecoded;

    return result;
  }
}
