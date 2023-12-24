import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/icon_and_text_widget.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';

import '../../controllers/recommended_product_controller.dart';
import '../../models/recipe.api.dart';
import '../../models/recipe.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({Key? key}) : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  final pageController = PageController(viewportFraction: 0.85);
  var _currentPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = Dimensions.pageViewContainer;
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState((){
        _currentPageValue = pageController.page!;
      });
    });
    getRecipes();
  }

  Future<void> getRecipes() async {
    _recipes = await RecipeApi.getRecipe();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slider section
        GetBuilder<PopularProductController>(builder: (popularProducts){
          return !_isLoading ? Container(
            height: Dimensions.pageView,
            child: PageView.builder(
                controller: pageController,
                itemCount: 9,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  return _buildPageItem(index, _recipes[index]);
                }),
          ) : Center(child: CircularProgressIndicator(color: AppColors.mainColor));
        }),
        // Dots
        GetBuilder<PopularProductController>(builder: (popularProducts){
          return DotsIndicator(
            dotsCount: _recipes.isEmpty ? 1 : 9,
            position: _currentPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }),
        SizedBox(height: Dimensions.height30,),
        // Popular text
        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: "Recommended"),
              SizedBox(width: Dimensions.width10,),
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                child: BigText(text: ".", color: Colors.black26),
              ),
              SizedBox(width: Dimensions.width10,),
              Container(
                child: SmallText(text: "Food pairing"),
              ),
            ],
          ),
        ),
        // List of food and images
        GetBuilder<RecommendedProductController>(builder: (recommendedProducts){
          return !_isLoading ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getRecommendedFood(index, 'home'), arguments: [_recipes]);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
                    child: Row(
                      children: [
                        // image section
                        Container(
                          height: Dimensions.listViewImgSize,
                          width: Dimensions.listViewImgSize,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                              color: Colors.white38,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      _recipes[index].images
                                  ),
                              )
                          ),
                        ),
                        // text container
                        Expanded(
                          child: Container(
                            height: Dimensions.listViewTextContSize,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(Dimensions.radius20),
                                  bottomRight: Radius.circular(Dimensions.radius20),
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BigText(text: _recipes[index].name),
                                  SizedBox(height: Dimensions.height10,),
                                  SmallText(text: "With chinese characteristics"),
                                  SizedBox(height: Dimensions.height10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconAndTextWidget(icon: Icons.circle_sharp, text: "Normal", iconColor: AppColors.iconColor1),
                                      IconAndTextWidget(icon: Icons.star_rate, text: _recipes[index].rating.toString(), iconColor: AppColors.mainColor),
                                      IconAndTextWidget(icon: Icons.access_time, text: _recipes[index].totalTime, iconColor: AppColors.iconColor2),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }) : Center(child: CircularProgressIndicator(color: AppColors.mainColor));
        }),
      ],
    );
  }

  Widget _buildPageItem(int index, Recipe popularProduct) {
    Matrix4 matrix = Matrix4.identity();
    if(index == _currentPageValue.floor()){
      var currentScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currentTrans = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, currentTrans, 0);
    }else if(index == _currentPageValue.floor() + 1){
      var currentScale = _scaleFactor + (_currentPageValue - index + 1) * (1- _scaleFactor);
      var currentTrans = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, currentTrans, 0);
    }else if(index == _currentPageValue.floor() - 1){
      var currentScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currentTrans = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, currentTrans, 0);
    }else{
      var currentScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getPopularFood(index, 'home') , arguments: [_recipes]);
            },
            child: Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                color: const Color(0xFF89dad0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      popularProduct.images
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(left: Dimensions.width30, right: Dimensions.width30, bottom: Dimensions.height30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFe8e8e8),
                    blurRadius: 5.0,
                    offset: Offset(0, 5)
                  ),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, 0)
                  ),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, 0)
                  ),
                ]
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(text: popularProduct.name, size: Dimensions.font26,),
                    SizedBox(height: Dimensions.height10,),
                    Row(
                      children: [
                        Wrap(
                          children: List.generate(5, (index) => Icon(Icons.star, color: AppColors.mainColor, size: 15,)),
                        ),
                        const SizedBox(width: 10,),
                        SmallText(text: "4.6"),
                        const SizedBox(width: 10,),
                        SmallText(text: "1250 Comments"),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconAndTextWidget(icon: Icons.circle_sharp, text: "Normal", iconColor: AppColors.iconColor1),
                        IconAndTextWidget(icon: Icons.star_rate, text: _recipes[index].rating.toString(), iconColor: AppColors.mainColor),
                        IconAndTextWidget(icon: Icons.access_time, text: _recipes[index].totalTime, iconColor: AppColors.iconColor2),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
