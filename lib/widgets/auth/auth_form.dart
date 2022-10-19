import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  )? submitFN;

  const AuthForm(this.submitFN, this.isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFN!(
          _userEmail.trim(),
          _userPassword.trim(),
          _userName.trim(),
          _userImageFile!,
          _isLogin, context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: const ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: true ,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: 'Email address'),
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: true,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Password must be at least 4 characters';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                                hintText: 'Username'),
                        onSaved: (value) {
                          _userName = value!;
                        },
                      ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        hintText: 'Password',
                      ),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value!;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // if(widget.isLoading)  const CircularProgressIndicator(),
                    // if(!widget.isLoading)
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                      //     shape:
                      //         MaterialStateProperty.all(RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      //         ),
                      ),
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup '),
                    ),
                    // if(!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account',style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              ),
            ),
          ),),
    );
  }
}
