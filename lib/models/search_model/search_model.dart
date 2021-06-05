// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

SearchModel searchModelFromJson(String str) => SearchModel.fromJson(json.decode(str));


class SearchModel {
  SearchModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  dynamic message;
  SearchData data;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    status: json["status"],
    message: json["message"],
    data: SearchData.fromJson(json["data"]),
  );


}

class SearchData {
  SearchData({
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
  List<SearchResults> data;
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

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
    currentPage: json["current_page"],
    data: List<SearchResults>.from(json["data"].map((x) => SearchResults.fromJson(x))),
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

class SearchResults {
  SearchResults({
    this.id,
    this.price,
    this.image,
    this.name,
    this.description,
    this.images,
    this.inFavorites,
    this.inCart,
  });

  int id;
  double price;
  String image;
  String name;
  String description;
  List<String> images;
  bool inFavorites;
  bool inCart;

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
    id: json["id"],
    price: json["price"].toDouble(),
    image: json["image"],
    name: json["name"],
    description: json["description"],
    images: List<String>.from(json["images"].map((x) => x)),
    inFavorites: json["in_favorites"],
    inCart: json["in_cart"],
  );


}
