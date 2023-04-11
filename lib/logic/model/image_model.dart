class ImageModel {
  late final String image;
  late final String uid;
  late final String date;

  ImageModel({
    required this.image,
    required this.uid,
    required this.date,
  });

  ImageModel.fromJson(Map<dynamic, dynamic> json) {
    image = json['image'];
    uid = json['uid'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['uid'] = uid;
    data['date'] = date;
    return data;
  }
}
