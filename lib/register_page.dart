import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/profile.dart';
import 'package:login_signup/utils/fire_auth.dart';
import 'package:login_signup/utils/validator.dart';
import 'package:login_signup/widgets/custom_checkbox.dart';
import 'theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisible = false;
  bool passwordConfrimationVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [                  
                  Text(
                    'Register',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/images/accent.png',
                    width: 99,
                    height: 4,
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              Form(
                key: _registerFormKey,
                child: Column(
                  children: [
                     Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                         controller: _nameTextController,
                        focusNode: _focusName,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        obscureText: !passwordVisible,
                        validator: (value) => Validator.validatePassword(
                          password: value,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: heading6.copyWith(color: textGrey),
                          suffixIcon: IconButton(
                            color: textGrey,
                            splashRadius: 1,
                            icon: Icon(passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: togglePassword,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        obscureText: !passwordConfrimationVisible,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: heading6.copyWith(color: textGrey),
                          suffixIcon: IconButton(
                            color: textGrey,
                            splashRadius: 1,
                            icon: Icon(passwordConfrimationVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () {
                              setState(() {
                                passwordConfrimationVisible =
                                    !passwordConfrimationVisible;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomCheckbox(),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'By Creating an Account, you agree to our',
                        style: regular16pt.copyWith(color: textGrey),
                      ),
                      Text(
                        'Terms & Conditions',
                        style: regular16pt.copyWith(color: primaryBlue),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(height: 32.0),
                      _isProcessing
                          ? CircularProgressIndicator()
                          : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isProcessing = true;
                                      });

                                      if (_registerFormKey.currentState!
                                          .validate()) {
                                        User? user = await FireAuth
                                            .registerUsingEmailPassword(
                                          name: _nameTextController.text,
                                          email: _emailTextController.text,
                                          password:
                                              _passwordTextController.text,
                                        );

                                        setState(() {
                                          _isProcessing = false;
                                        });

                                        if (user != null) {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage(user: user),
                                            ),
                                            ModalRoute.withName('/'),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                                          Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: regular16pt.copyWith(color: textGrey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Text(
                      'Login',
                      style: regular16pt.copyWith(color: primaryBlue),
                    ),
                  ),
                ],

                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}
