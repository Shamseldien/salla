import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/new_address/bloc/cubit.dart';
import 'package:salla/modules/new_address/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';
class AddNewAddress extends StatelessWidget {
  var nameCon = TextEditingController();
  var cityCon = TextEditingController();
  var regionCon = TextEditingController();
  var detailsCon = TextEditingController();
  var latCon = TextEditingController();
  var longCon = TextEditingController();
  var notesCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>di<NewAddressCubit>(),
    child: BlocConsumer<NewAddressCubit,NewAddressStates>(
       listener: (context,state){},
       builder: (context,state){
         return Directionality(
           textDirection: AppCubit.get(context).appDirection,
           child: Scaffold(
             appBar: AppBar(
               title: Text(appLang(context).newAddress),
               elevation: 1.0,
             ),
             body: Padding(
               padding: const EdgeInsets.all(20.0),
               child: Column(
                 children: [
                   newAddressFormField(
                     labelText: 'Name',
                     errorText: 'name of address must not be empty',
                     controller: nameCon
                   ),
                   newAddressFormField(
                       labelText: 'City',
                       errorText: 'city must not be empty',
                       controller: cityCon
                   ),
                   newAddressFormField(
                       labelText: 'Region',
                       errorText: 'region must not be empty',
                       controller: regionCon
                   ),
                   newAddressFormField(
                       labelText: 'Details',
                       errorText: 'details must not be empty',
                       controller: detailsCon
                   ),
                   newAddressFormField(
                       labelText: 'Notes',
                       errorText: 'notes must not be empty',
                       controller: notesCon
                   ),

                 ],
               ),
             ),
           ),
         );
       },

    ),
    );
  }

  Widget newAddressFormField({errorText,labelText,controller,})=> Padding(
    padding: const EdgeInsets.only(
      bottom: 15
    ),
    child: TextFormField(
      validator: (value) {
        if (value.isEmpty) return errorText;
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.all(9),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: grey14(),
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
                color: Colors.grey
            )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
                color: Colors.blue
            )
        ),
      ),
    ),
  );
}
