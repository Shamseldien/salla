import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:salla/modules/new_address/new_address_screen.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/icon_broken.dart';
import 'package:salla/shared/style/styles.dart';
class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = AppCubit.get(context);
        var addressModel = AppCubit.get(context).addressModel;

        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text('${appLang(context).addresses}'),
            actions: [
              IconButton(
                icon: Icon(Icons.add_location_alt_outlined),
                onPressed: (){
                  navigateTo(context: context, widget: AddNewAddress());
                },
              )
            ],
          ),
          body: ConditionalBuilder(
            condition: addressModel!=null && addressModel.data.data.length>0,
            builder: (context)=>Column(
              children: [
                if(state is AddressLoadingState)
                  LinearProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(btnColor),
                  ),
                Expanded(
                  child: ListView.separated(
                    itemCount: addressModel.data.data.length,
                    itemBuilder: (context,index){
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.20,
                        child: address(
                            context: context,
                            address: addressModel.data.data[index]),
                        secondaryActions: [
                          IconSlideAction(
                            caption: 'Edit',
                            color: Colors.green,
                            icon: IconBroken.Edit,
                            onTap: (){
                              navigateTo(context: context, widget: AddNewAddress(
                                name: addressModel.data.data[index].name,
                                city : addressModel.data.data[index].city,
                                details : addressModel.data.data[index].details,
                                region: addressModel.data.data[index].region,
                                note: addressModel.data.data[index].notes,
                                id: addressModel.data.data[index].id,
                                lat:addressModel.data.data[index].latitude ,
                                long: addressModel.data.data[index].longitude,
                                update: 'update',
                              ));
                            },
                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: btnColor,
                            icon: IconBroken.Delete,
                            onTap: (){
                              AppCubit.get(context).deleteAdd(id: addressModel.data.data[index].id);
                            },
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context,index)=>Divider(height: 1,),),
                ),
              ],
            ),
            fallback: (context)=>Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(IconBroken.Location,size: 30,),
                ),
                TextButton(
                  child: Text('${appLang(context).newAddress}'),
                  onPressed: (){
                    navigateTo(context: context, widget: AddNewAddress());
                  },
                ),
              ],
            ),),
          ),
        );
      },
    );
  }

}
