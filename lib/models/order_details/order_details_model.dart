// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  dynamic message;
  Data data;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.cost,
    this.discount,
    this.points,
    this.vat,
    this.total,
    this.pointsCommission,
    this.promoCode,
    this.paymentMethod,
    this.date,
    this.status,
    this.address,
    this.products,
  });

  int id;
  dynamic cost;
  dynamic discount;
  dynamic points;
  dynamic vat;
  dynamic total;
  dynamic pointsCommission;
  String promoCode;
  String paymentMethod;
  String date;
  String status;
  OrderShippingAddress address;
  List<OrderProducts> products;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    cost: json["cost"],
    discount: json["discount"],
    points: json["points"],
    vat: json["vat"].toDouble(),
    total: json["total"],
    pointsCommission: json["points_commission"],
    promoCode: json["promo_code"],
    paymentMethod: json["payment_method"],
    date: json["date"],
    status: json["status"],
    address: OrderShippingAddress.fromJson(json["address"]),
    products: List<OrderProducts>.from(json["products"].map((x) => OrderProducts.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cost": cost,
    "discount": discount,
    "points": points,
    "vat": vat,
    "total": total,
    "points_commission": pointsCommission,
    "promo_code": promoCode,
    "payment_method": paymentMethod,
    "date": date,
    "status": status,

  };
}

class OrderShippingAddress {
  OrderShippingAddress({
    this.id,
    this.name,
    this.city,
    this.region,
    this.details,
    this.notes,
    this.latitude,
    this.longitude,
  });

  int id;
  String name;
  String city;
  String region;
  String details;
  String notes;
  double latitude;
  double longitude;

  factory OrderShippingAddress.fromJson(Map<String, dynamic> json) => OrderShippingAddress(
    id: json["id"],
    name: json["name"],
    city: json["city"],
    region: json["region"],
    details: json["details"],
    notes: json["notes"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
  );

}

class OrderProducts {
  OrderProducts({
    this.id,
    this.quantity,
    this.price,
    this.name,
    this.image,
  });

  int id;
  int quantity;
  dynamic price;
  String name;
  String image;

  factory OrderProducts.fromJson(Map<String, dynamic> json) => OrderProducts(
    id: json["id"],
    quantity: json["quantity"],
    price: json["price"],
    name: json["name"],
    image: json["image"],
  );


}
