class CityListByCategoryModel {
  String status;
  List<City> city;

  CityListByCategoryModel({this.status, this.city});

  CityListByCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['city'] != null) {
      city = <City>[];
      json['city'].forEach((v) {
        city.add(new City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.city != null) {
      data['city'] = this.city.map((v) => v.toJson()).toList();
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
  dynamic description;
  dynamic image;

  City(
      {this.id,
        this.stateId,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.description,
        this.image});

  City.fromJson(Map<String, dynamic> json) {
    print('iiiiiiiii333333333333333333333333i${json['id']}iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii 777777777777777777777777 iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');

    id = json['id'];
    stateId = json['state_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    image = json['image'];
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
    return data;
  }
}
