class ProfileModelClass {
bool? status;
String? message;
UserData? data;

ProfileModelClass.fromJson(Map<String,dynamic> json){
  status=json['status'];
  message=json['message'];
  data=json['data'] != null ? UserData.fromJson(json['data']): null;
}
}


class UserData{
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? points;
  int? credits;
  String? token;


  // named constructor
UserData.fromJson(Map<String,dynamic>json){
  id=json['id'];
  name=json['name'];
  email=json['email'];
  phone=json['phone'];
  image=json['image'];
  points=json['points'];
  credits=json['credits'];
  token=json['token'];
}
}