import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

// Aqui es donde hacemos todas las peticiones a la Api (aqui van todos los metodos)
class PeliculasProviders {
  String _apiKey = '53bf15eef45dbcadea7861489ffbc7b8';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  // Colocamos que tipo que informacion va a fluir adentro y el ".broadcast" para que sea escuchado por multiples oyentes
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  // Para agregar al Stream
  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  // Para escuchar el Stream
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final peliculas = Peliculas.fromJsonList(decodeData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    // Esta Uri nos permite hacer las peticiones y poner los queryparametros
    final url = Uri.https(_url, '/3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    // Solicitud hacia la url indicada
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];
    _cargando = true;
    _popularesPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    // Las peliculas que fluiran por el Stream
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    // Creamos la url y enviamos los queryparameters
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apiKey, 'language': _language});
    // Hacemos la peticion Get a la url
    final respuesta = await http.get(url);
    // Decodificamos la data
    final decodeData = json.decode(respuesta.body);

    final cast = new Cast.formJsonList(decodeData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String peliName) async {
    // Esta Uri nos permite hacer las peticiones y poner los queryparametros
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': peliName});

    return await _procesarRespuesta(url);
  }
}
