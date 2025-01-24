import 'package:flutter/foundation.dart';

// Clase que gestiona la lista de personajes favoritos.
class FavoritosCaja with ChangeNotifier {
  // Lista interna que almacena los personajes favoritos.
  final List<Map<String, dynamic>> _favoritos = [];

  // Getter que devuelve la lista de favoritos.
  List<Map<String, dynamic>> get favoritos => _favoritos;

  // Función para agregar o eliminar un personaje de la lista de favoritos.
  void compruebActualiza(Map<String, dynamic> personaje) {
    if (_favoritos.contains(personaje)) {
      // Si el personaje ya está en la lista, se elimina.
      _favoritos.remove(personaje);
    } else {
      // Si el personaje no está en la lista, se añade.
      _favoritos.add(personaje);
    }
    // Notifica a los oyentes (widgets) que la lista de favoritos ha cambiado.
    notifyListeners();
  }
}
