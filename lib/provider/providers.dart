import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_movieapp_module/model/genre_model.dart' as genres;
import 'package:riverpod_movieapp_module/model/movie_detail_model.dart';
import 'package:riverpod_movieapp_module/model/popular_movies_model.dart';
import 'package:riverpod_movieapp_module/provider/genre_change_notifier.dart';
import 'package:riverpod_movieapp_module/services/api_constant.dart';
import 'package:riverpod_movieapp_module/services/rest_api_services.dart';

final popularMoviesFutureProvider = FutureProvider.autoDispose<Movies>((ref) async {
  ref.maintainState = true;
  final _response = await RestApiServices().fetchApiData(path: APIconstant.popularMoviePath);
  final Movies popularMovies = Movies.fromJson(_response.data);
  return popularMovies;
});

final genreBasedMoviesFutureProvider = FutureProvider.family<Movies,int>((ref,genreID) async {
  final  _response = await RestApiServices().fetchApiData(id: genreID,path: APIconstant.discoverMoviePath);
  final Movies genreBasedMovies = Movies.fromJson(_response.data);
  return genreBasedMovies;
});

final getGenres = Provider.family<String,List<int>?>((ref,genresID) {
  List<String> genre = [];
  for (var i = 0; i < genresID!.length; i++) {
    genre.add( genres.Genres().findGenre(genresID[i]));
  }
  return genre.join(', ');
});

final movieDetailFutureProvider = FutureProvider.family<MovieDetail,int?>((ref,movieID) async {
  final  _response = await RestApiServices().fetchApiData(
    path: APIconstant.moviePath+movieID.toString(),
    append: 'credits,reviews'
    );
  final MovieDetail movieDetail = MovieDetail.fromJson(_response.data);
  return movieDetail;
});


final genreNotifierProvider =
    ChangeNotifierProvider<GenreChangeNotifier>((ref) => GenreChangeNotifier());


final searchMoviesFutureProvider = FutureProvider.autoDispose.family<Movies,String>((ref,query) async {
  ref.maintainState = true;
  final _response = await RestApiServices().fetchApiData(path: APIconstant.searchMoviePath,text: query==''?query='a':query);
  final Movies searchMovies = Movies.fromJson(_response.data);
  return searchMovies;
});

final queryProvider = StateProvider<String>((ref) => '');

