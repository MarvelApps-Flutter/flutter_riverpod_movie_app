class Genre {
  int id;
  String name;
  Genre({
    required this.id,
    required this.name,
  });
}

class Genres {
  
  List<Genre> genres = [
    Genre(id: 28, name: 'Action'),
    Genre(id: 12, name: 'Adventure'),
    Genre(id: 16, name: 'Animation'),
    Genre(id: 35, name: 'Comedy'),
    Genre(id: 80, name: 'Crime'),
    Genre(id: 99, name: 'Documentary'),
    Genre(id: 18, name: 'Drama'),
    Genre(id: 14, name: 'Fantasy'),
    Genre(id: 10751, name: 'Family'),
    Genre(id: 36, name: 'History'),
    Genre(id: 27, name: 'Horror'),
    Genre(id: 10402, name: 'Music'),
    Genre(id: 9648, name: 'Mystery'),
    Genre(id: 10749, name: 'Romance'),
    Genre(id: 878, name: 'Science Fiction'),
    Genre(id: 10770, name: 'TV Movie'),
    Genre(id: 53, name: 'Thriller'),
    Genre(id: 10752, name: 'War'),
    Genre(id: 37, name: 'Western'),
  ];
  String findGenre(id){
    switch (id) {
    case 28: return 'Action';
    case 12: return 'Adventure';
    case 16: return 'Animation';
    case 14: return 'Fantasy';
    case 35: return 'Comedy';
    case 80: return 'Crime';
    case 99: return 'Documentary';
    case 18: return 'Drama';
    case 10751: return 'Family';
    case 36: return 'History';
    case 27: return 'Horror';
    case 10402: return 'Music';
    case 9648: return 'Mystery';
    case 10749: return 'Romance';
    case 878: return 'Science Fiction';
    case 10770: return 'TV Movie';
    case 53: return 'Thriller';
    case 10752: return 'War';
    case 37: return 'Western';
    default: return 'NA';
  }}

  int findGenreID(String genre){
    switch (genre) {
    case 'Action': return 28;
    case 'Adventure': return 12;
    case 'Animation': return 16;
    case 'Fantasy': return 14;
    case 'Comedy': return 35;
    case 'Crime': return 80;
    case 'Documentary': return 99;
    case 'Drama': return 18;
    case 'Family': return 10751;
    case 'History': return 36;
    case 'Horror': return 27;
    case 'Music': return 10402;
    case 'Mystery': return 9648;
    case 'Romance': return 10749;
    case 'Science Fiction': return 878;
    case 'TV Movie': return 10770;
    case 'Thriller': return 53;
    case 'War': return 10752;
    case 'Western': return 37;
    default: return 28;
  }}
}
