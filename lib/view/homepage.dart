// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, await_only_futures, prefer_final_fields, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inex/db/dbhelper.dart';
import 'package:inex/model/dbhelper.dart';

import 'package:inex/widget/bottomSheet.dart';
import 'package:intl/intl.dart';

class InEx extends StatefulWidget {
  static final GlobalKey<_InExState> globalKey = GlobalKey();
  InEx({Key? key}) : super(key: globalKey);

  @override
  State<InEx> createState() => _InExState();
}

class _InExState extends State<InEx> with TickerProviderStateMixin {
  TabController? tabController;
  bool _showFab = true;
  bool dstatus = false;
  int income = 100;
  bool datais = false;
  bool tabindex = false;

  int apitotamt = 0;
  int totexpo = 0;
  int tablength = 2;
  List<Expense> _income = [];
  List<Expense> _expenses = [];
  var info;

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    totalamount();
    tabController = TabController(
      initialIndex: 0,
      length: tablength,
      vsync: this,
    );

  }


  totalamount() async {
    _income.clear();
    _expenses.clear();
    setState(() {
      datais = false;
    });
    await DBProvider.db.getAllDenomination().then(((value) {
      setState(() {
        //_income = value;
      });
      for (var element in value) {
        print(element.type);
        if (element.type == "Income") {
          _income.add(element);
        } else {
          _expenses.add(element);
        }
      }
    }));
    Timer(Duration(seconds: 1), () {
      setState(() {});
      datais = true;
    });

    List<int> totamt = [];
    List<int> toexpo = [];
    for (var amt in _income) {
      setState(() {});
      totamt.add(int.parse(amt.income!));
    }
    for (var amt in _expenses) {
      setState(() {});
      toexpo.add(int.parse(amt.expense!));
    }

    setState(() {
      apitotamt =
          totamt.fold(0, (previousValue, element) => previousValue + element);
      totexpo =
          toexpo.fold(0, (previousValue, element) => previousValue + element);
    });


    setState(() {});
  }
  changetap(int Index){
    setState(() {
      tabController!.animateTo(Index,duration: Duration(microseconds: 300),curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    return DefaultTabController(
      initialIndex: 0,
      length: tablength,
      child: SafeArea(
        child: Scaffold(
            backgroundColor:  Colors.cyan,
            floatingActionButton: AnimatedSlide(
              duration: duration,
              offset: _showFab ? Offset.zero : Offset(0, 2),
              child: AnimatedOpacity(
                duration: duration,
                opacity: _showFab ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: FloatingActionButton(
                    backgroundColor: Colors.cyan,
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                    onPressed: () {

                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return CusBottomSheet(

                          );
                        },
                      );

                    },
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  final ScrollDirection direction = notification.direction;
                  setState(() {
                    if (direction == ScrollDirection.reverse) {
                      _showFab = false;
                    } else if (direction == ScrollDirection.forward) {
                      _showFab = true;
                    }
                  });
                  return true;
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ("₹\t${apitotamt - totexpo}").toString(),
                                  style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))),
                      Container(
                        // height: 100,
                        // color: Colors.white,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("INCOME",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                                Text("EXPENSE",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),

                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("₹\t$apitotamt",style: TextStyle(fontSize: 20),),
                                Text("₹\t$totexpo",style: TextStyle(fontSize: 20),),

                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50,),

                      Container(
                        height: 500,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: TabBar(
                                  controller: tabController,
                                  isScrollable: true,
                                  indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(width: 1.0),
                                      insets: EdgeInsets.symmetric(
                                          horizontal: 20.0)),
                                  unselectedLabelColor: Colors.grey,
                                  labelColor: Colors.black,
                                  tabs: [
                                    Tab(
                                      text: "Income",
                                    ),
                                    Tab(
                                      text: "Expense",
                                    )
                                  ]),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            Expanded(
                              child: TabBarView(
                                  controller: tabController,
                                  children: [inList(), outList()]),
                            )
                          ],
                        ),
                      ),
                    ]))),
      ),
    );
  }

  Widget outList() {
    return _expenses.isNotEmpty
        ? datais
            ? ListView.builder(
                itemCount: _expenses.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (
                  context,
                  index,
                ) {
                  List reverse_expenses=_expenses.reversed.toList();
                  // print(reverse_expenses);
                  DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
                      .parse(reverse_expenses[index].date!);

                  var month = DateFormat.MMMM().format(tempDate);

                  return SizedBox(
                    // height: 85,
                    child: GestureDetector(
                      onDoubleTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: true,
                            context: context,
                            builder: (context) {
                              return CusBottomSheet(
                                expense: reverse_expenses[index],
                                update: true,
                              );
                            });
                      },
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 22,bottom: 5),
                              child: Text(month.toString() +
                                  "\t" +
                                  tempDate.day.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            ),
                          ),
                          ListTile(
                            onLongPress: () async {
                              setState(() {});
                              print(
                                  "id ------>" + reverse_expenses[index].id.toString());
                              await DBProvider.db.deletePersonWithId(
                                  int.parse(reverse_expenses[index].id.toString()));

                              reverse_expenses.removeAt(index);
                              await totalamount();
                              await InEx.globalKey.currentState!.totalamount();
                            },
                            leading: CircleAvatar(radius: 30,backgroundColor: Colors.cyan,
                                child: Text(reverse_expenses[index].name![0].toUpperCase(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)),
                            // leading: Text(month.toString() +
                            //     "\t" +
                            //     tempDate.day.toString()),
                            title: Text(reverse_expenses[index].name!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            subtitle: Text(reverse_expenses[index].description!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            trailing:
                                Text("₹\t"+reverse_expenses[index].expense!.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            : Center(
                child: CircularProgressIndicator(),
              )
        : Center(
            child: Text("No Expenses"),
          );
  }

  Widget inList() {
    return _income.isNotEmpty
        ? datais
            ? ListView.builder(
                itemCount: _income.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (
                  context,
                  index,
                ) {
                  List reversed_income=_income.reversed.toList();
                  DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
                      .parse(reversed_income[index].date!);

                  var month = DateFormat.MMMM().format(tempDate);

                  return SizedBox(
                      // height: 130,
                      child: GestureDetector(
                        onLongPress: () async {
                          setState(() {});
                          print("id ------>" + reversed_income[index].id.toString());
                          await DBProvider.db.deletePersonWithId(
                              int.parse(reversed_income[index].id.toString()));
                          reversed_income.removeAt(index);
                          await totalamount();
                          await InEx.globalKey.currentState!.totalamount();
                        },
                        onDoubleTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: true,
                              context: context,
                              builder: (context) {
                                return CusBottomSheet(
                                  updateinorex: true,
                                  expense: reversed_income[index],
                                  update: true,
                                );
                              });
                        },
                        child: Column(
                          children: [
                            
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 22,bottom: 5),
                                child: Text(month.toString() +
                                "\t\t\t" +
                                tempDate.day.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              ),
                            ),
                            ListTile(
                              leading: CircleAvatar(radius: 30,backgroundColor: Colors.cyan,
                              child: Text(reversed_income[index].name![0].toUpperCase(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)),
                              title: Text(reversed_income[index].name!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              subtitle: Text(reversed_income[index].description!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              trailing: Text("₹\t"+reversed_income[index].income!.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ));
                })
            : Center(
                child: CircularProgressIndicator()
              )
        : Center(
            child: Text("Not Income"),
          );
  }
}
