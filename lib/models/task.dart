class Task {
  final String _name;
  bool _done = false;

  Task({required String name}) : _name = name;

  String getName() {
    return _name;
  }

  bool isDone() {
    return _done;
  }

  void markAsDone() {
    _done = true;
  }

  @override
  String toString() {
    return '{ "name": "$_name", "done": $_done }';
  }
}
