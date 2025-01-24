import 'package:flutter/material.dart';
// Llamo a los archivos de otras pantallas.
import 'package:flutter_application_1/screens/personajes_aleatorios.dart';
import 'package:flutter_application_1/screens/lista_personajes.dart';
import 'package:flutter_application_1/screens/favoritos.dart';

class AppPrincipal extends StatefulWidget {
  const AppPrincipal({super.key});

  @override
  EstadoPrincipal createState() => EstadoPrincipal();
}

class EstadoPrincipal extends State<AppPrincipal> {
  int indice = 0; // Variable para almacenar el índice de la página actual seleccionada.

  // Lista de páginas que se muestran cuando el usuario selecciona una pestaña o icono.
  final List<Widget> paginas = [
    const PersonajesAleatorios(), // Primera página (personajes aleatorios).
    const ListaPersonajes(), // Segunda página (lista de personajes).
    const Favoritos(), // Tercera página (favoritos).
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // Fondo de la aplicación definido con una imagen
        image: DecorationImage(
          image: AssetImage('assets/fondo.jpeg'), // Ruta de la imagen
          fit: BoxFit.cover, // Ajusta la imagen para cubrir toda la pantalla
        ),
      ),
      child: MaterialApp(
        title: 'Juego de Tronos', // Título de la aplicación
        theme: ThemeData(
          // Define el tema general de la aplicación.
          primarySwatch: Colors.blue, // Color principal de la aplicación (el color azul).
          brightness: Brightness.dark, // El brillo de la aplicación es oscuro.
        ),
        // El diseño de la pantalla principal de la app.
        home: Scaffold(
          // Barra superior con el título de la aplicación.
          appBar: AppBar(
            title: const Text('Juego de Tronos'),
          ),
          body: paginas[indice], // Muestra la página correspondiente según el índice actual.
          bottomNavigationBar: BottomNavigationBar(
            // Barra de navegación en la parte inferior para cambiar entre páginas.
            currentIndex: indice, // Establecer el índice actual de la barra de navegación.
            onTap: (index) {
              // Cuando se hace clic en un ítem de la barra de navegación.
              setState(() {
                // Cambiar el estado para que se actualice la página seleccionada.
                indice = index; // Actualizar el índice de la página actual.
              });
            },
            items: const [
              // Define los íconos y etiquetas de la barra de navegación.
              BottomNavigationBarItem(
                icon: Icon(Icons.home), // Ícono para la página "Home".
                label: 'Home', // Etiqueta para la página "Home".
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list), // Ícono para la página "Lista".
                label: 'Lista', // Etiqueta para la página "Lista".
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite), // Ícono para la página "Favoritos".
                label: 'Favoritos', // Etiqueta para la página "Favoritos".
              ),
            ],
          ),
        ),
      ),
    );
  }
}
