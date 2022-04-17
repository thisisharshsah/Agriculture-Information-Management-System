import 'package:aims/models/crops_model.dart';
import 'package:aims/screens/add_page.dart';

import 'package:flutter/material.dart';

class MultiForm extends StatefulWidget {
  const MultiForm({Key? key}) : super(key: key);

  @override
  _MultiFormState createState() => _MultiFormState();
}

class _MultiFormState extends State<MultiForm> {
  final formKey = GlobalKey<FormState>();

  List<Crops> crops = [];
  List<AddPage> pages = [];

  @override
  Widget build(BuildContext context) {
    pages.clear();
    for (int index = 0; index < crops.length; index++) {
      pages.add(AddPage(
        key: GlobalKey(),
        crop: crops[index],
        onDelete: () => onDelete(index),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Crops'),
        actions: [ElevatedButton(child: const Text('Save'), onPressed: onSave)],
        backgroundColor: Colors.green,
      ),
      body: crops.isEmpty
          ? Center(
              child: RichText(
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'No crops added yet.\n',
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                    TextSpan(
                        text: 'Click [+] to Add a crop',
                        style: TextStyle(fontSize: 20, color: Colors.green)),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: crops.length,
              itemBuilder: (_, int index) => pages[index],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            crops.add(Crops());
          });
        },
      ),
    );
  }

  void onDelete(int index) {
    setState(() {
      crops.removeAt(index);
    });
  }

  void onSave() {
    for (var form in pages) {
      if (form.isValid()) {
        form.save();
      }
    }
  }
}
