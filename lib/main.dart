import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/bloc_observer.dart';
import 'package:shop_application/layouts/shop_layout/shop_layout.dart';
import 'package:shop_application/modules/onboarding/onboarding_screen.dart';
import 'package:shop_application/modules/shop_login/login.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/cubit/main_cubit.dart';
import 'package:shop_application/shared/cubit/main_states.dart';
import 'package:shop_application/shared/cubit/shop_cubit.dart';
import 'package:shop_application/shared/network/local/shop_cache_helper.dart';
import 'package:shop_application/shared/network/remote/shop_dio_helper.dart';
import 'package:shop_application/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  ShopDioHelper.init();
  await ShopCacheHelper.init();
  /////////////////////////////////
Widget startPoint;

  bool? isDark = ShopCacheHelper.getData(key: 'isDark');
  bool? onBoarding = ShopCacheHelper.getData(key: 'onBoarding');
  token = ShopCacheHelper.getData(key: 'token');

  if(onBoarding != null){
    if(token != null){
      startPoint=ShopLayout();
    }
    else {
      startPoint =ShopLoginScreen();
    }
  }
  else{
    startPoint=OnBoardingScreen();
  }
// //////////////////////////

  if(isDark==null){
    isDark =false;
  }

// //////////////////////////
  runApp(MyApp(
    isDark: isDark,
    startPoint: startPoint,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startPoint;
  const MyApp({required this.isDark, required this.startPoint});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return MainCubit()
              ..changeAppMode(
                fromShared: isDark,
              );
          },
        ),
        BlocProvider(
            create: (BuildContext context){
              return ShopCubit()..getHomeData()..getCategoriesData()..getFavoritesData()..getUserData();
            },
        ),
      ],
      child: BlocConsumer<MainCubit, AppMainStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: MainCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: ShopLayout(),
          );
        },
      ),
    );
  }
}
