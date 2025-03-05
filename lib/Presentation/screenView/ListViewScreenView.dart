import 'package:crud_project_class/data/controller/ApiController.dart';
import 'package:flutter/material.dart';

class ListViewScreenView extends StatefulWidget {
  const ListViewScreenView({super.key});

  @override
  State<ListViewScreenView> createState() => _ListViewScreenViewState();
}

class _ListViewScreenViewState extends State<ListViewScreenView> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crud app"),
        backgroundColor: Colors.amber,
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
              child: ListView.builder(
                  itemCount: apiController.Product.length,
                  itemBuilder: (context, index) {
                    var products = apiController.Product[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction:
                          DismissDirection.endToStart, // Swipe left to dismiss
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),

                      onDismissed: (direction) async {
                        // setState(() {
                        //   apiController.isLoading = true;
                        // });
                        //await apiController.deleteProduct(products.sId);
                        await apiController
                            .deleteFunction(products.sId.toString())
                            .then((value) {
                          if (value) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("your data deleted successfully"),
                              duration: Duration(seconds: 2),
                            ));
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Something wrong"),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        });
                        fatchData();
                        setState(() {
                          apiController.isLoading = false;
                        });
                      },

                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.red,
                            child: Text(products.productName![0]),
                          ),
                          title:
                              Text("Name:${products.productName.toString()}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("code:-${products.productCode}"),
                              const Text("img:- it's null"),
                              Text("qty:-${products.qty}"),
                              Text("unitPrice:-${products.unitPrice}"),
                              Text("totalPrice:-${products.totalPrice}"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    productDialog(
                                        id: products.sId,
                                        productName: products.productName,
                                        img: products.img,
                                        qty: products.qty,
                                        unitPrice: products.unitPrice,
                                        totalPrice: products.totalPrice);
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () async {
                                    // setState(() {
                                    //   apiController.isLoading = true;
                                    // });
                                    //await apiController.deleteProduct(products.sId);
                                    await apiController
                                        .deleteFunction(products.sId.toString())
                                        .then((value) {
                                      if (value) {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "your data deleted successfully"),
                                          duration: Duration(seconds: 2),
                                        ));
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Something wrong"),
                                          duration: Duration(seconds: 2),
                                        ));
                                      }
                                    });
                                    fatchData();
                                    setState(() {
                                      apiController.isLoading = false;
                                    });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
