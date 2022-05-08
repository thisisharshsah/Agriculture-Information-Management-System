import 'package:aims/models/crops_model.dart';
import 'package:aims/screens/login_page.dart';
import 'package:aims/models/user_model.dart';
import 'package:aims/widgets/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'multi_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  Crops crops = Crops();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('AIMS'),
          backgroundColor: Colors.green,
          leading: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: Ink.image(
                image: const AssetImage('assets/black_logo.png'),
                fit: BoxFit.cover,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Drawer(
                          child: UserAccountsDrawerHeader(
                            accountName: Text(
                              "${loggedInUser.firstName} ${loggedInUser.secondName}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            accountEmail: Text("${loggedInUser.email}"),
                            currentAccountPicture: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://www.datocms-assets.com/7165/1572878498-agr.jpg?auto=format&dpr=1&w=1600'),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )),
          )),
      bottomNavigationBar: bottonNavigation(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MultiForm()),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('crops')
            .where('uid', isEqualTo: user!.uid)
            .snapshots(),
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
              return Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            '${data.docs[index].data()['name']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${data.docs[index].data()['cropDescription']}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                      ],
                    ),
                  ),
                  onTap: () => viewCropsDetails(context, data.docs[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showDeleteDialouge(BuildContext context, doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure you want to delete this crop?'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Yes'),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('crops')
                  .doc(doc.id)
                  .delete();
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Crop deleted successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
          ),
          ElevatedButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void showUpdateDialog(BuildContext context, doc) {
    final _nameController = TextEditingController(
      text: doc.data()['name'],
    );
    final _descriptionController = TextEditingController(
      text: doc.data()['cropDescription'],
    );
    final _productionController = TextEditingController(
      text: doc.data()['production'],
    );
    final _farmerPriceController = TextEditingController(
      text: doc.data()['farmerRate'],
    );
    final _marketPriceController = TextEditingController(
      text: doc.data()['marketRate'],
    );

    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Update'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                TextField(
                  controller: _productionController,
                  decoration: const InputDecoration(
                    labelText: 'Production',
                  ),
                ),
                TextField(
                  controller: _farmerPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Farmer Price',
                  ),
                ),
                TextField(
                  controller: _marketPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Market Price',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('crops')
                      .doc(doc.id)
                      .update({
                    'name': _nameController.text,
                    'cropDescription': _descriptionController.text,
                    'production': _productionController.text,
                    'farmerRate': _farmerPriceController.text,
                    'marketRate': _marketPriceController.text,
                  });
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: 'Crop updated successfully',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
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
        ),
      ),
    );
  }

  viewCropsDetails(BuildContext context, doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${doc.data()['name']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Description: ${doc.data()['cropDescription']}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Production: ${doc.data()['production']}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Frarmer Price: ${doc.data()['farmerRate']}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Retailer Price: ${doc.data()['marketRate']}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Province: ${loggedInUser.province}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Ward: ${loggedInUser.ward}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
