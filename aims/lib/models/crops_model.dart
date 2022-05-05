class Crops {
  String? uid;
  String? name;
  String? production;
  String? farmerRate;
  String? marketRate;
  String? cropDescription;

  // constructor
  Crops({
    this.uid,
    this.name,
    this.production,
    this.farmerRate,
    this.marketRate,
    this.cropDescription,
  });

  // Receives data from Firebase and returns a Crops object
  factory Crops.fromMap(map) {
    return Crops(
      uid: map['uid'],
      name: map['name'],
      production: map['roduction'],
      farmerRate: map['farmerRate'],
      marketRate: map['marketRate'],
      cropDescription: map['cropDescription'],
    );
  }

  // Send data to Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'production': production,
      'farmerRate': farmerRate,
      'marketRate': marketRate,
      'cropDescription': cropDescription,
    };
  }
}
