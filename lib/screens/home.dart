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
  List _toDoList = [];
  final TextEditingController _toDoController = TextEditingController();
  late int _indexOfLastRemoved;
  late Map<String, dynamic> _lastRemoved;

  @override
  void initState() {
    super.initState();
    _getData().then((value) => {
          if (value != null)
            {
              setState(() {
                _toDoList = json.decode(value);
              })
            }
        });
  }

  Future<String?> _getData() async {
    try {
      final archive = await _openFile();
      return archive.readAsString();
    } catch (err) {
      return null;
    }
  }

  Future<File> _openFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/toDoList.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _openFile();
    return file.writeAsString(data);
  }

  Future<Null> _reload() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _toDoList.sort((a, b) {
        if (a['done'] && !b['done']) {
          return 1;
        }

        if (!a['done'] && b['done']) {
          return -1;
        }

        return 0;
      });
      _saveData();
    });

    return null;
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
    } else {
      _addTask();
    }
  }

  void _onDismissed(
      DismissDirection direction, int index, BuildContext context) {
    setState(() {
      _lastRemoved = Map.from(_toDoList[index]);
      _indexOfLastRemoved = index;
      _toDoList.removeAt(index);
      _saveData();
    });

    SnackBar snack = SnackBar(
      duration: const Duration(seconds: 5),
      content: Text('Tarefa "${_lastRemoved['title']}" removida.'),
      action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () => {
                setState(() {
                  _toDoList.insert(_indexOfLastRemoved, _lastRemoved);
                  _saveData();
                })
              }),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Widget widgetTask(BuildContext context, int index) {
    return Dismissible(
        key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
        background: Container(
          color: Colors.red,
          child: const Align(
            alignment: Alignment(0.5, 0.0),
            child: Icon(
              Icons.delete_sweep_outlined,
              color: Colors.white,
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => _onDismissed(direction, index, context),
        child: CheckboxListTile(
          title: Text('${_toDoList[index]['title']}'),
          value: _toDoList[index]['done'],
          secondary: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              _toDoList[index]['done'] ? Icons.check : Icons.error,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          onChanged: (value) => {
            setState(() {
              _toDoList[index]['done'] = value;
              _saveData();
            })
          },
          checkColor: Theme.of(context).primaryColor,
          activeColor: Theme.of(context).secondaryHeaderColor,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Expanded(
                child: RefreshIndicator(
              onRefresh: _reload,
              child: ListView.builder(
                  itemBuilder: widgetTask,
                  itemCount: _toDoList.length,
                  padding: const EdgeInsets.only(top: 10.0)),
            ))
          ],
        ),
      ),
    );
  }
}
