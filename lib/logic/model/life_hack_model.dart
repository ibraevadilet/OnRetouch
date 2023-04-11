class LifehackModel {
  late final String title;
  late final String image;
  late final List<String> descriptionTexts;

  LifehackModel({
    required this.title,
    required this.image,
    required this.descriptionTexts,
  });

  LifehackModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    descriptionTexts = json['description_texts'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['image'] = image;
    data['description_texts'] = descriptionTexts;
    return data;
  }
}
