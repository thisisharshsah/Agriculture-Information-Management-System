import 'package:aims/add_page.dart';
import 'package:aims/user_model.dart';
import 'package:flutter/material.dart';

class MultiForm extends StatefulWidget {
  @override
  _MultiFormState createState() => _MultiFormState();
}

class _MultiFormState extends State<MultiForm> {
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
        title: Text('Add Crops'),
        actions: [
          FlatButton(
              child: Text('Save', style: TextStyle(color: Colors.white)),
              onPressed: onSave)
        ],
        backgroundColor: Colors.green,
      ),
      body: crops.length == 0
          ? Center(
              child: RichText(
                text: TextSpan(
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
        child: Icon(Icons.add),
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
      form.isValid();
    }
  }
}
