import 'package:flutter/material.dart';
import 'database_helper.dart';

class AddItemDialogue extends StatefulWidget {
  final TextEditingController itemNameController;
  final TextEditingController unitController;
  final TextEditingController categoryController;
  final String buttonTitle;

  void Function() onOkPressed;

  AddItemDialogue(
      {super.key,
      required this.itemNameController,
      required this.unitController,
      required this.categoryController,
      required this.onOkPressed,
      required this.buttonTitle});

  @override
  State<AddItemDialogue> createState() => _AddItemDialogueState();
}

final List categoryList = ['Edibles', 'Household Products', 'Bathing Products'];
GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _AddItemDialogueState extends State<AddItemDialogue> {
  final dbHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
            onPressed: widget.onOkPressed, child: Text(widget.buttonTitle)),
        ElevatedButton(
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            widget.itemNameController.clear();
            widget.unitController.clear();
            // widget.categoryController.clear();
            Navigator.of(context).pop();
          },
        ),
      ],
      title: const Text("Add Item"),
      content: SizedBox(
        width: 500,
        height: 350,
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: widget.itemNameController,
                  decoration: InputDecoration(
                      label: const Text("Item Name"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cant be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Units"),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: widget.unitController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter units';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Select Category",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
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
                          value: widget.categoryController.text,
                          items: categoryList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              widget.categoryController.text = value.toString();
                            });
                          }),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
