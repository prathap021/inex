// ignore_for_file: avoid_print, prefer_const_constructors, use_build_context_synchronously, file_names, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:inex/common/sphelper.dart';
import 'package:inex/db/dbhelper.dart';
import 'package:inex/model/dbhelper.dart';
import 'package:inex/view/homepage.dart';

import 'package:intl/intl.dart';

class CusBottomSheet extends StatefulWidget {
  Expense? expense;
  bool? update;

  CusBottomSheet({
    super.key,
    this.update = false,
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
    amtcontroller.text = mapdata["amount"];
    descontroller.text = mapdata["description"];
  }

  @override
  Widget build(BuildContext context) {
    //bottomsheet(context);
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: namecontroller,
              decoration: InputDecoration(
                  hintText: "Name",
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          income = !income;
                        });
                      },
                      icon: Text(income ? "I" : "E"))),
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: amtcontroller,
              decoration: InputDecoration(hintText: "Amount"),
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: descontroller,
              decoration: InputDecoration(hintText: "Description"),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
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
              child: Text(widget.update! ? "update" : "Save")),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                print("Db clicked");
                var s = await DBProvider.db.deleteAllDenomination();
                print(s);
                Navigator.of(context).pop();
                InEx.globalKey.currentState!.totalamount();

                await SPHelper().removeValues("Id");
              },
              child: Text("delete"))
        ],
      ),
    );
  }
}
