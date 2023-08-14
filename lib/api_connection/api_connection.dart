class API {
  static const hostConnect = "http://192.168.1.8/api_shop_app";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostConnectItems = "$hostConnect/items";
  static const hostConnectShop = "$hostConnect/shop";

  //signup user
  static const validateEmail="$hostConnectUser/validate_email.php";
  static const signUp="$hostConnectUser/signup.php";
  static const login="$hostConnectUser/login.php";


  //admin login
  static const adminLogin="$hostConnectAdmin/login.php";

  //item update admin
  static const uploadItem="$hostConnectItems/upload.php";


  //shop
  static const getTrendingMostPopularShop = "$hostConnectShop/trending.php";
  static const getAllItemShop = "$hostConnectShop/all.php";
}