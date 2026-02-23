import 'dart:math';
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
  final String text;

  const Record({required this.dateTime, required this.text});
}

const List<String> _wordPool = [
  'apple',
  'river',
  'thunder',
  'cabinet',
  'horizon',
  'lantern',
  'marble',
  'falcon',
  'crystal',
  'shadow',
  'forest',
  'pebble',
  'canyon',
  'ember',
  'whisper',
  'glacier',
  'sparrow',
  'cobalt',
  'driftwood',
  'solstice',
  'nimbus',
  'tandem',
  'cinder',
  'quartz',
  'bramble',
  'eclipse',
  'vortex',
  'flicker',
  'monsoon',
  'cellar',
  'anchor',
  'tundra',
  'hollow',
  'prism',
];

String _randomText(Random rng) {
  final wordCount = rng.nextInt(4) + 2; // 2 to 5 words
  final words = List.generate(
    wordCount,
    (_) => _wordPool[rng.nextInt(_wordPool.length)],
  );
  words[0] =
      words[0][0].toUpperCase() + words[0].substring(1); // capitalize first
  return words.join(' ');
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final Random _rng = Random();

  final List<Record> _records = [];

  String _formatDateTime(DateTime dt) {
    final date =
        '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    final time =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$date  $time';
  }

  void _addRecord() {
    setState(() {
      _records.insert(
        0, // newest item appears at the top
        Record(dateTime: DateTime.now(), text: _randomText(_rng)),
      );
    });
  }

  void _onRecordTap(Record item) {
    // TODO: define beShavior on item tap (e.g. open detail page, edit, etc.)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tapped: ${item.text}')));
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
          IconButton(onPressed: _addRecord, icon: Icon(Icons.add_circle)),
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
