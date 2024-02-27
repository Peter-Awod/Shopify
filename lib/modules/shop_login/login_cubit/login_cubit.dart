import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/models/login_model/login_model.dart';
import 'package:shop_application/modules/shop_login/login_cubit/login_states.dart';
import 'package:shop_application/shared/network/end_points.dart';
import 'package:shop_application/shared/network/remote/shop_dio_helper.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context)=> BlocProvider.of(context);
 late LoginModelClass loginModel;
 void userLogin({
    required String email,
    required String password,
}){
   emit(LoginLoadingState());
    ShopDioHelper.postData(
        url: LOGIN,
        data: {
          'email':email,
          'password':password,
        },
    ).then((value) {


      loginModel=LoginModelClass.fromJson(value.data);

      emit(LoginSuccessState(loginModel));
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });
  }

IconData suffix = Icons.visibility_outlined;
 bool isPassword=true;

 void changeIcon(){
   isPassword=!isPassword;

   suffix = isPassword? Icons.visibility_outlined : Icons.visibility_off_outlined;
   emit(LoginChangePassIconState());
 }

}