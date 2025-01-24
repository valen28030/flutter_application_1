import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favoritos_provider.dart';

class DetallesPersonaje extends StatelessWidget {
  final Map<String, dynamic> personaje;

  const DetallesPersonaje({super.key, required this.personaje});

  @override
  Widget build(BuildContext context) {
    final favoritosProvider = Provider.of<FavoritosCaja>(context);
    final esFavorito = favoritosProvider.favoritos.contains(personaje);

    // Si el campo 'name' está vacío, se asigna el primer valor de 'aliases'
    String nombrePersonaje = personaje['name']?.isNotEmpty == true
        ? personaje['name']
        : (personaje['aliases']?.isNotEmpty == true ? personaje['aliases'][0] : 'Desconocido');

    // Misma estructura y diseño que en la pantalla personajes_aleatorios.dart
    return Container(
      decoration: const BoxDecoration(
        // Fondo de la pantalla definido con una imagen.
        image: DecorationImage(
          image: AssetImage('assets/fondo1.jpeg'), // Ruta de la imagen.
          fit: BoxFit.cover, // Ajusta la imagen para cubrir toda la pantalla.
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Hacer transparente para mostrar el fondo.
        appBar: AppBar(
          title: Text('Detalles de $nombrePersonaje'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nombre: $nombrePersonaje',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Cultura: ${personaje['culture'] ?? 'Desconocida'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Nacido: ${personaje['born'] ?? 'Desconocido'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Títulos: ${personaje['titles']?.join(", ") ?? 'Ninguno'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Alias: ${personaje['aliases']?.join(", ") ?? 'Ninguno'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  favoritosProvider.compruebActualiza(personaje);
                },
                icon: Icon(
                  esFavorito ? Icons.favorite : Icons.favorite_border,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                label: Text(
                  esFavorito ? 'Eliminar de Favoritos' : 'Añadir a Favoritos',
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: esFavorito
                      ? const Color.fromARGB(255, 255, 185, 180)
                      : const Color.fromARGB(255, 142, 255, 246),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
