import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/record.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  //final Random _rng = Random();

  late List<Record> _records = [];

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final records = await DatabaseHelper.instance.getAllRecords();
    final recordList = records.map((map) => Record.fromMap(map)).toList();
    setState(() {
      _records = recordList;
    });
  }

  String _formatDateTime(DateTime dt) {
    final date =
        '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    final time =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$date  $time';
  }

  void _addRecord(String text) async {
    Record newRecord = Record(
      dateTime: DateTime.now(),
      text: text,
      recordNote: '',
    );
    await DatabaseHelper.instance.insertRecord(newRecord.toMap());
    await _loadRecords();
  }

  void _editRecord(Record record, String text) async {
    record.setText(text);
    await DatabaseHelper.instance.updateRecord(record.toMap());
    await _loadRecords();
  }

  void _onRecordTap(Record record) {
    _showEditRecordPopup(record);
  }

  void _showPopupForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Simple Form'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Enter text',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle the apply action here, e.g., print the text or process it
                  _addRecord(_textController.text);
                  //print('Applied text: ${_textController.text}');
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditRecordPopup(Record record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Simple Form'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Enter text',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle the apply action here, e.g., print the text or process it
                  _editRecord(record, _textController.text);
                  //print('Applied text: ${_textController.text}');
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('The App Bar'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(onPressed: _showPopupForm, icon: Icon(Icons.add_circle)),
        ],
      ),

      body: _records.isEmpty
          ? Center(
              child: Text(
                'No items yet.\nTap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _records.length,

              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: colors.outlineVariant,
              ),

              itemBuilder: (context, index) {
                final record = _records[index];
                return ListTile(
                  // Datetime shown as a small leading label
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDateTime(record.dateTime),
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.onSurfaceVariant,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  leadingAndTrailingTextStyle: const TextStyle(fontSize: 11),
                  title: Text(record.text),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colors.onSurfaceVariant,
                  ),
                  onTap: () => _onRecordTap(record),
                );
              },
            ),
    );
  }
}
