import 'package:efood_multivendor/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
class SeeAllScreen extends StatefulWidget {
  // const SeeAllScreen({super.key});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.bagroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: (){

                        Get.back();
                    },

                      child: Icon(Icons.arrow_back)),
                  Text("Cities",style: robotoRegular.copyWith(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black,overflow: TextOverflow.ellipsis),),
                SizedBox(),
                ],
              ),
              SizedBox(height: 40,),
              Text("All Cities",style: robotoRegular.copyWith(fontSize: 24,fontWeight: FontWeight.w400,color: Colors.black,overflow: TextOverflow.ellipsis),),
              SizedBox(height: 10,),
              Text("Cities you can Explore",style: robotoRegular.copyWith(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(0.38),overflow: TextOverflow.ellipsis),),

              SizedBox(height: 30,),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                    itemBuilder: (context,index){
                  return    Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(10),
                    height: 90,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE+5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage("assets/image/img_10.png"),
                                fit: BoxFit.fill,
                              )
                          ),
                        ),
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6,),
                            Text("Islamabad",style: robotoRegular.copyWith(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black,overflow: TextOverflow.ellipsis),),
                            SizedBox(height: 5,),
                            Text("Islamabad is Famous for Fruits.",style: robotoRegular.copyWith(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(0.57),overflow: TextOverflow.ellipsis),),

                          ],
                        )
                      ],
                    ),
                  );
                }),
              )

            ],
          ),
        ),
      ),
    );
  }
}
