import 'package:flutter/material.dart';
import 'package:flutter_sockets/models/Bici.dart';

class HomePage extends StatefulWidget {
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
        onPressed: () => addNewBici,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  ListTile _biciTile(Bici bici) {
    return ListTile(
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
    );
  }

  addNewBici() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nueva bici nombre: '),
            content: TextField(),
            actions: [
              MaterialButton(
                onPressed: () {},
                child: Text('Añadir'),
                elevation: 5,
              )
            ],
          );
        });
  }
}
