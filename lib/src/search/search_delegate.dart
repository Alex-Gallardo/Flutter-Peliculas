import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';

class DataSearch extends SearchDelegate {
  String _seleccion = '';
  final peliculasProvider = new PeliculasProviders();

  final peliculas = [
    'Silicon Valley',
    "Scorpion",
    'Fuera de linea',
    "Avengers",
    'Whoami',
    "Chapie"
  ];

  final peliculasRecientes = ['Silicon Valley', 'Scorpion', 'Fuera de linea'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciondes de nuestro AppBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          // Cerrar (volever a la paguina anterior) del buscador
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        child: Text(_seleccion),
        height: 100.0,
        width: 100.0,
        color: Colors.lightBlue,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aperece cuando una persona escribe

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        // Importante definir de que tipo es el snapshot
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          // Este snapshot regresa un listado pelicula
          if (snapshot.hasData) {
            final peliculas = snapshot.data;

            return ListView(
              children: peliculas.map((pelicula) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(pelicula.title),
                  subtitle: Text(pelicula.originalTitle),
                  // Cuando le damos click a algun item
                  onTap: () {
                    // Cerrar la busqueda
                    close(context, null);
                    pelicula.uniqueId = '';
                    // Navegar a otro lugar
                    Navigator.pushNamed(context, 'detalle',
                        arguments: pelicula);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Son las sugerencias que aperece cuando una persona escribe

  //   // Cada vez que la persona escribe la propiedad "query" va a ir cambiando
  //   final listaSugerida = (query.isEmpty)
  //       ? peliculasRecientes
  //       : peliculas
  //           .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
  //           .toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     // Hace un map que recore un listado de elementos
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugerida[i]),
  //         // Recordemos que onTap es la funcion que se dispara cuando hacemos click
  //         onTap: (){
  //           _seleccion = listaSugerida[i];
  //           // Metodo propio del SearchDelegate que construye los resultados en el buildResults (Lo llama)
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }
}
