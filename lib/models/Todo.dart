import 'dart:ui';

import 'package:flutter/material.dart';

class Todo{
  int _id;
  int get id => this._id;
  set id(int value){
    if(value!=null) this._id = id;
  }

  String _title;
  String get title =>this._title;
  set title(String value){
    if(value.length<=255) this._title = value;
  }

  String _description;
  String get description => this._description;
  set description(String value) {
    if(value.length<=255) this._description = value;
  }

  String _date;
  String get date => this._date;
  set date(String value) {
    this._date = value;
  }

  int _priority;
  int get priority => this._priority;
  set priority(int value){
    if(value>=1 && value<=3) this._priority = value;
  }

  Todo(this._title, this._description, this._date, [this._priority]);
  Todo.withId(this._id, this._title, this._description, this._date, [this._priority]);
  Todo.fromObject(dynamic o){
    this._title = o['title'];
    this._description = o['description'];
    this._date = o['date'];
    this._priority = o['priority'];
    if(o['id']!=null) this._id = o['id'];
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['title'] = this._title;
    map['description'] = this._description;
    map['date'] = this._date;
    map['priority'] = this._priority;
    if(this._id!=null) map['id'] = this._id;
    return map;
  }

  Color getColorPriority(){
    switch(priority){
      case 1: return Colors.red;break;
      case 2: return Colors.blue;break;
      case 3: return Colors.green;break;
      default: return Colors.black;break;
    }
  }

}