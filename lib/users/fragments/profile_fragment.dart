import 'package:flutter/material.dart';
import 'package:shop_app/users/authentication/login_screen.dart';
import 'package:shop_app/users/userPreferences/current_user.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/userPreferences/user_references.dart';
class ProfileFragments extends StatelessWidget {
  
  final CurrentUser _currentUser = Get.put(CurrentUser());

  signOutUser() async{
    var resultResponse=await Get.dialog(
       AlertDialog(
        backgroundColor: Colors.grey,
        title: Text("Logout", style:  TextStyle(
          fontSize: 18,fontWeight: FontWeight.bold
        ),),
        content: Text("Are you sure?\n you want to logout from app?"),
        actions: [
          TextButton(onPressed: (){
            Get.back();
          }, child: Text("No",style: TextStyle(color: Colors.black),)
          )
        ,
         TextButton(onPressed: (){
           Get.back(result: "loggedOut");
         }, child: Text("Yes",style: TextStyle(color: Colors.black),)
         )
         ],
      )
    );

    if(resultResponse == "loggedOut"){
      //delete-remove the user data
      RememberUserPrefs.removeUserInfo().then((value) {Get.off(LoginScreen());});
    }
  }

  Widget userInfoItemProfile(IconData iconData, String userData){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          SizedBox(width: 16,),
          Text(userData,style: TextStyle(fontSize: 15),)
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(32),
      children: [

        Center(
          child: Image.asset("assets/images/man.png",width: 240,),
        ),

        SizedBox(height: 20,),

        userInfoItemProfile(Icons.person, _currentUser.user.user_name),
        SizedBox(height: 20,),

        userInfoItemProfile(Icons.email, _currentUser.user.user_email),
        SizedBox(height: 20,),

        Center(
          child: Material(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: (){
                signOutUser();
              },
              borderRadius: BorderRadius.circular(32),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 12),
                child: Text("Sign out",style: TextStyle(color: Colors.white,fontSize: 16),),
              ),
            ),
          ),
        )
      ],
    );
  }
}
