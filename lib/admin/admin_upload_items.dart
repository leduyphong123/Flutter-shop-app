import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shop_app/admin/admin_login.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/api_connection/api_connection.dart';


class AdminUploadItemsScreen extends StatefulWidget {
  const AdminUploadItemsScreen({Key? key}) : super(key: key);

  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? picketImageXFile;

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var sizesController = TextEditingController();
  var colorsController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";



  //default Screen mehtods
  captureImageWithPhoneCamera() async {
    picketImageXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    setState(() => picketImageXFile);
  }

  pickImageFromPhoneGallery() async {
    picketImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(() => picketImageXFile);
  }

  //hop thoai
  showDialogBoxForImagePickingAndCapturing() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black,
            title: const Text(
              "Item Image",
              style: TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  captureImageWithPhoneCamera();
                },
                child: const Text(
                  "Capture with Phone Camera",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImageFromPhoneGallery();
                },
                child: const Text(
                  "Pick Image From Phone Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
  }

  //upload items form Screen methos
  uploadItemsImage() async{
    var resquestImagurApi = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imgur.com/3/image")
    );

    String imageName=DateTime.now().millisecondsSinceEpoch.toString();
    resquestImagurApi.fields['title']=imageName;
    resquestImagurApi.headers['Authorization']= "Client-ID " + "dd547d1c409513c";

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      picketImageXFile!.path,
      filename: imageName,
    );
    resquestImagurApi.files.add(imageFile);
    var responseFromImgurApi = await resquestImagurApi.send();
    var responseDataImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataImgurApi);

    print("result :: ");
    print(resultFromImgurApi);
    Map<String,dynamic> jsonRes =json.decode(resultFromImgurApi);
    imageLink =(jsonRes["data"]["link"]).toString();
    String deleteHash = (jsonRes["data"]["deletehash"]).toString();
    saveItemsInfoDatabase();
  }

  saveItemsInfoDatabase() async{
    List<String> tagsList = tagsController.text.split(',');//them dau phay phan biet cac loai mau hoac san pham
    List<String> sizedList = sizesController.text.split(',');
    List<String> colorList = colorsController.text.split(',');
   try{

     var res= await http.post(Uri.parse(API.uploadItem),
     body: {
       "item_id": '1',
       "name": nameController.text.trim().toString(),
       "rating": ratingController.text.trim().toString(),
       "tags": tagsList.toString(),
       "price": priceController.text.trim().toString(),
       "sizes": sizedList.toString(),
       "colors": colorList.toString(),
       "description": descriptionController.text.trim().toString(),
       "image": imageLink
     }
     );
     if (res.statusCode == 200) {
       var createProductTable = jsonDecode(res.body);
       if (createProductTable["success"]) {
         Fluttertoast.showToast(msg: "crate item success");
         setState(() {
           picketImageXFile=null;
           nameController.clear();
           tagsController.clear();
           ratingController.clear();
           priceController.clear();
           sizesController.clear();
           colorsController.clear();
           descriptionController.clear();
         });
         Get.to(AdminUploadItemsScreen());
       } else {
         Fluttertoast.showToast(msg: "erros item");
       }
     }
   }catch(e){
     print(e);
   }
  }



  Widget uploadItemFromScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.black54, Colors.deepPurple])),
        ),
        automaticallyImplyLeading: false,
        title: const Text("Upload Form"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // Get.to(const AdminLoginScreen());
            setState((){
              picketImageXFile=null;
              nameController.clear();
              tagsController.clear();
              ratingController.clear();
              priceController.clear();
              sizesController.clear();
              colorsController.clear();
              descriptionController.clear();
            });
            Get.to(AdminUploadItemsScreen());
          },
          icon: const Icon(Icons.clear),
        ),
        actions: [
          TextButton(onPressed: () {
            Fluttertoast.showToast(msg: "Uploading now...");

            uploadItemsImage();

          }, child: const Text(
            "Done",
            style: TextStyle(color: Colors.green),
          ))
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: FileImage(File(picketImageXFile!.path)),
              fit: BoxFit.cover,
            )),
          ),

          //upload imtem form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(
                    Radius.circular(60),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(0, -3),
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                child: Column(
                  children: [
                    //email-password-login btn
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          //item name
                          TextFormField(
                            controller: nameController,
                            validator: (val) =>
                                val == "" ? "Please wirte item name" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.title,
                                color: Colors.black,
                              ),
                              hintText: "item name...",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          //item ratings
                          TextFormField(
                            controller: ratingController,
                            validator: (val) =>
                                val == "" ? "Please give item rating" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.rate_review,
                                color: Colors.black,
                              ),
                              hintText: "item rating...",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),
                          //item tags
                          TextFormField(
                            controller: tagsController,
                            validator: (val) =>
                                val == "" ? "Please write item text" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.tag,
                                color: Colors.black,
                              ),
                              hintText: "item text...",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          //item price
                          TextFormField(
                            controller: priceController,
                            validator: (val) =>
                                val == "" ? "Please give item price" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.price_change_outlined,
                                color: Colors.black,
                              ),
                              hintText: "item price...",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          //item sizes
                          TextFormField(
                            controller: sizesController,
                            validator: (val) =>
                                val == "" ? "Please give item sizes" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.picture_in_picture,
                                color: Colors.black,
                              ),
                              hintText: "item sizes...",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          //item colors
                          TextFormField(
                            controller: colorsController,
                            validator: (val) =>
                                val == "" ? "Please give item colors" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.color_lens,
                                color: Colors.black,
                              ),
                              hintText: "item colors...",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          //item descriptions
                          TextFormField(
                            controller: descriptionController,
                            validator: (val) => val == ""
                                ? "Please give item description"
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.description,
                                color: Colors.black,
                              ),
                              hintText: "item descriptions...",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          //button login
                          const SizedBox(
                            height: 18,
                          ),
                          Material(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  Fluttertoast.showToast(msg: "Uploading now...");

                                  uploadItemsImage();
                                }
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 28),
                                child: Text(
                                  "Upload now",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    //i am not an button - button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.black54, Colors.deepPurple]),
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text("Welecom Admin"),
        centerTitle: true,
        leading: TextButton(onPressed: (){Get.to(AdminLoginScreen());}, child: Text("Exit", style: TextStyle(color: Colors.green),)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black54, Colors.deepPurple]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate,
                color: Colors.black54,
                size: 200,
              ),
              Material(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () {
                    showDialogBoxForImagePickingAndCapturing();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                    child: Text(
                      "Add New Item",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return picketImageXFile == null ? defaultScreen() : uploadItemFromScreen();
  }
}
