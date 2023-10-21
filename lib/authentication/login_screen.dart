import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uberdrivernew/authentication/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uberdrivernew/mainScreens/main_screen.dart';

import '../global/global.dart';
import '../mongoDB/mongodatabase.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required.");
    } else {
      loginDriverNow(context);
    }
  }


  loginDriverNow(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });
    Map<String, dynamic>? user =
    await MongoDatabase.checkDriverisValid(emailTextEditingController.text.trim(), passwordTextEditingController.text.trim());

    Map<String, dynamic>? car =
    await MongoDatabase.checkCarIsValid(emailTextEditingController.text.trim());

    if (user != null) {
      debugPrint("user : ${user.toString()}");
      debugPrint("car : ${car.toString()}");

      onlineDriverData.id = user['id'];
      onlineDriverData.name = user['name'];
      onlineDriverData.phone = user['phone'];
      onlineDriverData.email = user['email'];
      onlineDriverData.car_color = car!['car_color'];
      onlineDriverData.car_model = car['car_model'];
      onlineDriverData.car_number = car['car_number'];

      driverVehicleType = car['car_type'];

      debugPrint("onlineDriverData.id : ${onlineDriverData.id}");
      debugPrint("onlineDriverData.id : ${onlineDriverData.name}");
      debugPrint("onlineDriverData.id : ${onlineDriverData.phone}");
      debugPrint("onlineDriverData.id : ${onlineDriverData.email}");
      debugPrint("onlineDriverData.id : ${onlineDriverData.car_color}");
      debugPrint("onlineDriverData.id : ${onlineDriverData.car_model}");
      debugPrint("onlineDriverData.id : ${onlineDriverData.car_number}");
      debugPrint("onlineDriverData.id : $driverVehicleType");
      Fluttertoast.showToast(msg: "Login Successful.");
      Navigator.push(context,
          MaterialPageRoute(builder: (c) => const MainScreen()));
    } else {
      Fluttertoast.showToast(msg: "No record exist with this email.");
      Navigator.push(context,
          MaterialPageRoute(builder: (c) => const MySplashScreen()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo1.png"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Login as a Driver",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreenAccent,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                child: const Text(
                  "Do not have an Account? SignUp Here",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => SignUpScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
