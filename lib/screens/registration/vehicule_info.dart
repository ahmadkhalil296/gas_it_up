import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../models/vehicule_info.dart';
import '../../services/AuthService.dart';
import '../../widgets/input_field.dart';

class VehiculeInfo extends StatefulWidget {
  UserModel userModel;
   VehiculeInfo({super.key, required this.userModel});

  @override
  State<VehiculeInfo> createState() => _VehiculeInfoState();
}

class _VehiculeInfoState extends State<VehiculeInfo> {
  final typeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final colorController = TextEditingController();
  final plateNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? validateNotEmpty(String? value) {
    return value == null || value.isEmpty ? 'This field is required' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                        width: 100,
                        child: Image(image: AssetImage('assets/images/vehicule.jpg'))),
                  ),
                  SizedBox(width: 20,),
                  Text("Vehicle\'s Info",style: Theme.of(context).textTheme.headlineLarge,),

                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  InputField(
                    hintText: 'Type',
                    validator: validateNotEmpty,
                    controller: typeController,
                  ),
                  SizedBox(height: 20,),
                  InputField(
                    hintText: 'Model',
                    validator: validateNotEmpty,
                    controller: modelController,
                  ),
                  SizedBox(height: 20,),
                  InputField(
                    hintText: 'Year',
                    inputType: TextInputType.number,
                    validator: validateNotEmpty,
                    controller: yearController,
                  ),
                  SizedBox(height: 20,),
                  InputField(
                    hintText: 'Color',
                    validator: validateNotEmpty,
                    controller: colorController,
                  ),
                  SizedBox(height: 20,),
                  InputField(
                    hintText: 'Plate Number',
                    inputType: TextInputType.number,
                    validator: validateNotEmpty,
                    controller: plateNumberController,
                  ),
                  SizedBox(height: 30,),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () async{
                        if(_formKey.currentState!.validate()){
                          this.widget.userModel.vehicleInfo = VehicleInfo(
                            color: colorController.text.trim(),
                            type: typeController.text.trim(),
                            plateNumber: int.parse(plateNumberController.text.trim()),
                            year: int.parse(yearController.text.trim()),
                            model: modelController.text.trim(),
                          );
                          AuthService().signUp(this.widget.userModel).then((user) => {
                          if(user != null){
                              Navigator.of(context).pushNamed('/home')
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('error occured, please try again later'),
                              duration: Duration(seconds: 2),
                            ),
                          )
                        }
                          });
                        }
                      },
                      child: Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            )


          ],
        ),
      ),
    );
  }
}
