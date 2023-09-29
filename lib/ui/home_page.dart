// import 'dart:ffi';

// import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/controllers/task_controller.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/services/notification_services.dart';
import 'package:task_management_app/services/theme_services.dart';
import 'package:intl/intl.dart';
// import 'package:task_management_app/ui/theme.dart';
import 'package:task_management_app/ui/add_task_bar.dart';
import 'package:task_management_app/ui/theme.dart';
import 'package:task_management_app/ui/widgets/button.dart';
import 'package:task_management_app/ui/widgets/task_tile.dart'; // Import the intl package

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

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
          const SizedBox(height: 10,),
          _showTask(),
        ],
      ),
    );
  }

  _showTask() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              print(_taskController.taskList.length);
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
                            print("Tapped");
                          },
                          child: TaskTile(_taskController.taskList[index]),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      }),
    );
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
          onDateChange: (date) {},
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
                })
          ],
        ));
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
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
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
}
