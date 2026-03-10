import '../database/database_helper.dart';
import '../models/record.dart';

class DatabaseUtils {
  static Future<List<Record>> fetchRecords() async {
    final records = await DatabaseHelper.instance.getAllRecords();
    return records.map((map) => Record.fromMap(map)).toList();
  }

  static void addRecord(String text) async {
    Record newRecord = Record(
      dateTime: DateTime.now(),
      text: text,
      recordNote: '',
    );
    await DatabaseHelper.instance.insertRecord(newRecord.toMap());
  }

  static void editRecord(Record record, String text) async {
    record.setText(text);
    await DatabaseHelper.instance.updateRecord(record.toMap());
  }

  static void deleteRecord(Record record) async {
    await DatabaseHelper.instance.deleteRecord(record.id!);
  }
}
