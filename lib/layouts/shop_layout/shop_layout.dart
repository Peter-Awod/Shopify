import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/modules/shop_login/login.dart';
import 'package:shop_application/modules/shop_search/shop_search_screen.dart';
import 'package:shop_application/shared/components/components.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/cubit/main_cubit.dart';
import 'package:shop_application/shared/cubit/shop_cubit.dart';
import 'package:shop_application/shared/cubit/shop_states.dart';
import 'package:shop_application/shared/network/local/shop_cache_helper.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){

        ShopCubit cubitVar=ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('3ALMASHY'),
            actions: [
              IconButton(
                onPressed: () {
                  MainCubit.get(context).changeAppMode();
                },
                icon: const Icon(
                  Icons.brightness_4_outlined,
                ),
              ),
              IconButton(
                onPressed: (){
                  pushNavigateTo(context, SearchScreen());
                },
                icon: Icon(
                  Icons.search_outlined,size:30 ,
                ),
              ),
            ],
          ),

          body: cubitVar.navigationScreens[cubitVar.currentIndex],

          bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label:'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.apps_outlined,
                ),
                label:'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_outline_outlined,
                ),
                label:'Favorite',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings_outlined,
                ),
                label:'Settings',
              ),
            ],
            currentIndex: cubitVar.currentIndex,
            onTap: (index){
              cubitVar.changeNavBarIndex(index);
            },
          ),

        );
      },
    );
  }
}
