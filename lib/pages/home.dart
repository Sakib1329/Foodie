import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:foodie/pages/details.dart';
import 'package:foodie/servics/database.dart';
import 'package:foodie/wid/w_S.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false, pizza = false, salad = false, burger = false;

  Stream? fooditemStream;
  ontheload()async{
    fooditemStream=await DatabaseMethods().getFoodItem("Pizza") ;
    setState(() {

    });
  }
  @override
  void initState() {
    ontheload();
    super.initState();
  }
  Widget allItemsVertically(){
    return StreamBuilder(stream: fooditemStream,builder: (context,AsyncSnapshot snapshot){
      return  snapshot.hasData? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index){
            DocumentSnapshot ds=snapshot.data.docs[index];
            return   GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>  Details(detail: ds["Details"],name: ds["Name"],price: ds["Price"],image: ds["Images"],)));
              },
              
              child: Container(
                margin: const EdgeInsets.only(right: 20.0,bottom: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),

                  child: Container(
                    
                    padding: const EdgeInsets.all(5),
                    
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            ds["Images"],
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 20.0,),
                        Column(children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: Text(ds["Name"], style: AppWidget.semiBoldTextFeildStyle(),)),
                          const SizedBox(height: 5.0,),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: Text("Honey goot cheese", style: AppWidget.LightTextFeildStyle(),)),
                          const SizedBox(height: 5.0,),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: Text("৳"+ds["Price"], style: AppWidget.semiBoldTextFeildStyle(),))
                        ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }):const CircularProgressIndicator();
    });
  }











  Widget allItems(){
    return StreamBuilder(stream: fooditemStream,builder: (context,AsyncSnapshot snapshot){
      return  snapshot.hasData? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            DocumentSnapshot ds=snapshot.data.docs[index];
            return   GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>  Details(detail: ds["Details"],name: ds["Name"],price: ds["Price"],image: ds["Images"],)));
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              ds["Images"],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(ds["Name"],
                              style: AppWidget.semiBoldTextFeildStyle()),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text("Fresh and Healthy",
                              style: AppWidget.LightTextFeildStyle()),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "৳"+ds["Price"],
                            style: AppWidget.semiBoldTextFeildStyle(),
                          )
                        ]),
                  ),
                ),
              ),
            );
          }):const CircularProgressIndicator();
    });
  }










  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Welcome to Quick Foodie", style: AppWidget.boldTextFeildStyle()),
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  )
                ],
              ),




              const SizedBox(
                height: 20.0,
              ),
              Text("Delicious Food", style: AppWidget.HeadlineTextFeildStyle()),
              Text("Discover and Get Great Food",
                  style: AppWidget.LightTextFeildStyle()),
              const SizedBox(
                height: 20.0,
              ),
              Container(margin: const EdgeInsets.only(right: 20.0), child: showItem()),
              const SizedBox(
                height: 30.0,
              ),
            Container(
                height: 280,
                child: allItems()),
              const SizedBox(
                height: 30.0,
              ),
              
              

            allItemsVertically(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async{
            icecream = true;
            pizza = false;
            salad = false;
            burger = false;
            fooditemStream=await DatabaseMethods().getFoodItem("Ice-cream");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: icecream ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "images/ice-cream.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: icecream ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            icecream = false;
            pizza = true;
            salad = false;
            burger = false;
            fooditemStream=await DatabaseMethods().getFoodItem("Pizza");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: pizza ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "images/pizza.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: pizza ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            icecream = false;
            pizza = false;
            salad = true;
            burger = false;
            fooditemStream=await DatabaseMethods().getFoodItem("Salad");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: salad ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "images/salad.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: salad ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            icecream = false;
            pizza = false;
            salad = false;
            burger = true;
            fooditemStream=await DatabaseMethods().getFoodItem("Burger");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: burger ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "images/burger.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: burger ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
