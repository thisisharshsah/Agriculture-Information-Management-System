import 'package:aims/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

typedef OnDelete();

class AddPage extends StatefulWidget {
  FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;
  UserModel loggedInUser = UserModel();
  final Crops? crop;
  final state = _AddPageState();
  final OnDelete? onDelete;

  AddPage({Key? key, this.crop, this.onDelete}) : super(key: key);
  @override
  _AddPageState createState() => state;

  bool isValid() => state.validate();
}

class _AddPageState extends State<AddPage> {
  final formKey = GlobalKey<FormState>();

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
                  onSaved: (value) {},
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
                  onSaved: (value) {},
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
                        onSaved: (value) {},
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
                        onSaved: (value) {},
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
                  onSaved: (value) {},
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
}
