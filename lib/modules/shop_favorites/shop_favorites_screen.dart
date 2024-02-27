import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/models/favorites_model/get_favorites_model.dart';
import 'package:shop_application/shared/components/components.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/cubit/shop_cubit.dart';
import 'package:shop_application/shared/cubit/shop_states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! GetFavoritesLoadingState,
          builder: (context)=> ListView.separated(
            itemBuilder: (context, index) => favoritesBuilder(
                ShopCubit.get(context).getFavoritesModel!.data!.data![index],
                context),
            separatorBuilder: (context, index) => mySeparator(),
            itemCount:
                ShopCubit.get(context).getFavoritesModel!.data!.data!.length,
          ),
          fallback: (context)=> Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget favoritesBuilder(FavoriteProductData model, context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(
                      '${model.product!.image}',
                    ),
                    width: double.infinity,
                  ),

                  //if(model.product!.discount!=0)

                  Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'DISCOUNT ${model.product!.discount}% ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.product!.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, height: 1.3),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          '${model.product!.price.round()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: defaultColor,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        if (model.product!.discount != 0)
                          Text(
                            '${model.product!.old_price.round()}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              ShopCubit.get(context).changeFavorite( model.product!.id!);
                              print(model.id);
                            },
                            icon: Icon(
                              favCheck(context: context,model: model)
                                  ?
                              Icons.favorite_outlined
                                  :
                              Icons.favorite_outline,
                              size: 20,
                              color: Colors.blue,
                            ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  bool favCheck({required context, required FavoriteProductData model}) {
    late bool check;
    if (ShopCubit.get(context).favorites[model.product!.id] == null ||
        ShopCubit.get(context).favorites[model.product!.id] == false) {
      check = false;
    } else
      check = true;
    return check;
  }
}
