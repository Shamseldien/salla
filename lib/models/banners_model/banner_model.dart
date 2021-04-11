class BannersModel {
  bool status;
  Null message;
  List<Data> data;

  BannersModel({this.status, this.message, this.data});

  BannersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = List<Data>();
      json['data'].forEach((v) {
        data.add( Data.fromJson(v));
      });
    }
  }

}

class Data {
  int id;
  String image;
  Null category;
  Null product;

  Data({this.id, this.image, this.category, this.product});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    category = json['category'];
    product = json['product'];
  }

}
