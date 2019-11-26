
class VaccineAnimal {
  String id;
  String animalId;
  String vaccineId;
  String userId;

  VaccineAnimal({this.id, this.animalId, this.vaccineId, userId});

  VaccineAnimal.fromMap(Map map, String id):
      id = id ?? '',
      animalId = map['animalId'] ?? '',
      vaccineId = map['vaccineId'] ?? '',
      userId = map['userId'] ?? '';

  toJson(){
    return{
      "animal_id": animalId,
      "vaccine_id": vaccineId
    };
  }

}