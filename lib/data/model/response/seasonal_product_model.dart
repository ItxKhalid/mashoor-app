class SeasonalProductModel {
  String message;
  List<Season> season;

  SeasonalProductModel({this.message, this.season});

  SeasonalProductModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['season'] != null) {
      season = <Season>[];
      json['season'].forEach((v) {
        season.add(new Season.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.season != null) {
      data['season'] = this.season.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Season {
  int id;
  String name;
  String description;
  String image;
  int categoryId;
  String categoryIds;
  String variations;
  String addOns;
  String attributes;
  String choiceOptions;
  int price;
  int tax;
  String taxType;
  int discount;
  String discountType;
  String availableTimeStarts;
  String availableTimeEnds;
  int veg;
  int status;
  int restaurantId;
  String createdAt;
  String updatedAt;
  String orderCount;
  int avgRating;
  String ratingCount;
  String rating;
  String kg;

  Season(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.categoryId,
        this.categoryIds,
        this.variations,
        this.addOns,
        this.attributes,
        this.choiceOptions,
        this.price,
        this.tax,
        this.taxType,
        this.discount,
        this.discountType,
        this.availableTimeStarts,
        this.availableTimeEnds,
        this.veg,
        this.status,
        this.restaurantId,
        this.createdAt,
        this.updatedAt,
        this.orderCount,
        this.avgRating,
        this.ratingCount,
        this.rating,
        this.kg});

  Season.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    categoryId = json['category_id'];
    categoryIds = json['category_ids'];
    variations = json['variations'];
    addOns = json['add_ons'];
    attributes = json['attributes'];
    choiceOptions = json['choice_options'];
    price = json['price'];
    tax = json['tax'];
    taxType = json['tax_type'];
    discount = json['discount'];
    discountType = json['discount_type'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    veg = json['veg'];
    status = json['status'];
    restaurantId = json['restaurant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderCount = json['order_count'];
    avgRating = json['avg_rating'];
    ratingCount = json['rating_count'];
    rating = json['rating'];
    kg = json['kg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    data['category_ids'] = this.categoryIds;
    data['variations'] = this.variations;
    data['add_ons'] = this.addOns;
    data['attributes'] = this.attributes;
    data['choice_options'] = this.choiceOptions;
    data['price'] = this.price;
    data['tax'] = this.tax;
    data['tax_type'] = this.taxType;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['available_time_starts'] = this.availableTimeStarts;
    data['available_time_ends'] = this.availableTimeEnds;
    data['veg'] = this.veg;
    data['status'] = this.status;
    data['restaurant_id'] = this.restaurantId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['order_count'] = this.orderCount;
    data['avg_rating'] = this.avgRating;
    data['rating_count'] = this.ratingCount;
    data['rating'] = this.rating;
    data['kg'] = this.kg;
    return data;
  }
}
