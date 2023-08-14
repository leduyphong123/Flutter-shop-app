import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shop_app/api_connection/api_connection.dart';
import 'package:shop_app/users/authentication/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/users/model/user.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var formKey= GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;
  validateUserEmail() async {
    try{
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'user_email':emailController.text.trim(),
        }
      );
      if(res.statusCode == 200) {
        var resBodyOfValidateEmail = jsonDecode(res.body);

        if(resBodyOfValidateEmail['emailFound']==true){
          Fluttertoast.showToast(msg: "Email is already in someon else use. Try another email.");
        } else{
          //regiester & save new user record to database

          registerAndSaveUserRecord();
        }
      }
    }catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  registerAndSaveUserRecord() async {
    User userModel= User(1, nameController.text.trim(),emailController.text.trim() , passwordController.text.trim());

    try{
      var res = await http.post(Uri.parse(API.signUp),
      body: userModel.toJson()
      );

      if(res.statusCode == 200 ){
        var resBodyofSignup = jsonDecode(res.body);
        if(resBodyofSignup['success']==true){
          Fluttertoast.showToast(msg: "SignUp Successfuly");
          setState(() {
            nameController.clear();
            emailController.clear();
            passwordController.clear();
          });
        }
        else{
          Fluttertoast.showToast(msg: "Error Occurred, Try Again");
        }
      }
    }catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(constraints: BoxConstraints(
          minHeight: cons.maxHeight,
        ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Sign up screen header
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 285,
                  child: Image.asset("assets/images/register.jpg"),
                ),
                //Sign up screen sign-up form
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(Radius.circular(60),),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0,-3),
                          )
                        ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30,30,30,30),
                      child: Column(
                        children: [
                          //email-password-login btn
                          Form(key: formKey,
                            child: Column(
                              children: [
                                //name
                                TextFormField(
                                  controller: nameController,
                                  validator: (val)=> val == "" ? "Please wirte name" : null,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person,color: Colors.black,),
                                    hintText: "name",
                                    border:  OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 14,vertical: 6),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                                SizedBox(height: 18,),
                                //email
                                TextFormField(
                                  controller: emailController,
                                  validator: (val)=> val == "" ? "Please wirte email" : null,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email,color: Colors.black,),
                                    hintText: "email",
                                    border:  OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 14,vertical: 6),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                                SizedBox(height: 18,),
                                //pasword
                                Obx(() => TextFormField(
                                  controller: passwordController,
                                  obscureText: isObsecure.value,
                                  validator: (val)=> val == "" ? "password..." : null,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.vpn_key,color: Colors.black,),
                                    suffixIcon: Obx(()=> GestureDetector(
                                      onTap: () {
                                        isObsecure.value = !isObsecure.value;

                                      },
                                      child: Icon(
                                        isObsecure.value? Icons.visibility_off : Icons.visibility,
                                        color: Colors.black,
                                      ),
                                    )),
                                    hintText: "password",
                                    border:  OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 14,vertical: 6),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),),

                                //button Signup
                                SizedBox(height: 18,),
                                Material(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      if(formKey.currentState!.validate()){
                                        //validate the email
                                        validateUserEmail();
                                      };

                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 28),
                                      child: Text(
                                        "Signup",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16
                                        ),
                                      ),
                                    ),
                                  ),
                                )


                              ],
                            ),),
                          SizedBox(height: 16,),
                          //dont have an account button - button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an Account?"),
                              TextButton(onPressed: () {
                                Get.to(LoginScreen());

                              }, child: const Text(""
                                  "Login Here"))
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },),
    );
  }
}
