class Record {
  final DateTime dateTime;
  String text;

  Record({required this.dateTime, required this.text});

  void setText(String text) {
    this.text = text;
  }
}
