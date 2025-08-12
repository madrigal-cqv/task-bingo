import 'package:quickstart/models/bingo_card.dart';
import 'package:universal_io/io.dart';
import 'dart:convert';

class Storage {
  final String filePath;

  Storage(this.filePath);

  // clear the content of storage
  void clear() {
    final file = File(filePath);
    file.writeAsStringSync(" ");
  }

  // save latest file
  Future<void> save(BingoCard bingo) async {
    final file = File(filePath);
    clear();
    final tasksJson = bingo.tasksList.map((task) => task.toString()).toList();
    final formattedTasksJson = JsonEncoder.withIndent(' ').convert(tasksJson);
    final writeToFile = "{ ${bingo.toString()}, 'task': $formattedTasksJson }";
    await file.writeAsString(writeToFile, mode: FileMode.append);
  }

  // load the latest bingo card
  Future<BingoCard?> load() async {
    final file = File(filePath);

    // create file if somehow does not exist
    if (!await file.exists()) {
      await file.create(recursive: true);
      return null;
    }

    final content = await file.readAsString();
    final data = jsonDecode(content);
    print(data);
    return BingoCard(
      DateTime.parse(data['startTime']),
      DateTime.parse(data['endTime']),
      [],
    );
  }
}
