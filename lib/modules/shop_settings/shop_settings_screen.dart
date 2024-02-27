import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/shared/components/components.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/cubit/shop_cubit.dart';
import 'package:shop_application/shared/cubit/shop_states.dart';

class SettingsScreen extends StatelessWidget {

  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var phoneController=TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){
        var model= ShopCubit.get(context).profileModelClass;

        nameController.text=model!.data!.name!;
        emailController.text=model!.data!.email!;
        phoneController.text=model!.data!.phone!;

        return ConditionalBuilder(
            condition: ShopCubit.get(context).profileModelClass!=null,
            fallback:(context) => Center(child: CircularProgressIndicator()),
            builder: (context) =>Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if(state is UpdateUserDataLoadingState)
                    LinearProgressIndicator(),

                    SizedBox(height: 20,),
                    defaultTextFormField(
                      controller: nameController,
                      type: TextInputType.text,
                      label: 'Name',
                      prefix: Icons.person_outline,
                      validate: (val){
                        if(val!.isEmpty){
                          return 'Name must not be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),

                    defaultTextFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      label: 'Email address',
                      prefix: Icons.email_outlined,
                      validate: (val){
                        if(val!.isEmpty){
                          return 'Email address must not be empty';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10,),

                    defaultTextFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      label: 'Phone',
                      prefix: Icons.email_outlined,
                      validate: (val){
                        if(val!.isEmpty){
                          return 'Phone must not be empty';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20,),

                    defaultTextButton(function: (){
                      if(formKey.currentState!.validate())
                      {
                        ShopCubit.get(context).updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                        );
                      }
                    }, text: 'Update'),

                    SizedBox(height: 20,),

                    defaultMaterialButton(function: (){
                      signOut(context: context);
                    }, text: 'Logout'),


                  ],
                ),
              ),
            ) ,
        );
      },
    );
  }
}
