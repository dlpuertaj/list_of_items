class Record {
  final int? id;
  final DateTime dateTime;
  String text;
  String? recordNote;

  Record({
    this.id,
    required this.dateTime,
    required this.text,
    required this.recordNote,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'text': text,
      'recordNote': recordNote,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      text: map['text'],
      recordNote: map['recordNote'],
    );
  }

  void setText(String text) {
    this.text = text;
  }
}
