class PromoValidateModel {
  bool status;
  dynamic message;
  PromoValidateData data;

  PromoValidateModel({this.status, this.message, this.data});

  PromoValidateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new PromoValidateData.fromJson(json['data']) : null;
  }

}

class PromoValidateData {
  int id;
  String code;
  dynamic value;
  dynamic percentage;
  String startDate;
  String endDate;
  int usagePerUser;

  PromoValidateData(
      {this.id,
        this.code,
        this.value,
        this.percentage,
        this.startDate,
        this.endDate,
        this.usagePerUser});

  PromoValidateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    value = json['value'];
    percentage = json['percentage'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    usagePerUser = json['usage_per_user'];
  }

}
