class UserModel {
  String? uid;
  String? firstName;
  String? secondName;
  String? email;

  // constructor
  UserModel({this.uid, this.firstName, this.secondName, this.email});

  // Receives data from Firebase and returns a UserModel object
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      email: map['email'],
    );
  }

  // Send data to Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'secondName': secondName,
      'email': email,
    };
  }
}

class Crops {
  String? uid;
  String? cropName;
  String? cropImage;
  String? cropDescription;
  String? cropPrice;
  String? cropQuantity;
  String? cropLocation;
  String? cropDate;

  // constructor
  Crops({
    this.uid,
    this.cropName,
    this.cropImage,
    this.cropDescription,
    this.cropPrice,
    this.cropQuantity,
    this.cropLocation,
    this.cropDate,
  });

  // Receives data from Firebase and returns a Crops object
  factory Crops.fromMap(map) {
    return Crops(
      uid: map['uid'],
      cropName: map['cropName'],
      cropImage: map['cropImage'],
      cropDescription: map['cropDescription'],
      cropPrice: map['cropPrice'],
      cropQuantity: map['cropQuantity'],
      cropLocation: map['cropLocation'],
      cropDate: map['cropDate'],
    );
  }

  // Send data to Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'cropName': cropName,
      'cropImage': cropImage,
      'cropDescription': cropDescription,
      'cropPrice': cropPrice,
      'cropQuantity': cropQuantity,
      'cropLocation': cropLocation,
      'cropDate': cropDate,
    };
  }
}
