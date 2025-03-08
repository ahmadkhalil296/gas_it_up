import 'package:flutter/material.dart';
import 'package:mechanic_services/models/vehicule_info.dart';
import 'package:mechanic_services/screens/registration/vehicule_info.dart';

import '../../models/user_model.dart';
import '../../widgets/input_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController familyNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late UserModel userModel;

  String? validateNotEmpty(String? value) {
    return value == null || value.isEmpty ? 'This field is required' : null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(value) ? null : 'Enter a valid email';
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(value) ? null : 'Enter a valid phone number';
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Password must be at least 6 characters';
    if(passwordController.text != confirmPasswordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child:  Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 50,
                            child: Image(image: AssetImage('assets/images/arrow2.png'))),
                        SizedBox(width: 20,),
                        Text("SIGNUP",style: Theme.of(context).textTheme.headlineLarge,)
                      ],
                    ),
                  ),

                  InputField(
                    validator: validateNotEmpty,
                    controller: firstNameController,
                    hintText: 'First Name',
                  ),

                  SizedBox(height: 20),

                  InputField(
                    validator: validateNotEmpty,
                    controller: familyNameController,
                    hintText: 'Family Name',
                  ),
                  SizedBox(height: 20),
                  InputField(
                    validator: validateNotEmpty,
                    controller: usernameController,
                    hintText: 'username',
                  ),
                  SizedBox(height: 20),
                  InputField(
                    validator: validateEmail,
                    controller: emailController,
                    hintText: 'E-mail',
                  ),
                  SizedBox(height: 20),
                  InputField(
                    validator: validatePhone,
                    controller: phoneController,
                    hintText: 'phone number',
                  ),
                  SizedBox(height: 20),
                  InputField(
                    validator: validatePassword,
                    controller: passwordController,
                    inputType: TextInputType.text, // Password input
                    obscureText: true, // Hides input
                    hintText: 'Password',
                  ),
                  SizedBox(height: 20),
                  InputField(
                    validator: validatePassword,
                    controller: confirmPasswordController,
                    inputType: TextInputType.text, // Password input
                    obscureText: true, // Hides input
                    hintText: 'Confirm Password',
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(bottom: 20,left: 30,right: 30),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          userModel = UserModel(
                              firstName: firstNameController.text.trim(),
                              familyName: familyNameController.text.trim(),
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              phoneNumber: phoneController.text.trim(),
                              password: passwordController.text.trim(),
                              vehicleInfo: VehicleInfo.defaultConst());
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => VehiculeInfo(userModel: userModel)));

                        }
                      },
                      child: Text("Vehicle\'s Info",style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already Have an Account?",style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(width: 10,),
                      Expanded(

                        child: ElevatedButton(onPressed: (){
                          Navigator.pushNamed(context, '/login');
                        },
                            child: Text('Login',style: TextStyle(fontWeight: FontWeight.bold))),
                      )
                    ],
                  )
                ],
              )
          )
        ),
      ),
    );
  }
}
