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
