import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class CreateProduct extends StatefulWidget {
  final Isar isar;
  const CreateProduct({Key? key, required this.isar}) : super(key: key);

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  List<String> categories = ['work', 'school', 'home'];
  String dropdownValue = 'work';
  final TextEditingController _titleController = TextEditingController();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(title: const Text("Create Product")),
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
                        .map<DropdownMenuItem<String>>((String nvalue) {
                      return DropdownMenuItem<String>(
                          value: nvalue, child: Text(nvalue));
                    }).toList(),
                    onChanged: (String? newValue) {
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
                                    if(_newCatController.text.isNotEmpty) {
                                      _addCategory();
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
              controller: _titleController,
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
                child:
                ElevatedButton(onPressed: () {
                  _addCategory();
                }, child: const Text("Add")))
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
}

class _addCategory {
}