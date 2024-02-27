import 'package:shop_application/models/login_model/login_model.dart';

abstract class RegisterStates {}


class RegisterInitialState extends RegisterStates{}

class RegisterLoadingState extends RegisterStates{}
class RegisterSuccessState extends RegisterStates{
  final LoginModelClass loginModel;

  RegisterSuccessState(this.loginModel);
}
class RegisterErrorState extends RegisterStates{
  final String error;
  RegisterErrorState(this.error);
}


class RegisterChangePassIconState extends RegisterStates{}
