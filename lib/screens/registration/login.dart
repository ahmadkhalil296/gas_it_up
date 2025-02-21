import 'package:flutter/material.dart';
import 'package:mechanic_services/services/AuthService.dart';

import '../../widgets/input_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60),

          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Image(image: AssetImage('assets/images/vehicule.jpg'),fit: BoxFit.cover,)),
            ),
          ),

            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 50,
                      child: Image(image: AssetImage('assets/images/arrow1.png'))),
                  SizedBox(width: 20,),
                  Text("LOGIN",style: Theme.of(context).textTheme.headlineMedium,)
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 35),
              padding: EdgeInsets.only(bottom: 20),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    InputField(
                      controller: usernameController,
                      hintText: "Username",
                      icon: Icons.person,
                    ),
                    SizedBox(height:20),
                    InputField(
                      controller: passwordController,
                      inputType: TextInputType.text, // Password input
                      obscureText: true, // Hides input
                      hintText: "Password",
                      icon: Icons.lock,
                    ),

                  ],
                )
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom:20,left: 45),
              width: MediaQuery.of(context).size.width,
              child: Text("forgot password?", style: Theme.of(context).textTheme.bodyMedium,textAlign: TextAlign.left)
            ),

            Container(
              margin: EdgeInsets.only(bottom: 20,left: 30,right: 30),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async{
                  AuthService().signIn(usernameController.text.trim(), passwordController.text.trim()).then((user) => {
                    if(user != null){
                      Navigator.of(context).pushNamed('/home')
                    }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                  content: Text('wrong username or password'),
                  duration: Duration(seconds: 2),
                  ),
                  )
                  }
                  });
                },
                child: Text("Login",style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Text("Don\'t have an account?", style: Theme.of(context).textTheme.bodyMedium,),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, '/sign_up');
                    },
                        child: Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold))),
                  )
                ],
              ),
            )


      ],
        ),
      ),
    );
  }
}
