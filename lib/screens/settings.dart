import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// For Image Picker
import 'package:path/path.dart' as Path;
import 'package:pick_a_pill_pub/models/user_model.dart';
import 'package:pick_a_pill_pub/services/database.dart';
import 'package:pick_a_pill_pub/shared/constant.dart';
import 'package:pick_a_pill_pub/shared/loading.dart';

class Settings extends StatefulWidget {
  final String userUid;
  Settings({this.userUid});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // TaskSnapshot taskSnapshot;
  bool loading = false;

  File _image;
  String url;
  String name;
  String _currentName;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: DatabaseService(uid: widget.userUid).myData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            name = user.name;
            if (loading) {
              return Loading();
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(user.name),
                ),
                backgroundColor: Colors.blue[100],
                body: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Update your Profile',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: user.name,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Name'),
                        validator: (value) =>
                            value.isEmpty ? 'Please enter your name' : null,
                        onChanged: (value) {
                          setState(() {
                            _currentName = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              print(user.name);
                              print(_currentName);
                              print(user.uid);
                              loading = true;
                            });
                            if (_image != null) {
                              print('Chose Image');
                              await uploadImageToFirebase();
                              print('Finished uploading $url');
                            }
                            await DatabaseService(uid: user.uid).updateUser(
                                null,
                                _currentName ?? user.name,
                                url ?? user.imageUrl);
                            loading = false;
                            Navigator.pop(context);
                          }
                        },
                        color: Colors.pink[400],
                        child: Text(
                          'Update',
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
                      //  _image == null
                      RaisedButton(
                        child: Text('Choose File'),
                        onPressed: pickImage,
                        color: Colors.cyan,
                      ),
                      //     : Container(),
                      // _image != null
                      //     ? RaisedButton(
                      //         child: Text('Upload File'),
                      //         onPressed: () async {
                      //           uploadImageToFirebase();
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
              );
            }
          } else {
            return Loading();
          }
        });
  }

//   Future chooseFile() async {
//    await _picker.getImage(source: ImageSource.gallery).then((image) {
//      setState(() {
//        _image = image;
//      });
//    });
//  }
  Future pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase() async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('PharmacyLogos/${widget.userUid}');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() async {
      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          url = fileURL;
          print(url);
        });
        print('Stuff');
      });
    });
  }
  // await uploadTask.whenComplete(() {
  //   TaskSnapshot taskSnapshot;
  //   return taskSnapshot.ref.getDownloadURL().then(
  //     (value) {
  //       url = value;
  //       print("Done: $value");
  //       print('$url');
  //     },
  //   );
  // });

}
