// To parse this JSON data, do
//
//     final ordersModel = ordersModelFromJson(jsonString);

import 'dart:convert';

OrdersModel ordersModelFromJson(String str) => OrdersModel.fromJson(json.decode(str));


class OrdersModel {
  OrdersModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  dynamic message;
  MyOrders data;

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
    status: json["status"],
    message: json["message"],
    data: MyOrders.fromJson(json["data"]),
  );

}

class MyOrders {
  MyOrders({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<MyOrdersDetails> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory MyOrders.fromJson(Map<String, dynamic> json) => MyOrders(
    currentPage: json["current_page"],
    data: List<MyOrdersDetails>.from(json["data"].map((x) => MyOrdersDetails.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

}

class MyOrdersDetails {
  MyOrdersDetails({
    this.id,
    this.total,
    this.date,
    this.status,
  });

  int id;
  dynamic total;
  String date;
  String status;

  factory MyOrdersDetails.fromJson(Map<String, dynamic> json) => MyOrdersDetails(
    id: json["id"],
    total: json["total"],
    date: json["date"],
    status: json["status"],
  );


}
