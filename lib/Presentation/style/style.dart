import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crud_project_class/const/colors.dart';

// ignore: non_constant_identifier_names
InputDecoration AppInputDecoration(labelText) {
  return InputDecoration(
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.colorgreen, width: 1)),
      fillColor: MyColors.colorwhite,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: MyColors.colorwhite, width: 0),
      ),
      border: const OutlineInputBorder(),
      labelText: labelText);
}

// ignore: non_constant_identifier_names
DecoratedBox AppDropDwonStyle(child) {
  return DecoratedBox(
    decoration: BoxDecoration(
      color: MyColors.colorwhite,
      border: Border.all(color: MyColors.colorwhite, width: 1),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: child,
    ),
  );
}

// ignore: non_constant_identifier_names
ButtonStyle AppButtonStyle() {
  return ElevatedButton.styleFrom(
      elevation: 1,
      padding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)));
}

// ignore: non_constant_identifier_names
Ink SuccesButtonStyle(ButtonText) {
  return Ink(
    decoration: BoxDecoration(
        color: MyColors.colorgreen, borderRadius: BorderRadius.circular(6)),
    child: Container(
      height: 45,
      alignment: Alignment.center,
      child: Text(
        ButtonText,
        style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: MyColors.colorwhite),
      ),
    ),
  );
}

void errorToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: MyColors.colorRed,
      textColor: MyColors.colorwhite,
      fontSize: 16.0);
}

void successToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: MyColors.colorgreen,
      textColor: MyColors.colorwhite,
      fontSize: 16.0);
}

SliverGridDelegateWithFixedCrossAxisCount productGridViewStyle() {
  return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, mainAxisSpacing: 2, mainAxisExtent: 250);
}
