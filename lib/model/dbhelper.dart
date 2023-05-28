// To parse this JSON data, do
//
//     final expense = expenseFromJson(jsonString);

import 'dart:convert';

Expense expenseFromJson(String str) => Expense.fromJson(json.decode(str));

String expenseToJson(Expense data) => json.encode(data.toJson());

class Expense {
  int? id;
  String? date;
  String? name;
  String? income;
  String? expense;
  String? type;
  String? description;

  Expense({
    this.id,
    this.date,
    this.name,
    this.income,
    this.expense,
    this.type,
    this.description,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json["id"],
        date: json["date"],
        name: json["name"],
        income: json["income"],
        expense: json["expense"],
        type: json["type"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "name": name,
        "income": income,
        "expense": expense,
        "type": type,
        "description": description,
      };
}
