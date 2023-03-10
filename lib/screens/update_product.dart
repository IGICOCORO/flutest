import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../models/category.dart';
import '../models/product.dart';

class UpdateProduct extends StatefulWidget {
  final Isar isar;
  final Product product;
  const UpdateProduct({Key? key, required this.isar, required this.product})
      : super(key: key);

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  List<Category>? categories;
  Category? dropdownValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _newCatController = TextEditingController();
  List<String> days = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];
  String dropdownDay = "monday";
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setProductInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(title: const Text("Update Product")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Category",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: DropdownButton(
                    focusColor: const Color(0xffffffff),
                    dropdownColor: const Color(0xffffffff),
                    isExpanded: true,
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: categories
                        ?.map<DropdownMenuItem<Category>>((Category nvalue) {
                      return DropdownMenuItem<Category>(
                          value: nvalue, child: Text(nvalue.name));
                    }).toList(),
                    onChanged: (Category? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text("New Category"),
                            content: TextFormField(
                                controller: _newCatController),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    if (_newCatController.text.isNotEmpty) {
                                      _addCategory(widget.isar);
                                    }
                                  },
                                  child: const Text("Add"))
                            ],
                          ));
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child:
              Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            TextFormField(
              controller: _nameController,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text("Start Time",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    controller: _timeController,
                    enabled: false,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _selectedTime(context);
                    },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text("Day", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: DropdownButton(
                isExpanded: true,
                value: dropdownDay,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: days.map<DropdownMenuItem<String>>((String day) {
                  return DropdownMenuItem<String>(value: day, child: Text(day));
                }).toList(),
                onChanged: (String? newDay) {
                  setState(() {
                    dropdownDay = newDay!;
                  });
                },
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () {
                      updateProduct();
                    },
                    child: const Text("Update")))
          ]),
        ),
      ),
    );
  }

  _selectedTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial);

    if (timeOfDay != null && timeOfDay != selectedTime) {
      selectedTime = timeOfDay;
      setState(() {
        _timeController.text =
        "${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.name}";
      });
    }
  }

//create category record
  _addCategory(Isar isar) async {
    final categories = isar.categorys;

    final newCategory = Category()..name = _newCatController.text;

    await isar.writeTxn(() async{
      await categories.put(newCategory);
    });

    _newCatController.clear();
    _readCategory();
  }

  _readCategory() async {
    final categoryCollection = widget.isar.categorys;
    final getCategories = await categoryCollection.where().findAll();
    setState(() {
      dropdownValue = null;
      categories = getCategories;
    });
  }

  _setProductInfor() async {
    await _readCategory();
    _nameController.text = widget.product.name;
    await widget.product.category.load();
    int? getId = widget.product.category.value?.id;
    setState(() {
      dropdownValue = categories?[getId! - 1];
    });
  }

  updateProduct() async {
    final productCollection = widget.isar.products;
    await widget.isar.writeTxn(() async {

      Navigator.pop(context);
    });
  }
}
