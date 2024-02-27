
import 'package:flutter/material.dart';
import 'package:shop_application/modules/shop_login/login.dart';
import 'package:shop_application/shared/components/components.dart';
import 'package:shop_application/shared/network/local/shop_cache_helper.dart';

const defaultColor = Colors.blue;


// logout button
void signOut({required BuildContext context})
{

      ShopCacheHelper.removeToken(key: 'token').then((value){
        if(value!){
          pushAndRemoveNavigateTo(context, ShopLoginScreen());
        }
      });
}


String? token='';