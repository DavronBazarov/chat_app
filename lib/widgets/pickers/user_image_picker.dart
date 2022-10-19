 import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
 import 'package:path/path.dart' as path;
 import 'package:path_provider/path_provider.dart' as syspaths;

class UserImagePicker extends StatefulWidget {

  final void Function(File piickedImage) imagePickFn;

  const UserImagePicker(this.imagePickFn, {Key? key}) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  Future<void>  _pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 500 ,
    );
    setState(() {
      _pickedImage =File(pickedImageFile!.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedImageFile!.path);
    final savedImage = await _pickedImage?.copy('${appDir.path}/$fileName');
    widget.imagePickFn(savedImage!);
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
       CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey,
        backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
      ),
      TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image, color: Colors.black,),
          label: const Text('Add image', style: TextStyle(color: Colors.black),)),
    ],);
  }
}
