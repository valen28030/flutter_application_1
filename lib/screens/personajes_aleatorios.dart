import 'package:flutter/material.dart';
// Importo las librerías necesarias para la funcionalidad.
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // Para hacer peticiones HTTP a una API.
import 'dart:convert'; // Convierte el JSON de la API en Dart.
import 'dart:math'; // Para generar números aleatorios y poder escribir Random().
import '../providers/favoritos_provider.dart';

// Permite que la app cambie cuando se abra o recargue.
class PersonajesAleatorios extends StatefulWidget {
  const PersonajesAleatorios({super.key});

  @override
  EstadoAleatorio createState() => EstadoAleatorio();
}

class EstadoAleatorio extends State<PersonajesAleatorios> {
  // Creo una variable Map, llamada personaje, que guarda en string los datos de la API.
  Map<String, dynamic>?
      personaje; // dynamic sirve para que manejar diferentes valores. Int, String, List, etc.

  // Llama a la función crearAleatorio.
  @override
  void initState() {
    super.initState();
    crearAleatorio();
  }

  // Función para crear un personaje aleatorio.
  Future<void> crearAleatorio() async {
    // Crea un número aleatorio entre las ID de 1 y 2138.
    final idAleatorio = Random().nextInt(2138) + 1;

    // Llama a la URL de la API y utiliza un ID aleatorio.
    final url =
        Uri.parse('https://anapioficeandfire.com/api/characters/$idAleatorio');

    try {
      // Realiza un GET a la URL.
      final respuesta = await http.get(url);

      // Código de estado 200 significa que ha sido exitosa.
      if (respuesta.statusCode == 200) {
        // Decodifica el JSON para obtener los datos del personaje.
        final datos = json.decode(respuesta.body);

        // Si el personaje no tiene nombre y alias, selecciona otro.
        if (datos['name'] == '' && datos['aliases'].isEmpty) {
          await crearAleatorio(); // Llama a la función para obtener otro personaje con nombre o alias.
        } else {
          // Si el personaje tiene nombre o alias.
          setState(() {
            personaje =
                datos; // Comparte los datos del personaje a la variable "personaje".
          });
        }
      }
    } catch (e) {
      // Si ocurre un error.
      debugPrint(
          'Error al realizar la solicitud: $e'); // Imprime error en consola.
    }
  }

  // Interfaz
  @override
  Widget build(BuildContext context) {
    final listaFav = Provider.of<FavoritosCaja>(
        context); // Variable de la lista de favoritos en el provider.
    final okFav = personaje != null &&
        listaFav.favoritos
            .contains(personaje); // Comprueba si el personaje ya es favorito.

    // Diseño y estructura de la pantalla.
    return Container(
      decoration: const BoxDecoration(
        // Fondo de la pantalla definido con una imagen.
        image: DecorationImage(
          image: AssetImage('assets/fondo.jpeg'), // Ruta de la imagen.
          fit: BoxFit.cover, // Ajusta la imagen para cubrir toda la pantalla.
        ),
      ),
      child: Scaffold(
        // Barra superior con el título.
        appBar: AppBar(
          title: const Text('Personaje Aleatorio'),
        ),
        // Cuerpo de la pantalla.
        backgroundColor: Colors.transparent, // Hacer transparente para mostrar el fondo.
        body: personaje == null
            // Si el personaje es nulo muestra el círculo de cargando.
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0), // Establece márgenes.
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Centra toda la columna.
                  children: [
                    // Muestra el nombre del personaje, o "Desconocido" si es nulo.
                    Text(
                      'Nombre: ${personaje!['name'] ?? 'Desconocido'}',
                      style: const TextStyle(
                          fontSize: 20, // Tamaño del texto.
                          fontWeight: FontWeight.bold, // Texto en negrita.
                          color:
                              Color.fromARGB(255, 0, 217, 255) // Texto color celeste.
                          ),
                    ),
                    const SizedBox(height: 8), // Espaciado de altura.

                    // Muestra la cultura del personaje, o "Desconocida" si es nula.
                    Text(
                      'Cultura: ${personaje!['culture'] ?? 'Desconocida'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    // Muestra el año de nacimiento del personaje, o "Desconocido" si es nulo.
                    Text(
                      'Nacido: ${personaje!['born'] ?? 'Desconocido'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    // Muestra los títulos del personaje, o "Ninguno" si no tiene títulos.
                    Text(
                      'Títulos: ${personaje!['titles']?.join(", ") ?? 'Ninguno'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    // Muestra los alias del personaje, o "Ninguno" si no tiene alias.
                    Text(
                      'Alias: ${personaje!['aliases']?.join(", ") ?? 'Ninguno'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    // Botón para añadir o eliminar de favoritos.
                    ElevatedButton.icon(
                      onPressed: () {
                        if (personaje != null) {
                          // Llama a la función compruebActualiza del provider para saber si añade o elimina personaje.
                          listaFav.compruebActualiza(personaje!);
                        }
                      },
                      icon: Icon(
                        okFav
                            ? Icons.favorite
                            : Icons.favorite_border, // Icono del botón (corazón lleno o vacío)
                        color: const Color.fromARGB(255, 0, 0, 0), // Icono en negro
                      ),
                      label: Text(
                        okFav
                            ? 'Eliminar de Favoritos'
                            : 'Añadir a Favoritos',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0)), // Texto en negro
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: okFav
                            ? const Color.fromARGB(255, 255, 185, 180) // Fondo si es favorito.
                            : const Color.fromARGB(255, 142, 255, 246), // Fondo si no es favorito.
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
