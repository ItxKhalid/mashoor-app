class AllCityModel {
  String status;
  List<Cities> cities;

  AllCityModel({this.status, this.cities});

  AllCityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.cities != null) {
      data['cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  City city;

  Cities({this.city});

  Cities.fromJson(Map<String, dynamic> json) {
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    return data;
  }
}

class City {
  int id;
  String stateId;
  String name;
  String status;
  String createdAt;
  String updatedAt;
  String description;
  String image;
  List<Categories> categories;

  City(
      {this.id,
        this.stateId,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.description,
        this.image,
        this.categories});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateId = json['state_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    image = json['image'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state_id'] = this.stateId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['description'] = this.description;
    data['image'] = this.image;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int id;
  String cityId;
  String name;
  String image;
  int parentId;
  int position;
  int status;
  String createdAt;
  String updatedAt;
  int priority;

  Categories(
      {this.id,
        this.cityId,
        this.name,
        this.image,
        this.parentId,
        this.position,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.priority,});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityId = json['city_id'];
    name = json['name'];
    image = json['image'];
    parentId = json['parent_id'];
    position = json['position'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    priority = json['priority'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city_id'] = this.cityId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['parent_id'] = this.parentId;
    data['position'] = this.position;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['priority'] = this.priority;
    return data;
  }
}
