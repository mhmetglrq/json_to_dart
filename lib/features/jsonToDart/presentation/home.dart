import 'dart:convert';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _jsonController = TextEditingController();
  String _dartClass = '';

  void _convertJSON() {
    final String jsonString = _jsonController.text;

    try {
      final jsonData = jsonDecode(jsonString);

      if (jsonData is Map<String, dynamic>) {
        setState(() {
          _dartClass = generateDartClass(jsonData);
        });
      } else {
        setState(() {
          _dartClass = 'Invalid JSON format.';
        });
      }
    } catch (e) {
      setState(() {
        _dartClass = 'Error: ${e.toString()}';
      });
    }
  }

  String generateDartClass(Map<String, dynamic> jsonData) {
    StringBuffer classBuffer = StringBuffer();
    classBuffer.writeln('class MyClass {');

    jsonData.forEach((key, value) {
      classBuffer.writeln('  final ${value.runtimeType} $key;');
    });

    classBuffer.writeln('\n  MyClass({');
    jsonData.forEach((key, value) {
      classBuffer.writeln('    required this.$key,');
    });
    classBuffer.writeln('  });');

    classBuffer
        .writeln('\n  factory MyClass.fromJson(Map<String, dynamic> json) {');
    classBuffer.writeln('    return MyClass(');
    jsonData.forEach((key, value) {
      classBuffer.writeln('      $key: json[\'$key\'],');
    });
    classBuffer.writeln('    );');
    classBuffer.writeln('  }\n}');

    return classBuffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _jsonController,
              maxLines: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter JSON',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertJSON,
              child: const Text('Convert to Dart Class'),
            ),
            const SizedBox(height: 16),
            const Text('Dart Class Output:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SelectableText(_dartClass),
          ],
        ),
      ),
    );
  }
}
