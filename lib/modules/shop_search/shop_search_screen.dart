import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/models/search_model/search_model.dart';
import 'package:shop_application/shared/components/components.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/cubit/main_cubit.dart';
import 'package:shop_application/shared/cubit/main_states.dart';
import 'package:shop_application/shared/cubit/shop_cubit.dart';

class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, AppMainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  defaultTextFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      label: 'Search',
                      prefix: Icons.search_outlined,
                      validate: (val){
                        if(val!.isEmpty)
                          {
                            return 'Must to enter what you looking for';
                          }
                        return null;
                      },
                    onSubmit: (String value)
                    {
                        MainCubit.get(context).getSearch(value: value);
                    }

                  ),
                  SizedBox(height: 20,),
                  if(state is AppGetSearchLoadingState)
                    LinearProgressIndicator(),
                  SizedBox(height: 20,),
                 if(state is AppGetSearchSuccessState)
                 Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => searchItemBuilder(
                        MainCubit.get(context).searchModel!.data!.data![index],
                        context),
                    separatorBuilder: (context, index) => mySeparator(),
                    itemCount:
                    MainCubit.get(context).searchModel!.data!.data!.length,
                  ),
                ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  Widget searchItemBuilder(Product model, context) => Padding(
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
                  '${model.image}',
                ),
                width: double.infinity,
              ),

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
                  '${model.name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, height: 1.3),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      '${model.price.round()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: defaultColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),

                    Spacer(),
                    IconButton(
                      onPressed: () {
                        ShopCubit.get(context).changeFavorite( model.id!);
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

  bool favCheck({required context, required Product model}) {
    late bool check;
    if (ShopCubit.get(context).favorites[model.id] == null ||
        ShopCubit.get(context).favorites[model.id] == false) {
      check = false;
    } else
      check = true;
    return check;
  }

}
