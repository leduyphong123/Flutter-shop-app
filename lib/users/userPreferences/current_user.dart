import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app/users/model/user.dart';
import 'package:shop_app/users/userPreferences/user_references.dart';
class CurrentUser extends GetxController{
  Rx<User> _currentUser = User(0, '', '', '').obs;
  User get user=>_currentUser.value;

  getUserInfo() async{
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUser();
    _currentUser.value= getUserInfoFromLocalStorage!;
  }
}