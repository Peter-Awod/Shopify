import 'package:flutter/material.dart';
import 'package:shop_application/modules/shop_login/login.dart';
import 'package:shop_application/shared/components/components.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/network/local/shop_cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingModel {
  late String title;
  late String body;
  late String img;
  OnBoardingModel({
    required this.title,
    required this.body,
    required this.img,
  });
}

class OnBoardingScreen extends StatelessWidget {
  List<OnBoardingModel> boarding = [
    OnBoardingModel(
      title: 'Screen 1 title',
      body: 'Screen 1 body',
      img: 'assets/images/images (3).png',
    ),
    OnBoardingModel(
      title: 'Screen 2 title',
      body: 'Screen 2 body',
      img: 'assets/images/download (1).png',
    ),
    OnBoardingModel(
      title: 'Screen 3 title',
      body: 'Screen 3 body',
      img: 'assets/images/images (3).png',
    ),
  ];

  var boardController = PageController();

  bool isLastPage = false;

  void goToLogin({required BuildContext context}) {
    ShopCacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value!) {
        pushAndRemoveNavigateTo(context, ShopLoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            function: (){goToLogin(context: context);},
            text: 'Skip',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder: (context, index) => buildPageItem(boarding[index]),
                itemCount: boarding.length,
                onPageChanged: (index) {
                  if (index == boarding.length - 1) {
                    isLastPage = true;
                    print('Last Page');
                  } else {
                    isLastPage = false;
                    print('not Last Page');
                  }
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: defaultColor,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5,
                  ),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLastPage == true) {
                      goToLogin(context: context);
                    } else {
                      boardController.nextPage(
                        duration: Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPageItem(OnBoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage('${model.img}'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '${model.title}',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '${model.body}',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      );
}
