import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../countryByCategory/country_by_category.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getCategoryList(false);

    return Scrollbar(
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
                child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH,
              child: GetBuilder<CategoryController>(builder: (catController) {
                return catController.categoryList != null
                    ? catController.categoryList.length > 0
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
                              childAspectRatio: (1 * 1 / .9),
                              mainAxisSpacing:
                                  Dimensions.PADDING_SIZE_EXTRA_LARGE,
                              crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE,
                                vertical: 10),
                            itemCount: catController.categoryList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () =>
                                    Get.to(() => CountryByCategoryScreen(
                                          categoryID: catController
                                              .categoryList[index].id
                                              .toString(),
                                          categoryName: catController
                                              .categoryList[index].name,
                                        )),

                                // onTap: () =>
                                //     Get.toNamed(RouteHelper.getCategoryProductRoute(
                                //       catController.categoryList[index].id,
                                //       catController.categoryList[index].name,
                                //     )),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white12,
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
                                      footer: Container(
                                        height: 39,
                                        color: Colors.white.withOpacity(0.7),
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              catController
                                                  .categoryList[index].name,
                                              style: robotoMedium.copyWith(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: CustomImage(
                                          fit: BoxFit.fill,
                                          image: '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${catController.categoryList[index].image}',
                                        ),
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
