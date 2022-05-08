import 'package:aims/models/user_model.dart';
import 'package:aims/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: updateProfile());
  }

  Widget updateProfile() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final data = snapshot.requireData;
        final firstNameController =
            TextEditingController(text: data.docs[0].data()['firstName']);
        final secondNameController =
            TextEditingController(text: data.docs[0].data()['secondName']);
        final emailController =
            TextEditingController(text: data.docs[0].data()['email']);
        final provinceController =
            TextEditingController(text: data.docs[0].data()['province']);
        final wardController =
            TextEditingController(text: data.docs[0].data()['ward']);
        final familyMembersController =
            TextEditingController(text: data.docs[0].data()['familyMembers']);

        return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: secondNameController,
                  decoration: const InputDecoration(
                    labelText: 'Second Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your second name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: provinceController,
                  decoration: const InputDecoration(
                    labelText: 'Province',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your province';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: wardController,
                  decoration: const InputDecoration(
                    labelText: 'Ward',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your ward';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: familyMembersController,
                  decoration: const InputDecoration(
                    labelText: 'Family Members',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your family members';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Update Profile'),
                          content: const Text(
                              'Are you sure you want to update your profile?'),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Yes'),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final firstName = firstNameController.text;
                                  final secondName = secondNameController.text;
                                  final email = emailController.text;
                                  final province = provinceController.text;
                                  final ward = wardController.text;
                                  final familyMembers =
                                      familyMembersController.text;

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user!.uid)
                                      .update({
                                    'firstName': firstName,
                                    'secondName': secondName,
                                    'email': email,
                                    'province': province,
                                    'ward': ward,
                                    'familyMembers': familyMembers,
                                  });

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfileScreen()));
                                }
                              },
                            ),
                            ElevatedButton(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()));
                  },
                )
              ],
            ));
      },
    );
  }
}
