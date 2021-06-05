import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context){
   return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var model = AppCubit.get(context).categoriesModel;
          return Directionality(
            textDirection: AppCubit.get(context).appDirection,
            child: Scaffold(
              body: ConditionalBuilder(
                  condition: model != null ,
                  builder: (context){
                    return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView.separated(
                      itemBuilder: (context,index)=>categoryWidget(
                          model: model.data.data[index],
                          context: context ),
                      separatorBuilder: (ctx,index)=>Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey[200],
                      ),
                      itemCount: model.data.data.length,
                    ),
                  );
                  },
              fallback: (context)=>Center(child: loadingIndicator(),),
              ),
            ),
          );
        },
    );
  }



}
