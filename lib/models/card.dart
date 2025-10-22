class CardModel {
  int? id;
  int folderId;
  String value;
  String imageUrl;

  CardModel({
    this.id,
    required this.folderId,
    required this.value,
    required this.imageUrl,
  });

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'],
      folderId: map['folderId'],
      value: map['value'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'folderId': folderId,
      'value': value,
      'imageUrl': imageUrl,
    };
  }
}
