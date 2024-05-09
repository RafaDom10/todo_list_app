import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List _toDoList = [];
  final TextEditingController _toDoController = TextEditingController();

  void onPressed(BuildContext context) {
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
                      onPressed: () => onPressed(context),
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
