import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:salla/modules/search/bloc/cubit.dart';
import 'package:salla/modules/search/bloc/states.dart';
import 'package:salla/modules/single_category/single_category.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/icon_broken.dart';
import 'package:salla/shared/style/styles.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var searchCon = TextEditingController();
    return BlocConsumer<SearchCubit, SearchStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SearchCubit.get(context);
        return Directionality(
          textDirection: AppCubit.get(context).appDirection,
          child: Scaffold(
            appBar: AppBar(

              elevation: 1.0,
              title: Text('Search'),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  TextFormField(
                    controller: searchCon,
                    // onChanged: (text){
                    //   if(text.length>=2) {
                    //     cubit.searchProduct(text: searchCon.text);
                    //   }
                    // },
                    onFieldSubmitted: (text){
                      if(text.length>0)
                        cubit.searchProduct(text: searchCon.text);
                    },
                    decoration: InputDecoration(
                        hintText: 'Type to search',
                     ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (state is  SearchStateLoading)
                    LinearProgressIndicator(
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(btnColor),
                    ),
                  // if (cubit.recent.isNotEmpty )
                  //   ListView.builder(
                  //     shrinkWrap: true,
                  //     itemBuilder: (context, index) => Row(
                  //       children: [
                  //         Icon(IconBroken.Time_Circle),
                  //         SizedBox(
                  //           width: 20,
                  //         ),
                  //         Text('${cubit.recent[index]}')
                  //       ],
                  //     ),
                  //     itemCount: cubit.recent.length,
                  //   ),
                  ConditionalBuilder(
                    condition: cubit.searchModel!=null ,
                    builder: (context) => Expanded(
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        itemCount: cubit.searchModel.data.data.length,
                        itemBuilder: (BuildContext context, int index) => index
                            .isEven
                        ?
                        searchItem(
                            context: context,
                            index: index,
                            searchData: cubit.searchModel.data.data[index])
                        :
                        searchItemTwo(
                            context: context,
                            index: index,
                            searchData: cubit.searchModel.data.data[index]),
                        staggeredTileBuilder: (int index) =>
                        StaggeredTile.count(2, index.isEven ? 2.5 : 1.2),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      ),
                    ),
                    fallback: (context) => Container(),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
