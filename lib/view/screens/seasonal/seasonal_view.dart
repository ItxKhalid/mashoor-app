import 'package:cached_network_image/cached_network_image.dart';
import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SeasonalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getCategoryList(false);
    Get.find<CategoryController>().getSeasonalProduct();

    return Scrollbar(
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
                child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH,
              child: GetBuilder<CategoryController>(builder: (catController) {
                return catController.allSeasonalProduct != null
                    ? catController.allSeasonalProduct.length > 0
                        ? GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  ResponsiveHelper.isDesktop(context)
                                      ? 6
                                      : ResponsiveHelper.isTab(context)
                                          ? 4
                                          : 2,
                              childAspectRatio: (1 * 1 / 1.5),
                              mainAxisSpacing:
                                  Dimensions.PADDING_SIZE_EXTRA_LARGE,
                              crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE,
                                vertical: 10),
                            itemCount: catController.allSeasonalProduct.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => Get.toNamed(
                                    RouteHelper.getCategoryProductRoute(
                                  catController.allSeasonalProduct[index].id,
                                  catController.allSeasonalProduct[index].name,
                                )),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xffF1F1F1),
                                            offset: Offset(0, 0),
                                            spreadRadius: 4,
                                            blurRadius: 4)
                                      ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: GridTile(
                                      header: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Icon(Icons.favorite,
                                              color: Colors.red),
                                        ),
                                      ),
                                      footer: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Icon(Icons.add_circle,
                                              size: 33,
                                              color: AppColors.primarycolor),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CustomImage(
                                                height: 87,
                                                width: 99,
                                                fit: BoxFit.fill,
                                                image:
                                                    '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${catController.allSeasonalProduct[index].image}',
                                              ),
                                              SizedBox(height: 15),
                                              Text(
                                                catController
                                                    .allSeasonalProduct[index]
                                                    .name,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: 'Urbanist',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Starting From',
                                                    style: TextStyle(
                                                      color: Color(0xFF189084),
                                                      fontSize: 12,
                                                      fontFamily: 'Urbanist',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  SizedBox(width: 18),
                                                  Text(
                                                    "Rs ${catController.allSeasonalProduct[index].price.toString()}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontFamily: 'Urbanist',
                                                      fontWeight: FontWeight.w600,
                                                      height: 0,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : NoDataScreen(text: 'no_category_found'.tr)
                    : Center(child: CircularProgressIndicator());
              }),
            ))));
  }
}
