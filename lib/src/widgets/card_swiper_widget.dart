import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  // ESTO ES IGUAL A LOS PROPS
  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      // Ancho total
      // width: double.infinity,
      padding: EdgeInsets.only(top: 20.0),
      child: Swiper(
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {

          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  // Navegar de una pantalla a otra
                  onTap: () {
                    Navigator.pushNamed(context, 'detalle',
                        arguments: peliculas[index]);
                  },
                  child: FadeInImage(
                      image: NetworkImage(peliculas[index].getPosterImg()),
                      placeholder: AssetImage('assets/img/loading.gif'),
                      fit: BoxFit.cover),
                )
                //new Image.network(
                //   "http://via.placeholder.com/350x150",
                //   // Fit: La imagen se adapte a las dimenciones que tiene
                //   fit: BoxFit.cover,
                // ),
                ),
          );
        },
        itemCount: peliculas.length,
        layout: SwiperLayout.STACK,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
