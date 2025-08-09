class Task {
  final String _name;
  bool _done = false;

  Task({required String name}) : _name = name;

  void markAsDone() {
    _done = true;
  }

  @override
  String toString() {
    return '{ "name": $_name, "done": $_done }';
  }
}
