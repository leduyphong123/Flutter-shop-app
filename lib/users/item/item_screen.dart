import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/controllers/item_controller.dart';
import 'package:shop_app/users/model/shop.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ItemScreen extends StatefulWidget {
  final Shop? itemInfo;

  const ItemScreen({ this.itemInfo});



  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {

  final itemDetailsController = Get.put(ItemController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //item image
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage(
                "assets/images/place_holder.png"),
            image: NetworkImage(widget.itemInfo!.image!),
            imageErrorBuilder:
                (context, error, stackTraceError) {
              return const Center(
                child: Icon(Icons.broken_image_outlined),
              );
            },
          ),

          //item infomartion
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),
        ],
      ),
    );
  }

  Widget itemInfoWidget() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height*0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: const  BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0,-3),
            blurRadius: 6,
            color: Colors.purpleAccent,
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18,),
            Center(
              child: Container(
                height: 8,
                  width: 140,
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(30),

                ),
              ),
            ),
            const SizedBox(height: 18,),

            //name
            Text(
              widget.itemInfo!.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 18,),

            //rating +rating num
            //tags
            //price
            //item counter
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //rating +rating num
                //tags
                //price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      //rating +rating num
                      Row(
                        children: [
                          //rating
                          RatingBar.builder(
                            initialRating: widget.itemInfo!.rating!,
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
                          const SizedBox(width: 8,),
                          //rating num
                          Text(
                            "(" +
                                widget.itemInfo!.rating.toString() +
                                ")",
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      ),

                      //tags
                      const SizedBox(height: 16,),
                      Text(
                        widget.itemInfo!.tags!.toString().replaceAll("[", "").replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey
                        ),

                      ),

                      //price
                      const SizedBox(height: 16,),
                      Text(
                        "\$"+ widget.itemInfo!.price!.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold
                        ),

                      ),

                    ],
                  ),
                ),

                //quantity item counter
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        itemDetailsController.setQuantityItem(itemDetailsController.quantity +1);
                      },
                      icon: Icon(Icons.add_circle_outline,color: Colors.white,),
                    ),
                    Text(
                      itemDetailsController.quantity.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        if(itemDetailsController.quantity-1 >=1){
                          itemDetailsController.setQuantityItem(itemDetailsController.quantity -1);
                        }
                        else{
                          Fluttertoast.showToast(msg: "quantity > 1");
                        }
                      },
                      icon: Icon(Icons.remove_circle_outline,color: Colors.white,),
                    ),
                  ],
                ))

              ],
            ),


            //size
            const Text(
              "size:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 8,),

            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo!.sizes!.length, (index) {
                return Obx(() => GestureDetector(
                  onTap: (){
                    itemDetailsController.setSizeItem(index);
                  },
                  child: Container(
                    height: 35,
                    width: 60,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2,color: itemDetailsController.size==index ? Colors.white : Colors.grey),
                      color: itemDetailsController.size == index ? Colors.purpleAccent.withOpacity(0.2):
                          Colors.black
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.itemInfo!.sizes![index].replaceAll("[", "").replaceAll("]", ""),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700]
                      ),
                    ),
                  ),
                ));
              }),
            ),
            const SizedBox(height: 20,),


            //color
            const Text(
              "color:",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 8,),

            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo!.colors!.length, (index) {
                return Obx(() => GestureDetector(
                  onTap: (){
                    itemDetailsController.setColorItem(index);
                  },
                  child: Container(
                    height: 35,
                    width: 60,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color: itemDetailsController.color==index ? Colors.white : Colors.grey),
                        color: itemDetailsController.color == index ? Colors.purpleAccent.withOpacity(0.2):
                        Colors.black
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.itemInfo!.colors![index].replaceAll("[", "").replaceAll("]", ""),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700]
                      ),
                    ),
                  ),
                ));
              }),
            ),

            const SizedBox(height: 20,),
            //description
            const Text(
              "Description:",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              widget.itemInfo!.description!,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.grey
              ),
            ),

            const SizedBox(height: 20,),

            //add to card button
            Material(
              elevation: 4,
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {

                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Text("Add to cart",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),),
                ),
              ),
            ),
            const SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}
