import 'package:flutter/material.dart';
import 'package:grocery_app/add_item_dialogue.dart';

import 'item_helper.dart';
import 'item_model.dart';

final List sortOrderList = ['catagory', 'name', 'unit', 'manfacturer'];

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String sortButtonValue = sortOrderList.first;
  TextEditingController itemNameController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  TextEditingController updatedItemNameController = TextEditingController();
  TextEditingController updatedUnitController = TextEditingController();
  TextEditingController updatedCategoryController = TextEditingController();

  ItemHelper itemHelper = ItemHelper();
  List itemList = <ItemModel>[];
  late int addedItemId;
  bool listPopulated = false;

  @override
  void initState() {
    super.initState();

    callQuery();
    print("_______________");
    print(itemList.length);
    for (var element in itemList) {
      print(element.itemName);
    }
    categoryController.text = 'Edibles';
  }

  void callQuery() async {
    await itemHelper.delete2();
    await itemHelper.query().whenComplete(() {
      setState(() {
        itemList = itemHelper.initialSort();
        listPopulated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    categoryController.text = 'Edibles';
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            addedItemId = await itemHelper.insert(
                itemNameController.text.trim(),
                categoryController.text.trim(),
                unitController.text.trim());

            await itemHelper.queryLastRow(addedItemId).whenComplete(() {
              itemList = itemHelper.initialSort();
              print("____item list___");
              for (var element in itemList) {
                print(element.itemName);
              }
            });
            print('list updated');
            itemNameController.clear();
            // categoryController.clear();
            unitController.clear();
            setState(() {});
          },
          label: const Text("Add Item"),
          backgroundColor: Colors.amber),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text("test app"),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: itemNameController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Handwash, Biscuits, etc..',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddItemDialogue(
                              itemNameController: itemNameController,
                              unitController: unitController,
                              categoryController: categoryController,
                              buttonTitle: "Ok",
                              onOkPressed: () {
                                if (formKey.currentState?.validate() == true) {
                                  Navigator.pop(context);
                                }
                              }),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: InputDecorator(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blueAccent,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          elevation: 16,
                          isExpanded: false,
                          dropdownColor: Colors.black54,
                          enableFeedback: true,
                          style: const TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 17),
                          value: sortButtonValue,
                          items: sortOrderList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              sortButtonValue = value!;
                            });
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          listPopulated
              ? Expanded(
                  child: ListView.builder(
                    itemCount: itemList.length,
                    itemBuilder: (context, index) => Card(
                      child: Dismissible(
                        background: slideBackground(),
                        confirmDismiss: (direction) async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                      "Are you sure you want to delete ${itemList[index].itemName}?"),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () async {
                                        await itemHelper
                                            .delete(itemList[index].id)
                                            .whenComplete(() {
                                          itemHelper.itemList.removeAt(index);
                                          itemList = itemHelper.initialSort();
                                        });
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                          return null;
                        },
                        key: Key(index.toString()),
                        child: InkWell(
                          onTap: () {
                            updatedItemNameController.text =
                                itemList[index].itemName;
                            updatedUnitController.text =
                                itemList[index].unit.toString();
                            updatedCategoryController.text =
                                itemList[index].category;
                            print(
                                " homefunction ${index} ${updatedItemNameController.text} ${updatedUnitController.text} ${updatedCategoryController.text} ");
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddItemDialogue(
                                    itemNameController:
                                        updatedItemNameController,
                                    unitController: updatedUnitController,
                                    categoryController:
                                        updatedCategoryController,
                                    buttonTitle: "Update",
                                    onOkPressed: () async {
                                      print(
                                          " onOkPress ${index} ${updatedItemNameController.text} ${updatedUnitController.text} ${updatedCategoryController.text} ");
                                      if (formKey.currentState?.validate() ==
                                          true) {
                                        await itemHelper
                                            .update(
                                                itemList[index].id,
                                                index,
                                                updatedItemNameController.text
                                                    .trim(),
                                                updatedCategoryController.text
                                                    .trim(),
                                                updatedUnitController.text
                                                    .trim())
                                            .whenComplete(() {
                                          itemList = itemHelper.initialSort();
                                          setState(() {});
                                          Navigator.pop(context);
                                        });
                                      }
                                    },
                                  );
                                });
                          },
                          child: ListTile(
                            title: Text(
                              itemList[index].itemName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              itemList[index].category,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              itemList[index].unit.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
        ],
      ),
    );
  }

/*
ListTile(
                        title: Text(
                          itemList[index].itemName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          itemList[index].category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
*/

  // Widget progressIndicator() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return const Expanded(
  //           child: Center(
  //             child: CircularProgressIndicator(
  //               backgroundColor: Colors.black45,
  //             ),
  //           ),
  //         );
  //       });
  // }
}

Widget slideBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    ),
  );
}
