import 'package:aims/models/user_model.dart';
import 'package:aims/screens/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: 'aims');

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Admin'),
          backgroundColor: Colors.green,
          actions: [
            ElevatedButton(
              child: const Text('Add User'),
              onPressed: () => addUser(),
            ),
            ElevatedButton(
              child: const Icon(Icons.logout_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: buildDataTable(),
      );

  Widget buildDataTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final data = snapshot.requireData;

        return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(data.docs[index].data()['firstName'] +
                  ' ' +
                  data.docs[index].data()['secondName']),
              subtitle: Text(data.docs[index].data()['email']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showUpdateDialog(context, data.docs[index]);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDeleteDialouge(context, data.docs[index]);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void addUser() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Add User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter first name';
                    } else if (value.length < 3) {
                      return 'First name must be at least 3 characters';
                    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'First name must be alphabetic';
                    }

                    return null;
                  },
                  onSaved: (value) => _firstNameController.text = value!,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last name';
                    } else if (value.length < 3) {
                      return 'Last name must be at least 3 characters';
                    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'Last name must be alphabetic';
                    }

                    return null;
                  },
                  onSaved: (value) => _lastNameController.text = value!,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email';
                    } else if (!RegExp(
                            r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                  onSaved: (value) => _emailController.text = value!,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _roleController,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter role';
                    } else if (value.length < 3) {
                      return 'Role must be at least 3 characters';
                    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'Role must be alphabetic';
                    }

                    return null;
                  },
                  onSaved: (value) => _roleController.text = value!,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    } else if (value.length > 12) {
                      return 'Password must be less than 12 characters';
                    }

                    return null;
                  },
                  onSaved: (value) => _passwordController.text = value!,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () {
                  addUserToFirebase();
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  _firstNameController.clear();
                  _lastNameController.clear();
                  _emailController.clear();

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addUserToFirebase() async {
    final UserModel user = UserModel(
      firstName: _firstNameController.text,
      secondName: _lastNameController.text,
      email: _emailController.text,
      role: _roleController.text,
      password: _passwordController.text,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(user.toMap());

    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();

    Fluttertoast.showToast(
      msg: 'User added successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showUpdateDialog(BuildContext context, doc) async {
    final UserModel user = UserModel.fromMap(doc.data());

    final _editFirstNameController =
        TextEditingController(text: user.firstName);
    final _editLastNameController =
        TextEditingController(text: user.secondName);
    final _editEmailController = TextEditingController(text: user.email);
    final _editRoleController = TextEditingController(text: user.role);
    final _editPasswordController = TextEditingController(text: user.password);

    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Update User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _editFirstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter first name';
                    } else if (value.length < 3) {
                      return 'First name must be at least 3 characters';
                    } else if (value.length > 20) {
                      return 'First name must be less than 20 characters';
                    } else if (RegExp(r'[!@#<>?":_`~;[\]|=+)(*&^%0-9-]')
                        .hasMatch(value)) {
                      return 'First name must not contain special characters';
                    }
                    return null;
                  },
                  onSaved: (value) => _editFirstNameController.text = value!,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _editLastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last name';
                    } else if (value.length < 3) {
                      return 'Last name must be at least 3 characters';
                    } else if (value.length > 20) {
                      return 'Last name must be less than 20 characters';
                    } else if (RegExp(r'[!@#<>?":_`~;[\]|=+)(*&^%0-9-]')
                        .hasMatch(value)) {
                      return 'Last name must not contain special characters';
                    }
                    return null;
                  },
                  onSaved: (value) => _editLastNameController.text = value!,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _editEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email';
                    } else if (!RegExp(
                            r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) => _editEmailController.text = value!,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _editRoleController,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter role';
                    } else if (value.length < 3) {
                      return 'Role must be at least 3 characters';
                    } else if (value.length > 20) {
                      return 'Role must be less than 20 characters';
                    } else if (RegExp(r'[!@#<>?":_`~;[\]|=+)(*&^%0-9-]')
                        .hasMatch(value)) {
                      return 'Role must not contain special characters';
                    }
                    return null;
                  },
                  onSaved: (value) => _editRoleController.text = value!,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _editPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    } else if (value.length > 12) {
                      return 'Password must be less than 12 characters';
                    }
                    return null;
                  },
                  onSaved: (value) => _editPasswordController.text = value!,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(doc.id)
                      .update({
                    'firstName': _editFirstNameController.text,
                    'secondName': _editLastNameController.text,
                    'email': _editEmailController.text,
                    'role': _editRoleController.text,
                    'password': _editPasswordController.text,
                  });

                  _editFirstNameController.clear();
                  _editLastNameController.clear();
                  _editEmailController.clear();
                  _editRoleController.clear();
                  _editPasswordController.clear();

                  Fluttertoast.showToast(
                    msg: 'User updated successfully',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  _editFirstNameController.clear();
                  _editLastNameController.clear();
                  _editEmailController.clear();
                  _editRoleController.clear();
                  _editPasswordController.clear();

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteDialouge(BuildContext context, doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Delete'),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(doc.id)
                  .delete();

              Fluttertoast.showToast(
                msg: 'User deleted successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
