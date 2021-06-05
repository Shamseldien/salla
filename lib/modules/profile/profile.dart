import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salla/modules/profile/bloc/cubit.dart';
import 'package:salla/modules/profile/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/icon_broken.dart';
import 'package:salla/shared/style/styles.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>di<EditProfileCubit>(),
    child: BlocConsumer<EditProfileCubit, EditProfileStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var prCubit =  EditProfileCubit.get(context);
        return Directionality(
          textDirection: AppCubit.get(context).appDirection,
          child: Scaffold(
              appBar: AppBar(
                elevation: 1.0,
                title: Text('${appLang(context).profile}'),
                actions: [
                  TextButton(
                      onPressed: (){
                        prCubit.updateProfile(
                          context: context,
                          pass: AppCubit.get(context).pass.text,
                          name: AppCubit.get(context).name.text,
                          email: AppCubit.get(context).email.text,
                          phone:AppCubit.get(context).phone.text,
                        );
                      },
                    child: Text('${appLang(context).update}'),

                      )
                ],
              ),
              body: SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:  prCubit.image!=null
                                ?FileImage(prCubit.image)
                                  : NetworkImage(
                              '${AppCubit.get(context).userModel.data.image ?? 'https://www.pngarts.com/files/5/User-Avatar-Transparent.png'}')),
                                CircleAvatar(
                                  backgroundColor:
                                  Colors.grey[300].withOpacity(0.80),
                                  radius: 14,
                                  child: IconButton(
                                    icon: Icon(IconBroken.Camera, size: 13),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context)=>Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Card(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width:220,
                                                      child: InkWell(
                                                        onTap:(){
                                                          prCubit.getImage(source: ImageSource.camera);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                                          child: Row(
                                                            // mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(IconBroken.Camera),
                                                              SizedBox(width: 25,),
                                                              Text('${appLang(context).cam}')
                                                            ],
                                                          ),
                                                        ),
                                                        borderRadius:BorderRadius.circular(15.0) ,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Container(
                                                        width:200,
                                                        height: 0.7,
                                                        color: Colors.grey[200],
                                                      ),
                                                    ),
                                                    Container(
                                                      width:220,
                                                      child: InkWell(
                                                        onTap:(){
                                                          prCubit.getImage(source: ImageSource.gallery);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                                          child: Row(
                                                        // mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(IconBroken.Image),
                                                              SizedBox(width: 25,),
                                                              Text('${appLang(context).gallery}')
                                                            ],
                                                          ),
                                                        ),
                                                        borderRadius:BorderRadius.circular(15.0) ,
                                                      ),
                                                    ),
                                                    // ListTile(
                                                    //   title: Text('${appLang(context).cam}'),
                                                    //   leading: Icon(IconBroken.Camera),
                                                    //
                                                    // ),
                                                    // ListTile(
                                                    //   title: Text('${appLang(context).gallery}'),
                                                    //   leading: Icon(IconBroken.Image),
                                                    // ),
                                                  ],
                                                ),
                                                elevation: 2.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0)
                                                ),
                                              )
                                            ],
                                          )
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            '${appLang(context).name}',
                            style: black18(),
                          ),
                          TextFormField(
                            controller: AppCubit.get(context).name,
                            decoration: InputDecoration(
                              prefixIcon: Icon(IconBroken.User),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            '${appLang(context).email}',
                            style: black18(),
                          ),
                          TextFormField(
                            controller: AppCubit.get(context).email,
                            decoration: InputDecoration(
                              prefixIcon: Icon(IconBroken.Message),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            '${appLang(context).phone}',
                            style: black18(),
                          ),
                          TextFormField(
                            controller: AppCubit.get(context).phone,
                            decoration: InputDecoration(
                              prefixIcon: Icon(IconBroken.Call),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            '${appLang(context).password}',
                            style: black18(),
                          ),
                          TextFormField(
                            controller: AppCubit.get(context).pass,
                            decoration: InputDecoration(
                                prefixIcon: Icon(IconBroken.Lock),
                                hintText: '***********'
                            ),
                          ),

                        ],
                      ),
                    ),
                    if(state is EditProfileStateLoading)
                      Center(child: loadingIndicator())
                  ],
                ),
              )),
        );
      },
    ),
    );
  }
}
