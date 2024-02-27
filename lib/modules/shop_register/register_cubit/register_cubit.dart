import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/models/login_model/login_model.dart';
import 'package:shop_application/modules/shop_register/register_cubit/register_states.dart';
import 'package:shop_application/shared/network/end_points.dart';
import 'package:shop_application/shared/network/remote/shop_dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates>{
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context)=> BlocProvider.of(context);
 late LoginModelClass loginModel;
 void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
}){

   emit(RegisterLoadingState());

    ShopDioHelper.postData(
        url: REGISTER,
        data: {
          'name':name,
          'email':email,
          'password':password,
          'phone':phone,
        },
    ).then((value) {


      loginModel=LoginModelClass.fromJson(value.data);

      emit(RegisterSuccessState(loginModel));
    }).catchError((error){
      emit(RegisterErrorState(error.toString()));
    });
  }

IconData suffix = Icons.visibility_outlined;
 bool isPassword=true;

 void changeIcon(){
   isPassword=!isPassword;

   suffix = isPassword? Icons.visibility_outlined : Icons.visibility_off_outlined;
   emit(RegisterChangePassIconState());
 }

}