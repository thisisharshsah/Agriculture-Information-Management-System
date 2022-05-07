class UserModel {
  String? uid;
  String? firstName;
  String? secondName;
  String? email;
  String? password;
  String? role;
  String? province;
  String? ward;
  String? familyMembers;

  // constructor
  UserModel(
      {this.uid,
      this.firstName,
      this.secondName,
      this.email,
      this.password,
      this.role,
      this.province,
      this.ward,
      this.familyMembers});

  // Receives data from Firebase and returns a UserModel object
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      province: map['province'],
      ward: map['ward'],
      familyMembers: map['familyMembers'],
    );
  }

  // Send data to Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'secondName': secondName,
      'email': email,
      'password': password,
      'role': role,
      'province': province,
      'ward': ward,
      'familyMembers': familyMembers,
    };
  }
}
