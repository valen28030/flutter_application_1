import 'package:flutter/material.dart'; // Para usar widgets de Flutter, como botones, textos, etc.
import 'package:provider/provider.dart'; // Para datos o widgets que se comparten entre pantallas.
import 'providers/favoritos_provider.dart'; // Configuración de la lista de favoritos.
import 'screens/app_principal.dart'; // Conecta con la pantalla principal.

// Esta es la primera funcion que ejecuta la app al abrirse
void main() {
  runApp( // Muestra la app en la pantalla del dispositivo
    ChangeNotifierProvider( // Widget que comparte datos en toda la app
      create: (_) => FavoritosCaja(), // Crea una caja donde guardar datos en cualquier pantalla.
      child: const AppPrincipal(),
    ),
  );
}


/** Un provider es una herramienta para guardar una serie de datos, en este caso una lista de favoritos,
 * y poder compartirlos entre pantallas sin tener que llamarlos una y otra vez.
 * El provider guarda la lista en un lugar central de la app para todas las pantallas. 
*/ 