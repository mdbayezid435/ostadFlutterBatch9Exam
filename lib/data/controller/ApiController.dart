import 'dart:convert';
import 'package:crud_project_class/data/DataModel/ProductModel.dart';
import 'package:crud_project_class/data/Utility/urls.dart';
import 'package:crud_project_class/Presentation/style/style.dart';
import 'package:http/http.dart' as http;

class ApiController {
  bool isLoading = false;
  // ignore: non_constant_identifier_names
  List<Data> Product = [];
  Future<void> fatchProduct() async {
    final response = await http.get(Uri.parse(Urls.readProduct));
    var responseStatus = response.statusCode;
    var responseBody = jsonDecode(response.body);
    if (responseStatus == 200 && responseBody['status'] == "success") {
      ProductModel productModel = ProductModel.fromJson(responseBody);
      successToast("api succesfully loaded");
      Product = productModel.data ?? [];
      isLoading = false;
    } else {
      errorToast("api is not loaded");
    }
  }

  Future<void> createProduct(String productName, String img, int qty,
      int unitPrice, int totalPrice) async {
    final response = await http.post(Uri.parse(Urls.createProduct),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ProductName": productName,
          "ProductCode": DateTime.now().millisecondsSinceEpoch,
          "Img": img,
          "Qty": qty,
          "UnitPrice": unitPrice,
          "TotalPrice": totalPrice
        }));
    var responseStatus = response.statusCode;
    var responseBody = jsonDecode(response.body);
    if (responseStatus == 200 && responseBody['status'] == "success") {
      successToast("your data successfully saved!");
    } else {
      errorToast("api is not loaded");
    }
  }

  Future<void> updateProduct(String id, String productName, String img, int qty,
      int unitPrice, int totalPrice) async {
    final response = await http.post(Uri.parse(Urls.updateProduct(id)),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ProductName": productName,
          "ProductCode": DateTime.now().millisecondsSinceEpoch,
          "Img": img,
          "Qty": qty,
          "UnitPrice": unitPrice,
          "TotalPrice": totalPrice
        }));
    var responseStatus = response.statusCode;
    var responseBody = jsonDecode(response.body);
    if (responseStatus == 200 && responseBody['status'] == "success") {
      successToast("your data successfully updated!");
    } else {
      errorToast("api is not loaded");
    }
  }

  Future<void> deleteProduct(id) async {
    final response = await http.get(Uri.parse(Urls.deleteProduct(id)));
    var responseStatus = response.statusCode;
    var responseBody = jsonDecode(response.body);
    if (responseStatus == 200 && responseBody['status'] == "success") {
      successToast("your data successfully deleted");
    } else {
      errorToast("your data not deleted");
    }
  }

  Future<bool> deleteFunction(id) async {
    final response = await http.get(Uri.parse(Urls.deleteProduct(id)));
    var responseStatus = response.statusCode;
    var responseBody = jsonDecode(response.body);
    if (responseStatus == 200 && responseBody['status'] == "success") {
      successToast("your data successfully deleted");
      return true;
    } else {
      errorToast("your data not deleted");
      return false;
    }
  }
}
