class FavouriteModel {
  final bool favouriteFlag;
  FavouriteModel({
     this.favouriteFlag = false,
  });

  
  FavouriteModel copy({
    bool ?favouriteFlag,
  }) =>
      FavouriteModel(
        favouriteFlag: favouriteFlag ?? this.favouriteFlag,
      );
}
