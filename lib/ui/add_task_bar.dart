import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/controllers/task_controller.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/ui/theme.dart';
import 'package:task_management_app/ui/widgets/button.dart';
import 'package:task_management_app/ui/widgets/input_field.dart';

final TextStyle subHeadingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey);

final TextStyle headingStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.white : Colors.black);

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endtime = "9.30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
    25,
  ];

  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
    "Annualy",
  ];

  String _selectedCategory = "Other";
   List<String> categoryList = [
    "Education",
    "Sports",
    "Food",
    "Meetings",
    "Friends",
    "Family",
    "Groceries",
    "Fitness",
    "Other"
  ];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: _appBar(context),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Task",
                  style: headingStyle,
                ),
                MyInputField(
                  title: "Title",
                  hint: "Enter your title",
                  controller: _titleController,
                ),
                MyInputField(
                  title: "Note",
                  hint: "Enter your note",
                  controller: _noteController,
                ),
                MyInputField(
                    title: "Date",
                    hint: DateFormat.yMd().format(_selectedDate),
                    widget: IconButton(
                      icon: const Icon(Icons.calendar_today_outlined,
                          color: Colors.grey),
                      onPressed: () {
                        print("Hi there");
                        _getDateFromUser();
                      },
                    )),
                Row(
                  children: [
                    Expanded(
                        child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    )),
                    const SizedBox(width: 12),
                    Expanded(
                        child: MyInputField(
                      title: "End TIme",
                      hint: _endtime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ))
                  ],
                ),

                // Remind
                MyInputField(
                  title: "Remind",
                  hint: "$_selectedRemind min early",
                  widget: DropdownButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(),
                    items: remindList
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text("$e min early"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRemind = int.parse(value.toString());
                      });
                    },
                  ),
                ),

                // Repeat
                MyInputField(
                  title: "Repeat",
                  hint: _selectedRepeat,
                  widget: DropdownButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(),
                    items: repeatList
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRepeat = value.toString();
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                // Category
                MyInputField(
                  title: "Category",
                  hint: _selectedCategory,
                  widget: DropdownButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(),
                    items: categoryList
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value.toString();
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorPallete(),
                    MyButton(
                        label: "Create task", onTap: () => _validateDate()),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white));
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endtime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        category: _selectedCategory,
        isCompleted: 0,
      ),
    );
    print("My id is $value");
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(
              3,
              (int index) => GestureDetector(
                    onTap: () => setState(() {
                      _selectedColor = index;
                      print("$index");
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: index == 0
                            ? primaryClr
                            : index == 1
                                ? pinkClr
                                : yellowClr,
                        child: _selectedColor == index
                            ? Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    ),
                  )),
        )
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.jpg"),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2121));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print("It is null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      print("Time Canceld");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endtime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
  }
}
