import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/models/categories_model/categories_model.dart';
import 'package:shop_application/shared/components/components.dart';
import 'package:shop_application/shared/cubit/shop_cubit.dart';
import 'package:shop_application/shared/cubit/shop_states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){
        return ListView.separated(
            itemBuilder: (context,index)=> categoriesBuilder(ShopCubit.get(context).categoriesModel!.data!.data[index]),
            separatorBuilder: (context,index)=>mySeparator(),
            itemCount: ShopCubit.get(context).categoriesModel!.data!.data.length,
        );
      },
    );
  }

  Widget categoriesBuilder(DataModel model)=>Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Image(
          image: NetworkImage('${model.image}'),
          width: 100,
          height: 100,
        ),
        SizedBox(width: 20,),
        Text('${model.name}'),

        Spacer(),
        Icon(Icons.arrow_forward_ios_outlined),
      ],
    ),
  );
}
