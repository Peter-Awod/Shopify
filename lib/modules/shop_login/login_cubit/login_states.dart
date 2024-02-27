import 'package:shop_application/models/login_model/login_model.dart';

abstract class LoginStates {}


class LoginInitialState extends LoginStates{}

class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates{
  final LoginModelClass loginModel;

  LoginSuccessState(this.loginModel);
}
class LoginErrorState extends LoginStates{
  final String error;
  LoginErrorState(this.error);
}


class LoginChangePassIconState extends LoginStates{}
