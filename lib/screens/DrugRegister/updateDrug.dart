import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pick_a_pill_pub/models/drug.dart';
import 'package:pick_a_pill_pub/models/fire_user.dart';
import 'package:pick_a_pill_pub/services/database.dart';
import 'package:pick_a_pill_pub/shared/constant.dart';
import 'package:pick_a_pill_pub/shared/loading.dart';

import 'package:provider/provider.dart';

class UpdateDrug extends StatefulWidget {
  final Drug drug;
  UpdateDrug({this.drug});
  @override
  _AddDrugState createState() => _AddDrugState();
}

class _AddDrugState extends State<UpdateDrug> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  Drug drug;
  String time;
  File _image;
  String url;
  // String name;

  String name, description, photoUrl;
  int amount;
  bool isAvailable;

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final Drug drug = widget.drug;
    time = drug.time;
    final user = Provider.of<FireUser>(context);
    if (loading) {
      return Loading();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add Drug'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: drug.name,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Drug Name'),
                    validator: (value) =>
                        value.isEmpty ? 'Enter drug\'s name' : null,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: drug.description,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Description'),
                    validator: (value) =>
                        value.isEmpty ? 'Enter drug\'s name' : null,
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: (drug.amount).toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: textInputDecoration.copyWith(hintText: 'Price'),
                    validator: (value) =>
                        value.isEmpty ? 'Enter drug\'s name' : null,
                    onChanged: (value) {
                      setState(() {
                        String _amount = value;
                        amount = int.parse(_amount);
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      print('$name $description $url $amount');
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          print('Valid data');
                          loading = true;
                        });
                        if (_image != null) {
                          print('Chose Image');
                          await uploadImageToFirebase(user.uid);
                          print('Finished uploading $url');
                        }
                        await DatabaseService(uid: user.uid).updateDrug(
                            name ?? drug.name,
                            description ?? drug.description,
                            url ?? drug.photoUrl,
                            drug.time,
                            amount ?? drug.amount);

                        print('It worked');
                        print('$name $description $url $amount');
                        loading = false;
                        Navigator.pop(context);
                      }
                    },
                    color: Colors.cyan[800],
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Selected Image'),
                  _image != null
                      ? Image.asset(
                          _image.path,
                          height: 150,
                        )
                      : Container(height: 150),
                  //_image == null                      ?
                  RaisedButton(
                    child: Text('Choose File'),
                    onPressed: pickImage,
                    color: Colors.cyan,
                  ),
                  // : Container(),
                  // _image != null
                  //     ? RaisedButton(
                  //         child: Text('Upload File'),
                  //         onPressed: () async {
                  //           uploadImageToFirebase(user.uid);
                  //         },
                  //         color: Colors.cyan,
                  //       )
                  //     : Container(),
                  _image != null
                      ? RaisedButton(
                          child: Text('Clear Selection'),
                          onPressed: null,
                        )
                      : Container(),
                  Text('Uploaded Image'),
                  url != null
                      ? Image.network(
                          url,
                          height: 150,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Future pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase(String uid) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('Drug Photos/$uid/$time');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() async {
      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          url = fileURL;
          print(url);
        });
        print('Stuff');

        //DatabaseService(uid: widget.userUid).updateUser(null, name, url);
      });
    });
  }
}
