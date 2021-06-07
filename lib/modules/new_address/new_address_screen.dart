import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/new_address/bloc/cubit.dart';
import 'package:salla/modules/new_address/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/icon_broken.dart';
import 'package:salla/shared/style/styles.dart';

class AddNewAddress extends StatelessWidget {
  var nameCon = TextEditingController();
  var cityCon = TextEditingController();
  var regionCon = TextEditingController();
  var detailsCon = TextEditingController();
  var notesCon = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var name;
  var region;
  var city;
  var details;
  var note;
  var id;
  var lat;
  var long;
  bool update;
  AddNewAddress({this.name,this.city,this.region,this.note,this.details,this.update,this.id,this.lat,this.long});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>di<NewAddressCubit>(),
    child: BlocConsumer<NewAddressCubit,NewAddressStates>(
       listener: (context,state){},
       builder: (context,state){
         nameCon.text=name;
         regionCon.text=region;
         cityCon.text=city;
         notesCon.text=note;
         detailsCon.text=details;
         var cubit = NewAddressCubit.get(context);
         return Directionality(
           textDirection: AppCubit.get(context).appDirection,
           child: Scaffold(
             appBar: AppBar(
               title: Text(!this.update ? appLang(context).newAddress : 'Edit address'),
               elevation: 1.0,
             ),
             body:  Stack(
               children: [
                 Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: CustomScrollView(
                     slivers: [
                       SliverFillRemaining(
                           hasScrollBody: false,
                           child:Column(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Form(
                                 key: formKey,
                                 child: Column(
                                   children: [
                                     newAddressFormField(
                                         labelText: 'Country',
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
                                         errorText: 'please add some note for your address like Home, work ,etc...',
                                         controller: notesCon
                                     ),
                                     SizedBox(height: 20,),
                                   ],
                                 ),
                               ),
                               if(!this.update)
                                 Column(
                                 children: [
                                   Container(
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(50.0),
                                         border: Border.all(
                                             color: btnColor
                                         )
                                     ),
                                     child: IconButton(
                                         icon: Icon(IconBroken.Location,size: 30,),
                                         onPressed: (){
                                           cubit.getGeoLocation().then((value){
                                             nameCon.text=cubit.myAddress.countryName;
                                             cityCon.text =cubit.myAddress.adminArea;
                                             regionCon.text=cubit.myAddress.subAdminArea;
                                             detailsCon.text=cubit.myAddress.addressLine;
                                           });
                                         }),
                                   ),
                                   SizedBox(height: 10,),
                                   Text('Select Current Location ?'),
                                 ],
                               ),

                                 Column(
                                 children: [
                                     defaultBtn(
                                       function: () async{
                                         if(!this.update) {
                                            if (formKey.currentState.validate()) {
                                              if (nameCon.text.isNotEmpty &&
                                                  cityCon.text.isNotEmpty &&
                                                  regionCon.text.isNotEmpty &&
                                                  detailsCon.text.isNotEmpty &&
                                                  notesCon.text.isNotEmpty) {
                                                await cubit
                                                    .addNewAddress(
                                                  name: nameCon.text,
                                                  city: cityCon.text,
                                                  region: regionCon.text,
                                                  details: detailsCon.text,
                                                  notes: notesCon.text,

                                                )
                                                    .then((value) async {
                                                  await AppCubit.get(context)
                                                      .getAddress()
                                                      .then((value) {
                                                    Navigator.pop(context);
                                                  });
                                                });
                                              } else {}
                                            }
                                          }else{
                                           if (formKey.currentState.validate()) {
                                             if (nameCon.text.isNotEmpty &&
                                                 cityCon.text.isNotEmpty &&
                                                 regionCon.text.isNotEmpty &&
                                                 detailsCon.text.isNotEmpty &&
                                                 notesCon.text.isNotEmpty) {
                                               cubit.updateAddress(
                                                 addressId: this.id,
                                                 name: nameCon.text,
                                                 city: cityCon.text,
                                                 region: regionCon.text,
                                                 details: detailsCon.text,
                                                 notes: notesCon.text,
                                                 longitude: this.long,
                                                 latitude: this.lat
                                               ).then((value) async {
                                                 await AppCubit.get(context)
                                                     .getAddress()
                                                     .then((value) {
                                                   Navigator.pop(context);
                                                 });
                                               });
                                             } else {}
                                           }
                                         }
                                        },
                                       text: !this.update ? appLang(context).done : appLang(context).update)
                                 ],
                               )
                             ],
                           )
                       )
                      ],
                   ),
                 ),
                 if(state is NewAddressStateLoading || state is GeoLocationStateLoading)
                   Center(child: loadingIndicator())
               ],
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
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
                color: Colors.grey
            )
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
                color: Colors.red
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
