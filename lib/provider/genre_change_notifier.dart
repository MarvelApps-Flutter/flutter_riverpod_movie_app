import 'package:flutter/material.dart';
import 'package:riverpod_movieapp_module/model/genre_model.dart';

class GenreChangeNotifier extends ChangeNotifier{
    List<bool> genreBoolean =[];
    void setSelectedGenre(int index){
      genreBoolean.clear();
      for (var i = 0; i < Genres().genres.length; i++) {
        genreBoolean.add(false);
      }
      genreBoolean[index]=true;
      notifyListeners();
    }

  }
