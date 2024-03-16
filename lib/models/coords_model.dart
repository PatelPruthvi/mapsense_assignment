class CoordsModel {
  int? id;
  double? lat;
  double? long;
  String? address;
  String? markerTitle;
  String? markerSubTitle;

  CoordsModel(
      {this.id,
      this.lat,
      this.long,
      this.address,
      this.markerTitle,
      this.markerSubTitle});

  CoordsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    long = json['long'];
    address = json['address'];
    markerTitle = json['markerTitle'];
    markerSubTitle = json['markerSubTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lat'] = lat;
    data['long'] = long;
    data['address'] = address;
    data['markerTitle'] = markerTitle;
    data['markerSubTitle'] = markerSubTitle;
    return data;
  }
}
