import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/models/categories_model/categories_model.dart';
import 'package:shop_application/models/home_model/home_model.dart';
import 'package:shop_application/shared/components/components.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/cubit/shop_cubit.dart';
import 'package:shop_application/shared/cubit/shop_states.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){
        if(state is ChangeFavoritesSuccessState){
          if(!state.model.status!) {
            showToast(msg: state.model.message!, status: MsgState.ERROR);
          }
          if(state.model.status!) {
            showToast(msg: state.model.message!, status: MsgState.SUCCESS);
          }

        }
      },


      builder: (context,state){
        ShopCubit cubitVar=ShopCubit.get(context);
        return ConditionalBuilder(
            condition: cubitVar.homeModel !=null && cubitVar.categoriesModel !=null,
            builder: (context)=>
                homeBuilder(model: cubitVar.homeModel!, categoriesModel: cubitVar.categoriesModel!,context: context),
            fallback: (context)=>
                Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }

  Widget homeBuilder({required HomeModel model,
    required CategoriesModel categoriesModel,required context})=>SingleChildScrollView(
    scrollDirection: Axis.vertical,
    physics: BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
            items: model.data!.banners.map((e){
              return Image(
                image: NetworkImage('${e.image}'),
                width: double.infinity,
                fit: BoxFit.cover,
              );
            }).toList(),
            options: CarouselOptions(

              height: 250,
              initialPage: 0,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 11115),
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
        ),
        SizedBox(height: 20,),



        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index)=> categoriesItemBuilder(categoriesModel.data!.data[index]),
                    separatorBuilder: (context,index)=> SizedBox(width: 10,),
                    itemCount: categoriesModel.data!.data.length,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'New products',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20,),
        Container(
          color: Colors.grey[300],
          child: GridView.count(
              crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 5,
            crossAxisSpacing: 3,
            childAspectRatio: 1/1.6,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(model.data!.products.length,
                    (index) => productBuilder(model.data!.products[index],context),
            ),
          ),
        ),

      ],
    ),
  );

  Widget categoriesItemBuilder(DataModel model)=>Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Image(
        image:NetworkImage('${model.image}'),
      fit: BoxFit.cover,
        width: 100,
        height: 100,
      ),
      Container(
        width: 100,
        color: Colors.black.withOpacity(.6),
        child: Text(
          '${model.nam e!.toUpperCase()}',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,

          ),
        ),
      ),
    ],
  );

  Widget productBuilder(ProductModel model,context)=>Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(
                '${model.image}',
              ),
              width: double.infinity,
              height: 200,
            ),
            if(model.discount!=0)
            Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'DISCOUNT ${model.discount}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
              ),
            )
          ],
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.3
                ),
              ),

              Row(
                children: [
                  Text(
                    '${model.price.round()}',
                    style: TextStyle(
                        fontSize: 12,
                      color: defaultColor,
                    ),
                  ),
                  SizedBox(width: 10,),
                  if(model.discount!=0)
                    Text(
                    '${model.old_price.round()}',

                      style: TextStyle(
                        fontSize: 12,
                      color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                    ),
                  ),

                  Spacer(),

                  IconButton(
                      onPressed: (){
                        ShopCubit.get(context).changeFavorite( model.id!);
                        print(model.id);
                      },
                      icon: Icon(
                        favCheck(context: context,model: model) ?   Icons.favorite_outlined : Icons.favorite_outline,
                        size: 20,
                        color: Colors.blue,
                      )
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

bool favCheck({required context,required ProductModel model}){
 late bool check;
 if(ShopCubit.get(context).favorites[model.id]==null||ShopCubit.get(context).favorites[model.id]==false)
   {
     check=false;
   }
 else
   check = true;
  return check;
}

