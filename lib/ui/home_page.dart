// import 'dart:ffi';

// import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/controllers/task_controller.dart';
import 'package:task_management_app/models/task.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/services/notification_services.dart';
import 'package:task_management_app/services/theme_services.dart';
import 'package:intl/intl.dart';
// import 'package:task_management_app/ui/theme.dart';
import 'package:task_management_app/ui/add_task_bar.dart';
import 'package:task_management_app/ui/theme.dart';
import 'package:task_management_app/ui/widgets/button.dart';
import 'package:task_management_app/ui/widgets/input_field.dart';
import 'package:task_management_app/ui/widgets/task_tile.dart'; // Import the intl package
import 'package:filter_list/filter_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  List<Task> display_list = [];

  late NotifyHelper notifyHelper;

  @override
  void initState() {
    // setState(() async{
    _taskController.getTask();
    display_list = _taskController.taskList;

    // });
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }
  //  List<Task> display_list = List.from(Get.put(_TaskController()).taskList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          // _addTaskBar(),
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 10,
          ),
          // _taskController.taskList.length == 0 ?
          //   Center(
          //     child: Text("No Task Found",style: titleStyle,),
          //   )

          // :
          _showTask(),
        ],
      ),
    );
  }

  _showTask() {
    // print("Length::::${_taskController.taskList.length}");
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];
              print(task.toJson());
              if (task.repeat == 'Daily' ||
                  task.repeat == 'None' ||
                  task.repeat == 'Weekly' ||
                  task.repeat == 'Monthly' ||
                  task.repeat == 'Annualy') {
                String timeString = task.startTime.toString();
                // print("1::::$timeString");
                DateTime parsedTime = DateFormat('h:mm a').parse(timeString);
                // print("2::::$parsedTime");
                String formattedTime = DateFormat.jm().format(parsedTime);
                DateTime date = DateFormat.jm().parse(formattedTime);
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(":")[0]),
                    int.parse(myTime.toString().split(":")[1]),
                    task);
                if (task.date == DateFormat.yMd().format(_selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
          padding: const EdgeInsets.only(top: 4),
          height: task.isCompleted == 1
              ? MediaQuery.of(context).size.height * 0.24
              : MediaQuery.of(context).size.height * 0.32,
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
          child: Column(
            children: [
              Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Get.isDarkMode
                          ? Colors.grey[600]
                          : Colors.grey[300])),
              Spacer(),
              task.isCompleted == 1
                  ? Container()
                  : _bottomSheetButton(
                      label: "Task Completed",
                      onTap: () {
                        _taskController.markTaskCompleted(task.id!);
                        Get.back();
                      },
                      clr: primaryClr,
                      context: context,
                    ),
              _bottomSheetButton(
                label: "Delete Task",
                onTap: () {
                  _taskController.deleteTask(task);
                  Get.back();
                },
                clr: Colors.red[300]!,
                context: context,
              ),
              SizedBox(
                height: 20,
              ),
              _bottomSheetButton(
                label: "Close",
                onTap: () {
                  Get.back();
                },
                clr: Colors.red[300]!,
                isClose: true,
                context: context,
              ),
              SizedBox(
                height: 10,
              )
            ],
          )),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            height: 55,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: isClose == true
                      ? Get.isDarkMode
                          ? Colors.grey[600]!
                          : Colors.grey[300]!
                      : clr),
              borderRadius: BorderRadius.circular(20),
              color: isClose == true ? Colors.transparent : clr,
            ),
            child: Center(
              child: Text(
                label,
                style: isClose
                    ? titleStyle
                    : titleStyle.copyWith(color: Colors.white),
              ),
            )));
  }

  _addDateBar() {
    return Container(
        margin: const EdgeInsets.only(top: 20, left: 20),
        child: DatePicker(
          DateTime.now(),
          height: 100,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryClr,
          selectedTextColor: Colors.white,
          dateTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          dayTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          monthTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          onDateChange: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ));
  }

  _addTaskBar() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    style: subHeadingStyle,
                  ),
                  Text(
                    "Today",
                    style: headingStyle,
                  )
                ],
              ),
            ),
            MyButton(
                label: "+ Task",
                onTap: () async {
                  await Get.to(() => AddTaskPage());
                  _taskController.getTask();
                  display_list = _taskController.taskList;
                })
          ],
        ));
  }

  _searchBox() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: TextField(
          onChanged: (value) => updateList(value),
          style: TextStyle(color: Colors.grey),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: "Search",
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
        ));
  }

  // void openFilterDialog(context) async {
  //   await FilterListDialog.display<String>(
  //     context,
  //     listData: userList,
  //     selectedListData: selectedUserList,
  //     choiceChipLabel: (user) => user!.name,
  //     validateSelectedItem: (, val) => list!.contains(val),
  //     onApplyButtonClick: (list) {
  //       setState(() {
  //         display_list = List.from(list!);
  //       });
  //       Navigator.pop(context);
  //     },
  //   );
  // }

  void updateList(String value) {
    //search filtering list
    // print("VALUE::::" + value);
    // print("LENGTH_LIST:::: ${display_list.length}");
    setState(() {
      _taskController.taskList = RxList<Task>.from(display_list.where(
          (element) =>
              element.title!.toLowerCase().contains(value.toLowerCase())));
      print(_taskController.taskList.length);
    });
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.initializeNotification();
          notifyHelper.displayNotification(
              title: "Theme Change",
              body: Get.isDarkMode
                  ? "Activated Light Theme"
                  : "Activated Dark Theme");

          // notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        _searchBox(),
        const SizedBox(
          width: 10,
        ),
        // const CircleAvatar(
        TextButton(
          onPressed: () {
            Get.to(() => AddTaskPage());
          },
          child: Icon(
            Icons.filter_list,
            color: Colors.black,
          ),
        ),

        // backgroundImage: AssetImage("images/profile.jpg"),
        // ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }
}
