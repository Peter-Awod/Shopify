import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/models/search_model/search_model.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/cubit/main_states.dart';
import 'package:shop_application/shared/network/end_points.dart';
import 'package:shop_application/shared/network/local/shop_cache_helper.dart';
import 'package:shop_application/shared/network/remote/shop_dio_helper.dart';

class MainCubit extends Cubit<AppMainStates> {
  MainCubit() : super(AppInitialState());
  static MainCubit get(context) => BlocProvider.of(context);

bool isDark=false;

void changeAppMode({bool? fromShared})
{
  if(fromShared!=null)
    {
      isDark=fromShared;
      emit(ChangeAppModeState());
    }
  else {
    isDark =!isDark;
    ShopCacheHelper.saveData(key: 'isDark', value: isDark)
        .then((value) {
      emit(ChangeAppModeState());

    });
  }

}


  SearchModel? searchModel;
  void getSearch({required String value}) {
    emit(AppGetSearchLoadingState());

    ShopDioHelper.postData(
        data: {
          'text':value,
        },
        url: SEARCH,
      token: token,

    ).then((value) {
      searchModel=SearchModel.fromJson(value.data);
      emit(AppGetSearchSuccessState());
    }).catchError((error) {

        print(error.toString());
      emit(AppGetSearchErrorState(error.toString()));
    });
  }


}