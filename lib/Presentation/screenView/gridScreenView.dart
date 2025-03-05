import 'package:crud_project_class/Presentation/screenView/ListViewScreenView.dart';
import 'package:crud_project_class/Presentation/style/style.dart';
import 'package:crud_project_class/const/colors.dart';
import 'package:crud_project_class/data/controller/ApiController.dart';
import 'package:flutter/material.dart';

class GridScreenView extends StatefulWidget {
  const GridScreenView({super.key});

  @override
  State<GridScreenView> createState() => _GridScreenViewState();
}

class _GridScreenViewState extends State<GridScreenView> {
  //start function
  ApiController apiController = ApiController();
  void productDialog(
      {String? id,
      String? productName,
      String? img,
      int? qty,
      int? unitPrice,
      int? totalPrice}) {
    TextEditingController productNamecontroller = TextEditingController();
    TextEditingController imgcontroller = TextEditingController();
    TextEditingController qtycontroller = TextEditingController();
    TextEditingController unitPricecontroller = TextEditingController();
    TextEditingController totalPricecontroller = TextEditingController();
    productNamecontroller.text = productName ?? "";
    imgcontroller.text = img ?? "";
    // ignore: unnecessary_null_comparison
    //qtycontroller.text = qty.toString();
    qtycontroller.text = qty != null && qty > 0 ? qty.toString() : '';
    unitPricecontroller.text =
        qty != null && qty > 0 ? unitPrice.toString() : '';
    totalPricecontroller.text =
        qty != null && qty > 0 ? totalPrice.toString() : '';

    // unitPricecontroller.text = unitPrice.toString();
    // totalPricecontroller.text = totalPrice.toString();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(id == null ? "Create Product" : "Update product"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: productNamecontroller,
                      keyboardType: TextInputType.text, // Default keyboard
                      decoration: const InputDecoration(
                        labelText: "ProductName",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.text, // Default keyboard
                      controller: imgcontroller,
                      decoration: const InputDecoration(
                        labelText: "Img",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.number, // Default keyboard
                      controller: qtycontroller,
                      decoration: const InputDecoration(
                        labelText: "Product qty",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.phone, // Default keyboard
                      controller: unitPricecontroller,
                      decoration: const InputDecoration(
                        labelText: "UnitPrice",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.phone, // Default keyboard
                      controller: totalPricecontroller,
                      decoration: const InputDecoration(
                        labelText: "TotalPrice",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  setState(() {
                                    apiController.isLoading = true;
                                  });
                                  if (id == null) {
                                    await apiController.createProduct(
                                      productNamecontroller.text,
                                      imgcontroller.text,
                                      int.parse(qtycontroller.text),
                                      int.parse(unitPricecontroller.text),
                                      int.parse(totalPricecontroller.text),
                                    );
                                  } else {
                                    await apiController.updateProduct(
                                      id,
                                      productNamecontroller.text,
                                      imgcontroller.text,
                                      int.parse(qtycontroller.text),
                                      int.parse(unitPricecontroller.text),
                                      int.parse(totalPricecontroller.text),
                                    );
                                  }

                                  fatchData();
                                  setState(() {
                                    apiController.isLoading = false;
                                  });
                                },
                                child: Text(
                                  id == null ? "Add" : "Update",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "cancel",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ))),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  fatchData() async {
    setState(() {
      apiController.isLoading = true;
    });
    await apiController.fatchProduct();
    setState(() {
      apiController.isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fatchData();
    super.initState();
  }

  deleteItem(id) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete !"),
            content: const Text("Are you sure? Want to delete?"),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              OutlinedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      apiController.isLoading = true;
                    });
                    await apiController.deleteFunction(id);
                    await fatchData();
                  },
                  child: const Text("Yes")),
            ],
          );
        });
  }

  // end function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grid view test"),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListViewScreenView()),
                );
              },
              icon: const Text("List view"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: apiController.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await fatchData();
              },
              child: GridView.builder(
                  itemCount: apiController.Product.length,
                  gridDelegate: productGridViewStyle(),
                  itemBuilder: (context, index) {
                    var products = apiController.Product[index];
                    return InkWell(
                      onTap: () {
                        successToast("Grid iteam $index clicked ");
                      },
                      onLongPress: () {
                        deleteItem(products.sId);
                      },
                      child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.all(5),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRect(
                                    child: Container(
                                        height: 140,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: MyColors.colorwhite,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Image.network(
                                          products.img
                                              .toString(), // Your image URL
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            // If the image fails to load, show a placeholder
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[
                                                      300], // Background color for the placeholder
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Center(
                                                child: Icon(
                                                  Icons
                                                      .broken_image, // Icon indicating the image failed to load
                                                  color: Colors.green,
                                                  size: 50,
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                  ),
                                  Text(
                                    products.productName.toString(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "Price:${products.unitPrice!.toDouble()} BDT."),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            productDialog(
                                                id: products.sId,
                                                productName:
                                                    products.productName,
                                                img: products.img,
                                                qty: products.qty,
                                                unitPrice: products.unitPrice,
                                                totalPrice:
                                                    products.totalPrice);
                                          },
                                          icon: const Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            deleteItem(products.sId);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: MyColors.colorRed,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                    );
                  }),
            ),
    );
  }
}
