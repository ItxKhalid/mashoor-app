import 'package:flutter/material.dart';

import '../../../helper/responsive_helper.dart';
import '../../../util/app_colors.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/web_menu_bar.dart';



class ShopListScreen extends StatelessWidget {
  // Dummy data for shop lists
  final List<Map<String, dynamic>> shopLists = [
    {
      'name': 'SuperMart',
      'subtitle': 'Grocery Store',
      'image': 'assets/image/image2.png',
    },
    {
      'name': 'Fashion Trends',
      'subtitle': 'Clothing Store',
      'image': 'assets/image/img_1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? WebMenuBar()
          : AppBar(
        title: Text('Shope',
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).textTheme.bodyText1.color,
            )),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Theme.of(context).textTheme.bodyText1.color,
          // onPressed: () {
          //   if (catController.isSearching) {
          //     catController.toggleSearch();
          //   } else {
          //     Get.back();
          //   }
          // },
        ),
        backgroundColor: AppColors.primarycolor,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              shadowColor: Colors.teal,
              elevation: 2,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                      width: 60,
                      height: 80,
                      color: Colors.teal,
                      child: Image.asset(index.isEven ? shopLists[1]['image'] :shopLists[0]['image'],fit: BoxFit.cover,)),
                ),
                title: Text(index.isEven ?  shopLists[0]['name']:shopLists[1]['name']),
                subtitle: Text(shopLists[0]['subtitle']),
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    // Add to cart logic here
                    // You can use the index to identify the selected shop
                    // and add it to the cart or perform any other action.
                    print('Added to cart: ${shopLists[index]['name']}');
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
