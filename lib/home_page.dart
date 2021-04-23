import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _tasks = [];

  TextEditingController controller = TextEditingController();

  Future<File> _getFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return File("${appDocDir.path}/dados.json");
  }

  // Save Task
  _saveTask() {
    String textoDigitado = controller.text;

    // Criar dados
    Map<String, dynamic> task = Map();
    task["title"] = textoDigitado;
    task["completed"] = false;

    setState(() {
      _tasks.add(task);
    });

    _saveFile();
    controller.text = "";
  }

  // Save File
  _saveFile() async {
    var arquivo = await _getFile();
    String dados = jsonEncode(_tasks);
    arquivo.writeAsString(dados);
  }

  // Read File
  _readFile() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readFile().then((dados) {
      setState(() {
        _tasks = jsonDecode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("itens: " + _tasks.toString());
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar tarefa"),
                  content: TextField(
                    controller: controller,
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (text) {},
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancelar")),
                    FlatButton(
                        onPressed: () {
                          _saveTask();
                          Navigator.pop(context);
                        },
                        child: Text("Salvar"))
                  ],
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    onChanged: (value) {
                      setState(() {
                        _tasks[index]['completed'] = value;
                      });
                      _saveFile();
                    },
                    value: _tasks[index]['completed'],
                    title: Text(_tasks[index]['title']),
                  );
                }),
          )
        ],
      ),
    );
  }
}
