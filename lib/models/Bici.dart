class Bici {
  String id;
  String nombre;
  int votos;

  Bici({required this.id, required this.nombre, required this.votos});

  factory Bici.fromMap(Map<String, dynamic> obj) => Bici(
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      nombre: obj.containsKey('nombre') ? obj['nombre'] : 'Sin nombre',
      votos: obj.containsKey('votos') ? obj['votos'] : 0);
}
