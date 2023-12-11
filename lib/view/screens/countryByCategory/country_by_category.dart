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

class CountryByCategoryScreen extends StatefulWidget {
  final String categoryID;
  final String categoryName;

  CountryByCategoryScreen(
      {@required this.categoryID, @required this.categoryName});

  @override
  State<CountryByCategoryScreen> createState() =>
      _CountryByCategoryScreenState();
}

class _CountryByCategoryScreenState extends State<CountryByCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getCityListByCategory(widget.categoryID);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primarycolor,
        title: Text(widget.categoryName),
        centerTitle: true,
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                  child: SizedBox(
                width: Dimensions.WEB_MAX_WIDTH,
                child: GetBuilder<CategoryController>(builder: (catController) {
                  return catController.cityListByCategory == null
                      ? Padding(
                    padding: const EdgeInsets.only(top: 300.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                      : catController.cityListByCategory.city.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 300.0),
                              child: Center(
                                  child: Text(
                                'No City found',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              )),
                            )
                          : GridView.builder(
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
                              itemCount:
                                  catController.cityListByCategory.city.length,
                              itemBuilder: (context, index) {
                                print(
                                    "..................${catController.cityListByCategory.city.length}");
                                return InkWell(
                                  onTap: () =>
                                      Get.toNamed(RouteHelper.getCategoryProductRoute(
                                        catController.categoryList[index].id,
                                        catController.categoryList[index].name,
                                      )),
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
                                                catController.cityListByCategory
                                                    .city[index].name,
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
                                            image:
                                                '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${catController.cityListByCategory.city[index].image}',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                }),
              )))),
    );
  }
}
