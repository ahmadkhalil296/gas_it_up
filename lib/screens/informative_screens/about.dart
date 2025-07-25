import 'package:flutter/material.dart';

import '../../widgets/back_button.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              //about us header with picture
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 10, top: 20),
                        child: Text(
                          "About Us",
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 200,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                                image:
                                    AssetImage('assets/images/about-us.jpg')))),
                  ],
                ),
              ),

              //who we are
              Container(
                  margin: EdgeInsets.only(bottom: 20, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Who We Are",
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.left,
                          )),
                      Text(
                        "We are Gas It Up, a team dedicated to revolutionize the way you refuel and take care of your vehicle. Our mission is to provide top-notch service, convenience, and innovation in every drop of fuel we deliver.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  )),

              //contact us
              Container(
                  margin: EdgeInsets.only(bottom: 20, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Contact us",
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(children: [
                        SizedBox(
                            width: 50,
                            child: Image(
                                image: AssetImage('assets/images/phone.png'))),
                        SizedBox(width: 20),
                        Text("+96176592382 / +96171084697",
                            style: Theme.of(context).textTheme.bodyMedium)
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        SizedBox(
                            width: 50,
                            child: Image(
                                image: AssetImage('assets/images/email.png'))),
                        SizedBox(width: 20),
                        Text("gasitup.station@gmail.com",
                            style: Theme.of(context).textTheme.bodyMedium)
                      ]),
                    ],
                  )),

              //follow us
              Container(
                  margin: EdgeInsets.only(bottom: 20, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Follow us",
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                              width: 50,
                              child: Image(
                                image:
                                    AssetImage('assets/images/instagram.png'),
                              )),
                          SizedBox(
                              width: 50,
                              child: Image(
                                image: AssetImage('assets/images/facebook.png'),
                              )),
                          SizedBox(
                              width: 50,
                              child: Image(
                                image: AssetImage('assets/images/linkedin.png'),
                              )),
                        ],
                      )
                    ],
                  )),

              Container(
                margin: const EdgeInsets.only(top: 25, bottom: 20),
                child: const CustomBackButton(),
              )
            ],
          ),
        ));
  }
}
