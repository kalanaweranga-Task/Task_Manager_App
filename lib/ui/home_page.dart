import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/services/notification_services.dart';
import 'package:task_management_app/services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}):super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper=NotifyHelper();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Text("Theme Data",
          style: TextStyle(
            fontSize: 30
          ),
          ),
          
        ],
      ),
    );
  }

  _appBar(){
    return AppBar(
      leading: GestureDetector(
        onTap:(){
           ThemeService().switchTheme();
           notifyHelper.initializeNotification(); 
           notifyHelper.displayNotification(
              title:"Theme Change",
              body:Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme"
           );
        },
        child: Icon(Icons.nightlight_round,
        size: 20,), 
      ),
      actions: [
        Icon(Icons.person,
        size: 20,),
        SizedBox(width: 20,)
      ],
    );
  }
}