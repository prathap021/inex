// ignore_for_file: avoid_print, prefer_const_constructors, use_build_context_synchronously, file_names, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inex/common/Colors.dart';
import 'package:inex/common/SizeConfig.dart';
import 'package:inex/common/sphelper.dart';
import 'package:inex/db/dbhelper.dart';
import 'package:inex/model/dbhelper.dart';
import 'package:inex/view/homepage.dart';

import 'package:intl/intl.dart';


class CusBottomSheet extends StatefulWidget {
  Expense? expense;
  bool? update;
  bool? updateinorex;

  CusBottomSheet({
    super.key,
    this.update = false,
    this.updateinorex=false,
    this.expense,
  });

  @override
  State<CusBottomSheet> createState() => _CusBottomSheetState();
}

class _CusBottomSheetState extends State<CusBottomSheet> {
  final namecontroller = TextEditingController();
  final amtcontroller = TextEditingController();
  final descontroller = TextEditingController();
  var expo = Expense();
  var mapdata;
  List<Expense> updateExpense = [];
  int id = 0;
  bool income = false;

  String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

  saveExpo() async {
    setState(() {
      id++;
    });
    await SPHelper().addIntToSF("Id", id);
    expo.id = id;
    expo.date = date;
    expo.name = namecontroller.text;
    expo.description = descontroller.text;
    expo.type = income ? "Income" : "Expense";
    expo.expense = income ? " " : amtcontroller.text;
    expo.income = income ? amtcontroller.text : " ";
    //expo.income = "1000";
  }

  updateExpo() async {
    print(mapdata);
    expo.type = mapdata["type"];
    expo.income = mapdata["income"];
    expo.id = mapdata["id"];
    expo.date = mapdata["date"];
    expo.name = namecontroller.text;
    expo.expense = income ? "0" : amtcontroller.text;
    expo.income = income ? amtcontroller.text : "0";
    expo.description = descontroller.text;
  }

  @override
  void initState() {
    super.initState();
    widget.update! ? updatdata() : readdata();
  }

  void readdata() async {
    setState(() {});
    id = await SPHelper().getIntValuesSF("Id") ?? 0;
  }

  void updatdata() {
    print(widget.update);
    setState(() {});
    mapdata = widget.expense!.toJson();
    print(mapdata["name"]);
    namecontroller.text = mapdata["name"];
    amtcontroller.text = mapdata["expense"];
    descontroller.text = mapdata["description"];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // You can wrap this Column with Padding of 8.0 for better design
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image(image: AssetImage("Assets/account.png")),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                Expanded(child: TextField(
                  controller: namecontroller,

                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter Name',

                    hintStyle: TextStyle(fontSize: 16),

                  ),
                )
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image(image: AssetImage("Assets/wallet.png")),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                Expanded(child: TextField(
                  controller: amtcontroller,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    // for below version 2 use this
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                    FilteringTextInputFormatter.digitsOnly

                  ],


                  decoration: InputDecoration(
                    hintText: 'Enter Amount',

                    hintStyle: TextStyle(fontSize: 16),

                  ),
                )
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              ],
            ),

            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image(image: AssetImage("Assets/project-status.png")),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                Expanded(child: TextField(
                    controller: descontroller,
                    maxLines: 2,
                    decoration:  InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200]
                    )
                )
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible:true,
                  child: SizedBox(
                    width: 100,
                    child: MaterialButton(
                      onPressed: widget.update!
                          ? () async {
                        print("Db clicked");
                        var s = await DBProvider.db.deleteAllDenomination();
                        print(s);
                        Navigator.of(context).pop();
                        InEx.globalKey.currentState!.totalamount();

                        await SPHelper().removeValues("Id");
                      }
                          : () async {
                        print("Db clicked");
                        await saveExpo();
                        var i = await DBProvider.db.createDenomination(expo);
                        print(i);
                        Navigator.of(context).pop();
                        InEx.globalKey.currentState!.totalamount();
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          /* gradient: LinearGradient(colors: [
     Colors.green,Colors.green
    ]
    ),*/
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'delete',
                            textAlign: TextAlign.center,style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),


                    ),
                  ),
                ),
                SizedBox(width: 30,),
                Visibility(
                  visible: true,
                  child: SizedBox(
                    width: 100,
                    child: MaterialButton(
                      onPressed: widget.update!
                          ? () async {
                        await updateExpo();
                        await DBProvider.db.updatePerson(expo);
                        Navigator.of(context).pop();
                        InEx.globalKey.currentState!.totalamount();
                      }
                          : () async {
                        print("Db clicked");
                        await saveExpo();
                        var i = await DBProvider.db.createDenomination(expo);
                        print(i);
                        Navigator.of(context).pop();
                        InEx.globalKey.currentState!.totalamount();
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          /* gradient: LinearGradient(colors: [
     Colors.green,Colors.green
    ]
    ),*/
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'Save',
                            textAlign: TextAlign.center,style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),


                    ),
                  ),
                ),

                Visibility(
                  visible:false,
                  child: SizedBox(
                    width: 150,
                    child: MaterialButton(
                      onPressed: widget.update!
                          ? () async {
                        await updateExpo();
                        await DBProvider.db.updatePerson(expo);
                        Navigator.of(context).pop();
                        InEx.globalKey.currentState!.totalamount();
                      }
                          : () async {
                        print("Db clicked");
                        await saveExpo();
                        var i = await DBProvider.db.createDenomination(expo);
                        print(i);
                        Navigator.of(context).pop();
                        InEx.globalKey.currentState!.totalamount();
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          color: Colors.orangeAccent,
                          /* gradient: LinearGradient(colors: [
     Colors.green,Colors.green
    ]
    ),*/
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'update',
                            textAlign: TextAlign.center,style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),


                    ),
                  ),
                ),




              ],
            ),
            SizedBox(height: 20,),


          ],
        )
    );


  }
}
