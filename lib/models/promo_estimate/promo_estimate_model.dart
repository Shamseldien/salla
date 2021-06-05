class PromoEstimateModel {
  bool status;
  dynamic message;
  PromoEstimateData data;

  PromoEstimateModel({this.status, this.message, this.data});

  PromoEstimateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new PromoEstimateData.fromJson(json['data']) : null;
  }

}

class PromoEstimateData {
  dynamic subTotal;
  dynamic discount;
  dynamic points;
  dynamic total;

  PromoEstimateData({this.subTotal, this.discount, this.points, this.total});

  PromoEstimateData.fromJson(Map<String, dynamic> json) {
    subTotal = json['sub_total'];
    discount = json['discount'];
    points = json['points'];
    total = json['total'];
  }

}
