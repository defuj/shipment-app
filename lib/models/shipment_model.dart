class ShipmentModel {
  String id;
  String status;
  String item;
  String expedition;
  List<ShipmentHistoryModel>? history;

  ShipmentModel({
    required this.id,
    required this.status,
    required this.item,
    required this.expedition,
    this.history,
  });

  ShipmentModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        status = json['status'].toString(),
        item = json['item'].toString(),
        expedition = json['expedition'].toString(),
        history = json['history'] != null
            ? List<ShipmentHistoryModel>.from(
                json['history'].map((x) => ShipmentHistoryModel.fromJson(x)))
            : [];
}

class ShipmentHistoryModel {
  String description;
  String time;
  String? image;

  ShipmentHistoryModel({
    required this.description,
    required this.time,
    this.image,
  });

  ShipmentHistoryModel.fromJson(Map<String, dynamic> json)
      : description = json['description'].toString(),
        time = json['time'].toString(),
        image = json['image'].toString();
}
