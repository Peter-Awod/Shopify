import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/models/categories_model/categories_model.dart';
import 'package:shop_application/models/favorites_model/favorites_model.dart';
import 'package:shop_application/models/favorites_model/get_favorites_model.dart';
import 'package:shop_application/models/home_model/home_model.dart';
import 'package:shop_application/models/profile_model/profile_model.dart';
import 'package:shop_application/modules/shop_categories/shop_categories_screen.dart';
import 'package:shop_application/modules/shop_favorites/shop_favorites_screen.dart';
import 'package:shop_application/modules/shop_products/shop_products_screen.dart';
import 'package:shop_application/modules/shop_settings/shop_settings_screen.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/cubit/shop_states.dart';
import 'package:shop_application/shared/network/end_points.dart';
import 'package:shop_application/shared/network/remote/shop_dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> navigationScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeNavBarIndex(index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }
  ////////////////

  HomeModel? homeModel;
  late Map<int, bool> favorites = {};


  void getHomeData() {
    emit(GetHomeLoadingState());

    ShopDioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      print(token);
      homeModel!.data!.products.forEach((element) {
        favorites.addAll({element.id!: element.in_favorites!});
      });
      print(favorites);
      emit(GetHomeSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetHomeErrorState());
    });
  }

  //////

  CategoriesModel? categoriesModel;
  void getCategoriesData() {
    ShopDioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(GetCategoriesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetCategoriesErrorState());
    });
  }

  ///////////

  FavoritesModel? favoritesModel;
  void changeFavorite(int productID) {

    favorites[productID] = !favorites[productID]!;
    emit(GetFavoritesState());

    ShopDioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productID,
      },
      token: token,
    ).then((value) {
      favoritesModel=FavoritesModel.fromJson(value.data);

      if(!favoritesModel!.status!){
        favorites[productID] = !favorites[productID]!;

      }
      else{getFavoritesData();}
      print(favoritesModel!.status);
      print(favoritesModel!.message);

      emit(ChangeFavoritesSuccessState(favoritesModel!));
    }).catchError((error){
      favorites[productID] = !favorites[productID]!;

      print(error.toString());

      emit(ChangeFavoritesErrorState());
    });
  }

  GetFavoritesModel? getFavoritesModel;
  void getFavoritesData() {
    emit(GetFavoritesLoadingState());

    ShopDioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      getFavoritesModel = GetFavoritesModel.fromJson(value.data);
      print(getFavoritesModel!.status);
      emit(GetFavoritesSuccessState(getFavoritesModel!));
    }).catchError((error) {
      print(error.toString());
      emit(GetCategoriesErrorState());
    });
  }


  ProfileModelClass? profileModelClass;
  void getUserData() {
    emit(GetUserDataLoadingState());

    ShopDioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      profileModelClass = ProfileModelClass.fromJson(value.data);
      print(profileModelClass!.data!.name);
      emit(GetUserDataSuccessState(profileModelClass!));
    }).catchError((error) {
      print(error.toString());
      emit(GetUserDataErrorState());
    });
  }



  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(UpdateUserDataLoadingState());

    ShopDioHelper.putData(
      data: {
        'name' : name ,
        'email': email,
        'phone': phone,
      },
      url: Update_PROFILE,
      token: token,
    ).then((value) {
      profileModelClass = ProfileModelClass.fromJson(value.data);
      print(profileModelClass!.data!.name);
      emit(UpdateUserDataSuccessState(profileModelClass!));
    }).catchError((error) {
      print(error.toString());
      emit(UpdateUserDataErrorState());
    });
  }




}
