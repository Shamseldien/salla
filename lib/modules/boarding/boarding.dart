import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:salla/models/board/board_model.dart';
import 'package:salla/modules/authentication/login/login.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingScreen extends StatefulWidget {
  @override
  _BoardingScreenState createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  List<BoardModel> list;
  bool isLast = false;
  final pageViewCon = PageController();

  @override
  void initState() {
    super.initState();
    list = [
      BoardModel(
        title: appLang(context).title,
        image: 'assets/images/firstimage.png',
        subTitle1: appLang(context).subtitle1,
        subTitle2: appLang(context).subtitle2,
      ),
      BoardModel(
        title: appLang(context).title2,
        image: 'assets/images/secondimage.png',
        subTitle1: appLang(context).subtitle12,
        subTitle2: appLang(context).subtitle22,
      ),
      BoardModel(
        title: appLang(context).title3,
        image: 'assets/images/thirdimage.png',
        subTitle1: appLang(context).subtitle13,
        subTitle2: appLang(context).subtitle23,
      ),
      BoardModel(
        title: appLang(context).title4,
        image: 'assets/images/fourthimage.png',
        subTitle1: appLang(context).subtitle14,
        subTitle2: appLang(context).subtitle24,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppCubit.get(context).appDirection,
      child: Scaffold(
        body: Stack(
          alignment:
              appLanguage != 'ar' ? Alignment.topRight : Alignment.topLeft,
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageViewCon,
                    itemCount: list.length,
                    itemBuilder: (context, index) =>
                        boardingItem(model: list[index], index: index),
                    onPageChanged: (index) {
                      if (index == 3) {
                        isLast = true;
                      } else {
                        isLast = false;
                      }
                      setState(() {
                        print(isLast);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      SmoothPageIndicator(
                        controller: pageViewCon,
                        effect: ExpandingDotsEffect(
                          dotColor: Colors.grey,
                          activeDotColor: defaultColor,
                          dotHeight: 10,
                          expansionFactor: 4,
                          dotWidth: 10,
                          spacing: 5.0,
                        ),
                        count: list.length,
                      ),
                      Spacer(),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: defaultColor.withOpacity(0.50),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (isLast) {
                                navigateTo(
                                  context: context,
                                  widget: LoginScreen(),
                                );
                              } else {
                                pageViewCon.nextPage(
                                  duration: Duration(milliseconds: 750),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                );
                              }
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
              child: TextButton(
                  onPressed: () {
                    navigateTo(context:context,widget: LoginScreen());
                  },
                  child: Text(
                    appLang(context).skip,
                    style: TextStyle(color: defaultColor),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
