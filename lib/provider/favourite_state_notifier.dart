import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_movieapp_module/model/favourite_model.dart';

class FavouriteStateNotifier extends StateNotifier<FavouriteModel> {
  FavouriteStateNotifier() : super( FavouriteModel());

  void onTap(){
    final newState = state.copy(favouriteFlag: !state.favouriteFlag);
    state = newState;
  }
}