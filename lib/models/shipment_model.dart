class ShipmentModel {
  String id;
  String status;
  String item;
  String expedition;
  List<ShipmentHistoryModel> history;

  ShipmentModel({
    required this.id,
    required this.status,
    required this.item,
    required this.expedition,
    this.history = const [],
  });

  ShipmentModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'],
        item = json['item'],
        expedition = json['expedition'],
        history = (json['history'] as List)
            .map((i) => ShipmentHistoryModel.fromJson(i))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'item': item,
        'expedition': expedition,
        'history': history.map((i) => i.toJson()).toList(),
      };
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
      : description = json['description'],
        time = json['time'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'description': description,
        'time': time,
        'image': image,
      };
}
