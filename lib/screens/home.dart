import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List _toDoList = [];
  final TextEditingController _toDoController = TextEditingController();

  Future<File> _openFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/toDoList.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _openFile();
    return file.writeAsString(data);
  }

  void _addTask() {
    setState(() {
      Map<String, dynamic> newTask = {};
      newTask['title'] = _toDoController.text;
      newTask['done'] = false;
      _toDoController.text = '';
      _toDoList.add(newTask);
      _saveData();
    });
  }

  void _onPressed(BuildContext context) {
    if (_toDoController.text.isEmpty) {
      SnackBar alert = SnackBar(
        content: const Text('Nome da tarefa é obrigatório'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
            label: 'ok',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }),
      );

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(alert);
    }

    _addTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _toDoController,
                    maxLength: 50,
                    decoration:
                        const InputDecoration(label: Text('Nova tarefa')),
                  )),
                  SizedBox(
                    height: 45.0,
                    width: 45.0,
                    child: FloatingActionButton(
                      onPressed: () => _onPressed(context),
                      child: const Icon(Icons.save),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
