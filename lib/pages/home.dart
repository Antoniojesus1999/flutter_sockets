import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sockets/models/bici.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Bici> bicis = [
    Bici(id: '1', nombre: 'Trek', votos: 2),
    Bici(id: '2', nombre: 'Trifox', votos: 5),
    Bici(id: '3', nombre: 'Mendiz', votos: 2),
    Bici(id: '4', nombre: 'Cannyon', votos: 10)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Bicis', style: TextStyle(color: Colors.black87))),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
          itemCount: bicis.length,
          itemBuilder: (context, i) => _biciTile(bicis[i])),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBici,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  Widget _biciTile(Bici bici) {
    return Dismissible(
      key: Key(bici.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        //todo borrar en back
      },
      background: Container(
        padding: const EdgeInsets.only(left: 0.8),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Borrar bici',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(bici.nombre.substring(0, 2)),
        ),
        title: Text(bici.nombre),
        trailing: Text(
          '${bici.votos}',
          style: const TextStyle(fontSize: 20),
        ),
        onTap: (() {
          print(bici.nombre);
        }),
      ),
    );
  }

  addNewBici() {
    final textController = TextEditingController();

    if (!Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Nueva bici nombre: '),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  onPressed: () => addBiciToList(textController.text),
                  child: Text('Añadir'),
                  elevation: 5,
                  textColor: Colors.blue,
                )
              ],
            );
          });
    }
    showCupertinoDialog(
        builder: (_) {
          return CupertinoAlertDialog(
            title: const Text('Nuevo nombre bici'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('Añadir'),
                isDefaultAction: true,
                onPressed: () => addBiciToList(textController.text),
              ),
              CupertinoDialogAction(
                child: Text('Borrar'),
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        },
        context: context);
  }

  void addBiciToList(String nombre) {
    ;
    if (nombre.length > 1) {
      //podemos agregar
      this.bicis.add(
          new Bici(id: DateTime.now().toString(), nombre: nombre, votos: 0));
    }
    Navigator.pop(context);
  }
}
