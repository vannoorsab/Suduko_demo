import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _apiKey;

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final apiKey = await storage.read(key: 'api_key');

    if (apiKey == null) {
      // Prompt the user to enter their API key
      final enteredApiKey = await _promptUserForApiKey(context);
      await storage.write(key: 'api_key', value: enteredApiKey);
      setState(() {
        _apiKey = enteredApiKey;
      });
    } else {
      setState(() {
        _apiKey = apiKey;
      });
    }
  }

  Future<String?> _promptUserForApiKey(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    String? apiKey;
    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter your API key'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'API key',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                apiKey = controller.text;
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return apiKey;
  }

 //class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SudokuGame(),
    );
  }
}

class SudokuGame extends StatefulWidget {
  @override
  _SudokuGameState createState() => _SudokuGameState();
}

class _SudokuGameState extends State<SudokuGame> {
  List<List<int>> _grid = List.generate(9, (i) => List.generate(9, (j) => 0));

  void _fillNumber(int row, int col, int number) {
    setState(() {
      _grid[row][col] = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sudoku Game'),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
              ),
              shrinkWrap: true,
              itemCount: 81,
              itemBuilder: (context, index) {
                int row = index ~/ 9;
                int col = index % 9;
                return GestureDetector(
                  onTap: () {
                    final controller = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Enter a number'),
                          content: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Number',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                final number = int.parse(controller.text);
                                _fillNumber(row, col, number);
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _grid[row][col] == 0 ? '' : _grid[row][col].toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}