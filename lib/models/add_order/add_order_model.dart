class AddOrderModel {
  bool status;
  String message;
  Data data;

  AddOrderModel({this.status, this.message, this.data});

  AddOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String paymentMethod;
  dynamic cost;
  dynamic vat;
  dynamic discount;
  dynamic points;
  dynamic total;
  int id;

  Data(
      {this.paymentMethod,
        this.cost,
        this.vat,
        this.discount,
        this.points,
        this.total,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
    cost = json['cost'];
    vat = json['vat'];
    discount = json['discount'];
    points = json['points'];
    total = json['total'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method'] = this.paymentMethod;
    data['cost'] = this.cost;
    data['vat'] = this.vat;
    data['discount'] = this.discount;
    data['points'] = this.points;
    data['total'] = this.total;
    data['id'] = this.id;
    return data;
  }
}
