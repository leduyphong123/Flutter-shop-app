import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app/api_connection/api_connection.dart';
import 'package:shop_app/users/item/item_screen.dart';

import '../model/shop.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeFragments extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  Future<List<Shop>> getTrendingShopItems() async {
    List<Shop> trendingShopItemsList = [];

    try {
      var res = await http.post(
        Uri.parse(API.getTrendingMostPopularShop),
      );
      if (res.statusCode == 200) {
        var resBodyOfTrending = jsonDecode(res.body);
        if (resBodyOfTrending["success"] == true) {
          (resBodyOfTrending["itemData"] as List).forEach((element) {
            trendingShopItemsList.add(Shop.fromJson(element));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (e) {
      print(e);
    }

    return trendingShopItemsList;
  }

  Future<List<Shop>> getAllItemsShop() async {
    List<Shop> allShopItemsList = [];

    try {
      var res = await http.post(
        Uri.parse(API.getAllItemShop),
      );
      if (res.statusCode == 200) {
        var resBodyOfTrending = jsonDecode(res.body);
        if (resBodyOfTrending["success"] == true) {
          (resBodyOfTrending["itemData"] as List).forEach((element) {
            allShopItemsList.add(Shop.fromJson(element));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (e) {
      print(e);
    }

    return allShopItemsList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          //search bar widget
          showSearchBarWidget(),

          const SizedBox(
            height: 26,
          ),

          //trending-poppular items
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Trending",
              style: TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          trendingMostPopularShopItemWidget(context),

          const SizedBox(
            height: 24,
          ),

          //all new collects/items
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "New Collections",
              style: TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),

          allNewItems(context),
        ],
      ),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.purpleAccent,
            ),
          ),
          hintText: "Search best shop here...",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.purpleAccent,
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.purpleAccent),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.purpleAccent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.green),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }

  Widget trendingMostPopularShopItemWidget(context) {
    return FutureBuilder(
      future: getTrendingShopItems(),
      builder: (context, AsyncSnapshot<List<Shop>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text("No Trending item found"),
          );
        }
        if (dataSnapShot.data!.length > 0) {
          return Container(
            height: 260,
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Shop eachShopItemData = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    Get.to(ItemScreen(itemInfo: eachShopItemData));
                  },
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.fromLTRB(16, 10,
                        index == dataSnapShot.data!.length - 1 ? 16 : 0, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 6,
                            color: Colors.grey),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22)),
                          child: FadeInImage(
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage(
                                "assets/images/place_holder.png"),
                            image: NetworkImage(eachShopItemData.image!),
                            imageErrorBuilder:
                                (context, error, stackTraceError) {
                              return const Center(
                                child: Icon(Icons.broken_image_outlined),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //name & price item
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      eachShopItemData.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    eachShopItemData.price.toString(),
                                    style: const TextStyle(
                                        color: Colors.purpleAccent,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),

                              const SizedBox(
                                height: 8,
                              ),
                              //rating stars & rating numbers
                              Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: eachShopItemData.rating!,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (updateRating) {},
                                    ignoreGestures: true,
                                    unratedColor: Colors.grey,
                                    itemSize: 20,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "(" +
                                        eachShopItemData.rating.toString() +
                                        ")",
                                    style: const TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }

  Widget allNewItems(context) {
    return FutureBuilder(
        future: getAllItemsShop(),
        builder: (context, AsyncSnapshot<List<Shop>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: Text("No all item found"),
            );
          }
          if (dataSnapShot.data!.length > 0) {
            return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Shop eachShopItem = dataSnapShot.data![index];

                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 16,
                        index == dataSnapShot.data!.length - 1 ? 16 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 6,
                            color: Colors.white),
                      ],
                    ),
                    child: Row(
                      children: [
                        //name + price
                        //tags
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //name and price
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eachShopItem.name!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 12,right: 12),
                                      child: Text(
                                        "\$"+eachShopItem.price.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.purpleAccent,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16,),
                                Text(
                                  "Tags: \n"+eachShopItem.tags.toString().replaceAll("[", "").replaceAll("]", ""),// thay chuoi [ => " rong"
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //image items
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          child: FadeInImage(
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage(
                                "assets/images/place_holder.png"),
                            image: NetworkImage(eachShopItem.image!),
                            imageErrorBuilder:
                                (context, error, stackTraceError) {
                              return const Center(
                                child: Icon(Icons.broken_image_outlined),
                              );
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("Empty, No Data."),
            );
          }
        });
  }
}
