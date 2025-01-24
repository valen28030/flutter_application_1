import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favoritos_provider.dart';

class Favoritos extends StatelessWidget {
  const Favoritos({super.key});

  @override
  Widget build(BuildContext context) {
    final listaFav = Provider.of<FavoritosCaja>(context);

    return Container(
      decoration: const BoxDecoration(
        // Fondo de la pantalla definido con una imagen.
        image: DecorationImage(
          image: AssetImage('assets/fondo2.jpg'), // Ruta de la imagen.
          fit: BoxFit.cover, // Ajusta la imagen para cubrir toda la pantalla.
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Hacer transparente para mostrar el fondo.
        appBar: AppBar(
          title: const Text('Favoritos'),
        ),
        body: ListView.builder(
          itemCount: listaFav.favoritos.length, // Número de elementos en la lista.
          itemBuilder: (context, index) {
            final personaje = listaFav.favoritos[index]; // Obtiene el personaje actual.

            // Obtiene el nombre del personaje. Si no tiene nombre, se utiliza el alias o "Desconocido".
            String nombrePersonaje = (personaje['name']?.isNotEmpty == true)
                ? personaje['name']
                : (personaje['aliases']?.isNotEmpty == true ? personaje['aliases'][0] : 'Desconocido');

            return ListTile(
              // Muestra el nombre del personaje.
              title: Text(
                nombrePersonaje,
                style: const TextStyle(
                  fontSize: 20, // Tamaño de la fuente.
                  fontWeight: FontWeight.bold, // Estilo de fuente en negrita.
                  color: Color.fromARGB(255, 255, 0, 0), // Color del texto.
                ),
              ),
              tileColor: const Color.fromARGB(103, 202, 202, 202), // Color de fondo del ítem.
              // Botón para eliminar el personaje de los favoritos.
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete, // Icono de eliminar.
                  color: Color.fromARGB(255, 255, 255, 255), // Color del icono.
                ),
                onPressed: () {
                  // Llama a la función del proveedor para eliminar o cambiar el estado del personaje.
                  listaFav.compruebActualiza(personaje);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
