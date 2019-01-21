import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TImagePickerDialog {
  BuildContext _context;
  Function _imageSelected;
  TImagePickerDialog(
      {@required BuildContext context, @required Function imageSelected}) {
    this._context = context;
    this._imageSelected = imageSelected;
  }
  Future getImageFromCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    Navigator.of(_context).pop();
    _imageSelected(image);
  }

  Future getImageFromGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Navigator.of(_context).pop();
    _imageSelected(image);
  }

  void show() {
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: new Text("Choose Image"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new RawMaterialButton(
                  onPressed: getImageFromCamera,
                  child: new Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(10.0),
                ),
                new RawMaterialButton(
                  onPressed: getImageFromGallery,
                  child: new Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(10.0),
                ),
              ],
            ));
      },
    );
  }
}
