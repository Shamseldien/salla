import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:salla/models/board_model/board_model.dart';
import 'package:salla/modules/authentication/bloc/cubit.dart';
import 'package:salla/modules/authentication/bloc/states.dart';
import 'package:salla/modules/boarding/boarding.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/language/language_model.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';

class LanguageModel {
  final String language;
  final String code;

  LanguageModel({
    this.language,
    this.code,
  });
}

List<LanguageModel> languageList = [
  LanguageModel(code: 'ar', language: 'العربيه'),
  LanguageModel(code: 'en', language: 'English'),
];

Widget languageItem({LanguageModel model, index, context}) => InkWell(
      onTap: () {
        AppCubit.get(context).changeSelectedLanguage(index);
      },
      borderRadius: BorderRadius.circular(20.0),
      splashColor: Colors.green,
      child: Container(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Text(model.language),
              Spacer(),
              if (AppCubit.get(context).selectedLanguage[index])
                Icon(Icons.language),
            ],
          ),
        ),
      ),
    );

enum toastMessagesColors {
  SUCCESS,
  ERROR,
  WARNING,
}

Color setToastColor(toastMessagesColors color) {
  Color c;
  switch (color) {
    case toastMessagesColors.ERROR:
      c = Colors.red;
      break;
    case toastMessagesColors.SUCCESS:
      c = Colors.green;
      break;
    case toastMessagesColors.WARNING:
      c = Colors.amber;
      break;
  }
  return c;
}

void showToast({
  @required String text,
  @required toastMessagesColors color,
}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: setToastColor(color),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future navigateTo({
  @required context,
  @required widget,
}) async {
  return Navigator.push(
      context,
      PageTransition(
          child: widget,
          type: PageTransitionType.slideZoomRight,
          duration: Duration(milliseconds: 900)));
}

Future navigateToAndFinish({
  @required context,
  @required widget,
}) async {
  return Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
          child: widget,
          type: PageTransitionType.slideZoomLeft,
          duration: Duration(milliseconds: 900)),
      (route) => false);
}

Widget boardingItem({@required BoardModel model, index}) => Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(image: AssetImage('${model.image}')),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 26),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: model.title,
              style: TextStyle(
                  color: defaultColor.withOpacity(0.50), fontSize: 25),
              children: <TextSpan>[
                TextSpan(
                    text: '\n${model.subTitle1}',
                    style: TextStyle(
                        color: index != 2 || appLanguage == 'ar'
                            ? defaultColor.withOpacity(0.50)
                            : defaultColor,
                        fontWeight:
                            index == 2 ? FontWeight.bold : FontWeight.normal)),
                TextSpan(
                    text: '  ${model.subTitle2}',
                    style: TextStyle(
                        color: index != 2 || appLanguage == 'ar'
                            ? defaultColor
                            : defaultColor.withOpacity(0.50),
                        fontWeight: index != 2 || appLanguage == 'ar'
                            ? FontWeight.bold
                            : FontWeight.normal)),
              ],
            ),
          ),
        ),
      ],
    );

Widget defaultTextFormField({
  @required hint,
  @required error,
  @required controller,
  @required context,
  bool isPass =false,
  showPassFunction,
  IconData icon
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        cursorHeight: 25,
        cursorColor: btnColor,
        validator: (value) {
          if (value.isEmpty) return error;
          return null;
        },
        controller: controller,
        obscureText:isPass,
        decoration: InputDecoration(
          suffixIcon: icon!=null ? Directionality(
              textDirection: AppCubit.get(context).appDirection,
              child: InkWell(
                  onTap: showPassFunction,
                  child: Icon(icon))) : null,
          hintText: hint,
          hintStyle: grey14(),
          isDense: true,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: btnColor.withOpacity(0.50))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: btnColor.withOpacity(0.50))),
        ),
      ),
    );

Widget socialButton({@required function, @required text, @required icon}) =>
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Container(
        width: double.infinity,
        child: MaterialButton(
          onPressed: () {},
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: Colors.grey[200])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Image(
                  image: AssetImage('$icon'),
                  height: 45,
                  width: 50,
                ),
              ),
              SizedBox(
                width: 30.0,
              ),
              Text(text)
            ],
          ),
        ),
      ),
    );

Widget logo({TextStyle textStyle, iconColor = Colors.white}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_bag_outlined,
          color: iconColor,
          size: 50,
        ),
        Text(
          'Salla Store',
          style: textStyle ?? white22(),
        ),
      ],
    ),
  );
}

Widget defaultBtn({
  @required text,
  @required function,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: btnColor,
        ),
        width: double.infinity,
        height: 40.0,
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          onPressed: function,
          child: Text(
            text,
            style: white14(),
          ),
        ),
      ),
    );


Widget loadingIndicator({color})=>Center(
  child: LoadingBouncingGrid.square(
    borderColor: Colors.white,
    borderSize: 1.0,
    size: 80.0,
    backgroundColor: color ?? btnColor,
    duration: Duration(milliseconds: 1500),
  ),
);

class ImageDialog extends StatefulWidget {
  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>AuthCubit(),
    child:  BlocConsumer<AuthCubit,AuthStates>(
        builder: (context, state) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            )),
        insetPadding: EdgeInsets.symmetric(
          horizontal: 80,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Camera'),
              leading: Icon(Icons.camera_alt_outlined),
              onTap: () {
                AuthCubit.get(context).getImage(source: ImageSource.camera).then((value){
                  AuthCubit.get(context).base64Image = value;
                  Navigator.pop(context);
                });
                setState(() {});
              },
            ),
            ListTile(
              title: Text('Gallery'),
              leading: Icon(Icons.image_outlined),
              onTap: () {
                AuthCubit.get(context).getImage(source: ImageSource.gallery).then((value){
                  Navigator.pop(context);
                });
                setState(() {});
              },
            ),
          ],
        ),

      );
    },
    listener: (context, state) {}),

    );
  }
}



