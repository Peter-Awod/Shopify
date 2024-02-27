import 'package:shop_application/models/favorites_model/favorites_model.dart';
import 'package:shop_application/models/favorites_model/get_favorites_model.dart';
import 'package:shop_application/models/profile_model/profile_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates{}

class ChangeBottomNavBarState extends ShopStates{}


class GetHomeLoadingState extends ShopStates{}
class GetHomeSuccessState extends ShopStates{}
class GetHomeErrorState extends ShopStates{}

class GetCategoriesSuccessState extends ShopStates{}
class GetCategoriesErrorState extends ShopStates{}

class GetFavoritesState extends ShopStates{}
class ChangeFavoritesErrorState extends ShopStates{}
class ChangeFavoritesSuccessState extends ShopStates{
  final FavoritesModel model;
  ChangeFavoritesSuccessState(this.model);
}

class GetFavoritesLoadingState extends ShopStates{}
class GetFavoritesErrorState extends ShopStates{}
class GetFavoritesSuccessState extends ShopStates{
  final GetFavoritesModel model;
  GetFavoritesSuccessState(this.model);
}

class GetUserDataLoadingState extends ShopStates{}
class GetUserDataErrorState extends ShopStates{}
class GetUserDataSuccessState extends ShopStates{
  final ProfileModelClass model;
  GetUserDataSuccessState(this.model);
}



class UpdateUserDataLoadingState extends ShopStates{}
class UpdateUserDataErrorState extends ShopStates{}
class UpdateUserDataSuccessState extends ShopStates{
  final ProfileModelClass model;
  UpdateUserDataSuccessState(this.model);
}






