import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  // const MovieHorizontal({Key key}) : super(key: key);

  final List<Pelicula> peliculas;
  final Function siguientePagina;
  // Definir en el constructor
  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    // Saber el ancho de la pantalla (obtenerlo)
    final _screenSize = MediaQuery.of(context).size;

    // Saber cuando llegamos al final de la "lista"
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        // Cargar siguientes peliculas
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      // PageView renderiza todos los elementos y el PageView.builder los renderiza mediante sean necesarios
      child: PageView.builder(
        // Para que la transision no sea entrecortada y sea fluida
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context, i) {
          return _targeta(peliculas[i], context);
        },
      ),
    );
  }

  Widget _targeta(Pelicula pelicula, BuildContext context) {
    pelicula.uniqueId = '${pelicula.id}-poster';
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Hero Animation, es la animacion cuando vemos los detalles de la pelicula
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/loading.gif'),
                  fit: BoxFit.cover,
                  height: 160.0,
                ),
              ),
            ),
            SizedBox(),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );

    // Gestor de rutas, cuando hagan click
    return GestureDetector(
      child: tarjeta,
      onTap: () {
        // Navegar de una pantalla a otra
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }

  // List<Widget> _tarjetas(BuildContext context) {
  //   return peliculas.map((pelicula) {}).toList();
  // }
}
