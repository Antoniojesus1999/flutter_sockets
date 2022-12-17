class Bici {
  String id;
  String nombre;
  int votos;

  Bici({required this.id, required this.nombre, required this.votos});

  factory Bici.fromMap(Map<String, dynamic> obj) =>
      Bici(id: obj['id'], nombre: obj['nombre'], votos: obj['votos']);
}
