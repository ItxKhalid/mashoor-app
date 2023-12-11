import 'package:efood_multivendor/util/app_colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/screens/home/see_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/restaurant_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../util/styles.dart';
import '../../base/no_data_screen.dart';
import '../category/category_screen.dart';
import '../seasonal/seasonal_view.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    Get.find<RestaurantController>().getCityList();
    print('object');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primarycolor,
      child: SafeArea(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await Get.find<RestaurantController>().getCityList();
            },
            child: GetBuilder<RestaurantController>(
              builder: (allCityController) {
                return allCityController.allCityList != null
                    ? allCityController.allCityList.length > 0
                        ? NestedScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            headerSliverBuilder: ((context, isScrolled) => [
                                  SliverToBoxAdapter(
                                      /// Upper green body
                                      child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: AppColors.primarycolor,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/image/img_9.png"))),
                                            ),
                                            Text(
                                              "مشہور",
                                              style: robotoRegular.copyWith(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffACACAC)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.notifications,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 35,
                                        ),

                                        SizedBox(
                                          height: 52,
                                          width: Get.width,
                                          child: TextField(
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: Colors.grey,
                                              ),
                                              fillColor: Colors.white,
                                              enabled: true,
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              hintText: "Search",
                                            ),
                                          ),
                                        ),
                                        // SizedBox(height: 35,),
                                      ],
                                    ),
                                  )),
                                  SliverPersistentHeader(
                                    pinned: true,
                                    floating: true,
                                    delegate: MyDelegate(
                                      /// Tabbar
                                      TabBar(
                                        // padding: EdgeInsets.only(top: 20),
                                        dividerColor: Colors.transparent,
                                        indicatorColor: Colors.white,
                                        labelColor: Colors.white,
                                        padding: EdgeInsets.only(right: 70),
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        indicatorWeight: 3,
                                        // onTap: (index) {
                                        //   tabController.animateTo(index); // This line changes the selected index
                                        // },
                                        controller: tabController,
                                        unselectedLabelColor:
                                            AppColors.primarycolor,
                                        indicatorPadding: EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 30),
                                        labelPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 13, vertical: 0),
                                        tabs: [
                                          Tab(
                                            child: Text(
                                              "Cities",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: tabController.index == 0
                                                          ? Colors.white
                                                          : Colors.white),
                                            ),
                                          ),
                                          Tab(
                                            child: Text(
                                              "Categories",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      tabController.index == 1
                                                          ? Colors.white
                                                          : Colors.white),
                                            ),
                                          ),
                                          Tab(
                                            child: Text(
                                              "Seasonal",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      tabController.index == 2
                                                          ? Colors.white
                                                          : Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                            body: TabBarView(
                              physics: const BouncingScrollPhysics(),
                              controller: tabController,
                              children: [
                                SingleChildScrollView(
                                  child: Container(
                                    // padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      children: [
                                        // SizedBox(height: 28,),

                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Cities",
                                                style: robotoRegular.copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(() => SeeAllScreen());
                                                },
                                                child: Container(
                                                  height: 28,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primarycolor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Center(
                                                      child: Text(
                                                    "See more",
                                                    style:
                                                        robotoRegular.copyWith(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                  )),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        Container(
                                          height: 530,
                                          child: PageView.builder(
                                              itemCount: allCityController
                                                  .allCityList.length,
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              // shrinkWrap: true,
                                              itemBuilder: (context, indexP) {
                                                return Container(
                                                  height: 524,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .RADIUS_LARGE)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 200,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            15))),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          20)),
                                                          child: GridTile(
                                                            child: Image.asset(
                                                                'assets/image/img_10.png'),
                                                            footer: Container(
                                                              height: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                          begin: Alignment
                                                                              .topCenter,
                                                                          end: Alignment
                                                                              .bottomCenter,
                                                                          colors: [
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0),
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0.5),
                                                                    Colors
                                                                        .black,
                                                                  ])),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            25.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Spacer(),
                                                                    Text(
                                                                      allCityController
                                                                          .allCityList[
                                                                              indexP]
                                                                          .city
                                                                          .name
                                                                          .toString(),
                                                                      style: robotoRegular.copyWith(
                                                                          fontSize: Dimensions.fontSizeExtraLarge +
                                                                              2,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .location_on_sharp,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          "Punjab",
                                                                          style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeDefault,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.white,
                                                                              overflow: TextOverflow.ellipsis),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          14,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 30),
                                                        child: Text(
                                                          allCityController
                                                              .allCityList[
                                                                  indexP]
                                                              .city
                                                              .name
                                                              .toString(),
                                                          style: robotoRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeLarge,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 30),
                                                        child: SizedBox(
                                                            // color: Colors.red,
                                                            height: 50,
                                                            width: 300,
                                                            child: Text(
                                                              allCityController
                                                                          .allCityList[
                                                                              indexP]
                                                                          .city
                                                                          .description ==
                                                                      null
                                                                  ? 'no description'
                                                                  : allCityController
                                                                      .allCityList[
                                                                          indexP]
                                                                      .city
                                                                      .description
                                                                      .toString(),
                                                              style:
                                                                  robotoRegular
                                                                      .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeDefault,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.38),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              maxLines: 3,
                                                            )),
                                                      ),
                                                      SizedBox(height: 22),
                                                      Container(
                                                        height: 100,
                                                        width: 340,
                                                        child: allCityController
                                                            .allCityList[
                                                        indexP]
                                                            .city
                                                            .categories
                                                            .length ==
                                                            0 ?Center(child: Text('No Categories is available')) : ListView.builder(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20),
                                                            physics:
                                                                AlwaysScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                allCityController
                                                                    .allCityList[
                                                                        indexP]
                                                                    .city
                                                                    .categories
                                                                    .length,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              print(
                                                                  '.............${allCityController.allCityList[indexP].city.categories.length}');
                                                              return allCityController
                                                                          .allCityList[
                                                                              indexP]
                                                                          .city
                                                                          .categories
                                                                          .length !=
                                                                      0
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                60,
                                                                            width:
                                                                                60,
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.black38,
                                                                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                                                                                image: DecorationImage(
                                                                                  image: NetworkImage('${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${allCityController.allCityList[indexP].city.categories[index].image}'),
                                                                                )),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            allCityController.allCityList[indexP].city.categories[index].name.toString(),
                                                                            style: robotoRegular.copyWith(
                                                                                fontSize: Dimensions.fontSizeLarge,
                                                                                fontWeight: FontWeight.w300,
                                                                                color: Colors.black.withOpacity(0.57),
                                                                                overflow: TextOverflow.ellipsis),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  // : CircularProgressIndicator()
                                                                  : Text(
                                                                      'data');
                                                            }),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                      Container(
                                                        width: Get.width,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: 40,
                                                              width: 183,
                                                              child: Center(
                                                                  child: Text(
                                                                "Explore City",
                                                                style: robotoRegular.copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeLarge,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              )),
                                                              decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .primarycolor,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimensions
                                                                              .RADIUS_DEFAULT)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                CategoryScreen(),
                                SeasonalScreen(),
                              ],
                            ),
                          )
                        : NoDataScreen(text: 'no_category_found'.tr)
                    : Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.widget);

  final Widget widget;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.primarycolor,
      child: widget,
    );
  }

  @override
  double get maxExtent => 90;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
