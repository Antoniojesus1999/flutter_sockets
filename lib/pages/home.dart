import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sockets/models/bici.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Bici> bicis = [];
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bicis', _handleActiveBici);
    super.initState();
  }

  void _handleActiveBici(dynamic payload) {
    bicis = (payload as List).map((bici) => Bici.fromMap(bici)).toList();

    setState(() {});
  }

/*
 Sirve para dejar de escuchar el evento

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bicis');
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Bicis', style: TextStyle(color: Colors.black87))),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.online)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
                itemCount: bicis.length,
                itemBuilder: (context, i) => _biciTile(bicis[i])),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBici,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _biciTile(Bici bici) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(bici.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket.emit('borrar-bici', {'id': bici.id}),
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
        onTap: () => socketService.socket.emit('votar-bici', {'id': bici.id}),
      ),
    );
  }

  addNewBici() {
    final textController = TextEditingController();

    if (!Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
              ));
    }
    showCupertinoDialog(
        builder: (_) => CupertinoAlertDialog(
              title: const Text('Nuevo nombre bici'),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => addBiciToList(textController.text),
                  child: const Text('Añadir'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Volver'),
                )
              ],
            ),
        context: context);
  }

  void addBiciToList(String nombre) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (nombre.length > 1) {
      socketService.socket.emit('crear-bici', {'nombre': nombre});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};

    for (var bici in bicis) {
      dataMap.putIfAbsent(bici.nombre, () => bici.votos.toDouble());
    }
    final List<Color> colorList = [
      Colors.blue[50] as Color,
      Colors.blue[200] as Color,
      Colors.pink[50] as Color,
      Colors.pink[200] as Color,
      Colors.yellow[50] as Color,
      Colors.yellow[200] as Color
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 300,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 900),
        chartLegendSpacing: 50,
        colorList: colorList,
        chartType: ChartType.ring,
        ringStrokeWidth: 42,
        centerText: "Biciletas!!",
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 2,
        ),
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      ),
    );
  }
}
