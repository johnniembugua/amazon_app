import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/custom_textfield.dart';

enum Auth {
  signIn,
  signUp,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth-screen";
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signUp;
  final _signupFormKey = GlobalKey<FormState>();
  final _signinFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              ListTile(
                tileColor: _auth == Auth.signUp
                    ? GlobalVariables.backgroundColor
                    : GlobalVariables.greyBackgroundCOlor,
                title: const Text("Create Account",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                leading: Radio(
                  value: Auth.signUp,
                  groupValue: _auth,
                  onChanged: (Auth? value) {
                    print(value);
                    setState(() {
                      _auth = value!;
                    });
                  },
                  activeColor: GlobalVariables.secondaryColor,
                ),
              ),
              if (_auth == Auth.signUp)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                      key: _signupFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: "Name",
                            controller: _nameController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            hintText: "Email",
                            controller: _emailController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            hintText: "Password",
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                              text: "Sign Up",
                              onTap: () {
                                if (_signupFormKey.currentState!.validate()) {
                                  signUpUser();
                                }
                              })
                        ],
                      )),
                ),
              ListTile(
                tileColor: _auth == Auth.signIn
                    ? GlobalVariables.backgroundColor
                    : GlobalVariables.greyBackgroundCOlor,
                title: const Text("Sign In",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                leading: Radio(
                  value: Auth.signIn,
                  groupValue: _auth,
                  onChanged: (Auth? value) {
                    print(value);
                    setState(() {
                      _auth = value!;
                    });
                  },
                  activeColor: GlobalVariables.secondaryColor,
                ),
              ),
              if (_auth == Auth.signIn)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                      key: _signupFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: "Email",
                            controller: _emailController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            hintText: "Password",
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 10),
                          CustomButton(text: "Sign In", onTap: () {})
                        ],
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
