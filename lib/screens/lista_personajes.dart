import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detalles_personaje.dart';

class ListaPersonajes extends StatefulWidget {
  const ListaPersonajes({super.key});

  @override
  EstadoLista createState() => EstadoLista();
}

class EstadoLista extends State<ListaPersonajes> {
  // Lista donde se almacenan los personajes obtenidos de la API.
  List<dynamic> personajes = [];
  int pagina = 1; // Primera página que se ve de la API.
  bool cargando = false; // Variable para ver si los datos están cargando.

  @override
  void initState() {
    super.initState();
    crearLista();
  }

  // Función para traer los personajes desde la API y crear la lista.
  Future<void> crearLista() async {
    if (cargando) return;
    setState(() {
      cargando = true; // Se cargan los datos.
    });

    final url = Uri.parse(
        'https://www.anapioficeandfire.com/api/characters?page=$pagina&pageSize=10'); // URL de la API con paginación.
    try {
      final respuesta = await http.get(url);
      if (respuesta.statusCode == 200) {
        final datos = json.decode(respuesta.body);

        // Ordena alfabéticamente los personajes por nombre o alias.
        final List<dynamic> personajesOrdenados = datos;
        personajesOrdenados.sort((a, b) {
          // Si el personaje no tiene nombre, utilizamos el primer alias como sustituto.
          String nombreA = a['name']?.isNotEmpty == true
              ? a['name']
              : a['aliases']?.first ?? '';
          String nombreB = b['name']?.isNotEmpty == true
              ? b['name']
              : b['aliases']?.first ?? '';
          return nombreA.compareTo(nombreB);
        });
        setState(() {
          personajes.clear(); // Lista a 0.
          personajes.addAll(personajesOrdenados); // Añadimos los personajes ordenados.
          cargando = false; // Termina de cargar.
        });
      }
    } catch (e) {
      setState(() {
        cargando = false; // Error, cambiamos a no cargando.
      });
      debugPrint('Error al realizar la solicitud: $e'); // Imprime el error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // Fondo de la pantalla definido con una imagen.
        image: DecorationImage(
          image: AssetImage('assets/fondo3.jpg'),
          fit: BoxFit.cover, // Ajusta la imagen para cubrir toda la pantalla.
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Hacer transparente para mostrar el fondo.
        appBar: AppBar(
          title: const Text('Lista de Personajes'),
        ),
        body: Column(
          children: [
            Expanded(
              child: personajes.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: personajes.length, // Todos los personajes.
                      itemBuilder: (context, index) {
                        final personaje = personajes[index]; // Personaje en su posición.
                        // Si el nombre del personaje no está vacío, lo mostramos; si no, mostramos "Desconocido".
                        String nombrePersonaje = (personaje['name']?.isNotEmpty == true)
                            ? personaje['name']
                            : (personaje['aliases']?.isNotEmpty == true
                                ? personaje['aliases'][0]
                                : 'Desconocido');
                        return ListTile(
                          title: Text(nombrePersonaje), // Nombre del personaje en la lista.
                          leading: const Icon(Icons.person),
                          iconColor: Color.fromARGB(255, 0, 0, 0), // Icono al lado del nombre.
                          textColor: const Color.fromARGB(255, 0, 0, 0), // Color del texto.
                          onTap: () {
                            // Acción cuando se toca un personaje.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetallesPersonaje(personaje: personaje), // Navega a la pantalla de detalles del personaje.
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón para ir a la página anterior.
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: pagina > 1 && !cargando
                        ? () {
                            // Solo permite navegar hacia atrás si no estamos en la primera página.
                            setState(() {
                              pagina--; // Disminuye la página actual.
                            });
                            crearLista(); // Carga los personajes de la página anterior.
                          }
                        : null, // Si no es posible, desactiva el botón.
                  ),
                  // Botón para ir a la página siguiente.
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: !cargando
                        ? () {
                            // Solo permite navegar hacia adelante si no se están cargando los datos.
                            setState(() {
                              pagina++; // Aumenta la página actual.
                            });
                            crearLista(); // Carga los personajes de la página siguiente.
                          }
                        : null, // Si se está cargando, desactiva el botón.
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
