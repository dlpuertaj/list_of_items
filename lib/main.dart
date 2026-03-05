import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New App Ussing Flutter',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),

      themeMode: ThemeMode.dark,

      home: MyHomeScreen(), //const Text('The New App'),MyHomeScreen(),//
    );
  }
}

class Record {
  final DateTime dateTime;
  String text;

  Record({required this.dateTime, required this.text});

  void setText(String text) {
    this.text = text;
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  //final Random _rng = Random();

  final List<Record> _records = [];

  final TextEditingController _textController = TextEditingController();

  String _formatDateTime(DateTime dt) {
    final date =
        '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    final time =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$date  $time';
  }

  void _addRecord(String text) {
    setState(() {
      _records.insert(
        0, // newest item appears at the top
        Record(dateTime: DateTime.now(), text: text),
      );
    });
  }

  void _editRecord(Record record, String text) {
    setState(() {
      record.setText(text);
    });
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
