

class Specie {
  String id;
  String specie;
  String userId;

  Specie({this.id, this.specie, this.userId});

  Specie.fromMap(Map map, String id):
      id = id ?? '',
      specie = map['specie'] ?? '',
      userId = map['userId'] ?? '';

  toJson(){
    return {
      "specie": specie,
      "userId": userId
    };
  }

}