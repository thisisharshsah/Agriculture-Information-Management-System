import 'package:aims/models/crops_model.dart';
import 'package:aims/models/user_model.dart';
import 'package:aims/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef OnDelete();

class AddPage extends StatefulWidget {
  FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;
  final Crops? crop;
  final state = _AddPageState();
  final OnDelete? onDelete;

  AddPage({Key? key, this.crop, this.onDelete}) : super(key: key);
  @override
  _AddPageState createState() => state;
  bool isValid() => state.validate();

  Future save() => state.save();
}

class _AddPageState extends State<AddPage> {
  final formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final nameController = TextEditingController();
  final productionController = TextEditingController();
  final farmerRateController = TextEditingController();
  final marketRateController = TextEditingController();
  final cropDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Crops'),
                backgroundColor: Colors.green,
                centerTitle: true,
                leading: const Icon(Icons.landscape_sharp),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.onDelete!();
                    },
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Crop Name',
                    hintText: 'Enter Crop Name',
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a crop name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    nameController.text = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Crop Production',
                    hintText: 'Enter annual crop production',
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a crop Production';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productionController.text = value!;
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Farmer Rate',
                          hintText: 'Enter farmer rate per KG',
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the Farmer rate';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          farmerRateController.text = value!;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Market Rate',
                          hintText: 'Enter market rate per KG',
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the Market Rate';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          marketRateController.text = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Crop Description',
                    hintText: 'Enter the crop description',
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the crop description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    cropDescriptionController.text = value!;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    var valid = formKey.currentState!.validate();
    if (valid) formKey.currentState!.save();
    return valid;
  }

  save() async {
    if (validate()) {
      try {
        final crop = Crops(
          name: nameController.text,
          production: productionController.text,
          farmerRate: farmerRateController.text,
          marketRate: marketRateController.text,
          cropDescription: cropDescriptionController.text,
          uid: user!.uid,
        );
        await widget.firebasefirestore.collection('crops').add(crop.toMap());
        Fluttertoast.showToast(
            msg: 'Crop Added Successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'Error: $e',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
