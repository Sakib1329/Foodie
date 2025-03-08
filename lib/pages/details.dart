import 'package:flutter/material.dart';
import 'package:foodie/servics/database.dart';
import 'package:foodie/servics/sr.dart';
import 'package:foodie/wid/w_S.dart';

class Details extends StatefulWidget {


  String image, name, detail, price;
  Details({required this.detail,required this.name,required this.image,required this.price});





  @override
  State<Details> createState() => _DetailsState();
}



class _DetailsState extends State<Details> {


  int a = 1,total=0;
  String? id;
  getthesharedpref()async{
    id=await SharedPreferenceHelper().getUserId();
    setState(() {

    });
  }
ontheload()async{
    await getthesharedpref();
    setState(() {

    });
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ontheload();
    total =int.parse(widget.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.black,
                )),
            Image.network(
              widget.image,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),

                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (a > 1) {
                      --a;
                      total=total-int.parse(widget.price);
                    }
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Text(
                  a.toString(),
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    ++a;
                    total=total+int.parse(widget.price);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20.0,),
            Text(
              widget.detail,maxLines: 4,
              style: AppWidget.LightTextFeildStyle(),
            ),
            const SizedBox(height: 30.0,),
            Row(children: [
              Text("Delivery Time", style: AppWidget.semiBoldTextFeildStyle(),),
              const SizedBox(width: 25.0,),
              const Icon(Icons.alarm, color: Colors.black54,),
              const SizedBox(width: 5.0,),
              Text("30 min", style: AppWidget.semiBoldTextFeildStyle(),)
            ],),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Price", style: AppWidget.semiBoldTextFeildStyle(),),
                      Text("৳"+total.toString(), style: AppWidget.HeadlineTextFeildStyle(),)
                    ],),
                  GestureDetector(
                    onTap: ()async{
                      Map<String,dynamic> addFoodtoCart ={
                        "Name":widget.name,
                        "Quantity":a.toString(),
                        "Price":total.toString(),
                        "Image":widget.image
                      };
                      await DatabaseMethods().addFoodtoCart(addFoodtoCart, id!);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.orangeAccent,
                          content: Text(
                            "Food has added to cart",
                            style: TextStyle(fontSize: 18.0),
                          )));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Add to cart", style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'Poppins'),),
                          const SizedBox(width: 30.0,),
                          Container(

                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.grey, borderRadius: BorderRadius.circular(8)
                            ),
                            child: const Icon(Icons.shopping_cart_outlined, color: Colors.white,),
                          ),
                          const SizedBox(width: 10.0,),
                        ],),
                    ),
                  )
                ],),
            )
          ],
        ),
      ),
    );
  }
}
