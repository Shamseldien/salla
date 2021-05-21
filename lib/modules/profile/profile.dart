import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salla/modules/profile/bloc/cubit.dart';
import 'package:salla/modules/profile/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/icon_broken.dart';
import 'package:salla/shared/style/styles.dart';

class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppCubit.get(context).appDirection,
      child: BlocProvider(create: (context)=>di<EditProfileCubit>(),
      child: BlocConsumer<EditProfileCubit, EditProfileStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var prCubit =  EditProfileCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                elevation: 1.0,
                title: Text('${appLang(context).profile}'),
                actions: [
                  TextButton(
                      onPressed: (){
                        // EditProfileCubit.get(context)
                        //     .updateProfile(
                        //   phone: AppCubit.get(context).phone,
                        //   email: AppCubit.get(context).email,
                        //   name: AppCubit.get(context).name,
                        //   pass: AppCubit.get(context).pass
                        //
                        // );

                      },
                    child: Text('${appLang(context).update}'),

                      )
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
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
                          'https://www.pngarts.com/files/5/User-Avatar-Transparent.png')),
                            CircleAvatar(
                              backgroundColor:
                              Colors.grey[300].withOpacity(0.80),
                              radius: 14,
                              child: IconButton(
                                icon: Icon(IconBroken.Camera, size: 13),
                                onPressed: () {

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
                        controller: AppCubit.get(context).name,
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
              ));
        },
      ),
      ),
    );
  }
}
