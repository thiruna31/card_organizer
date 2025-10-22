class Folder {
  int? id;
  String name;
  String? previewImage;
  int? cardCount;

  Folder({
    this.id,
    required this.name,
    this.previewImage,
    this.cardCount,
  });

  factory Folder.fromMap(Map<String, dynamic> map) => Folder(
    id: map['id'],
    name: map['name'],
    previewImage: map['previewImage'], 
    cardCount: map['cardCount'],       
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'previewImage': previewImage,
    'cardCount': cardCount,
  };
}
