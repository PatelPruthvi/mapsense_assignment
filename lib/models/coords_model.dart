class CoordsModel {
  int? id;
  double? lat;
  double? long;

  CoordsModel({this.id, this.lat, this.long});

  CoordsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}
