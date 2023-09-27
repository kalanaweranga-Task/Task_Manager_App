import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/ui/widgets/input_field.dart';

final TextStyle subHeadingStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.grey[400]:Colors.grey
);

final TextStyle headingStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.white:Colors.black
);

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endtime = "9.30 PM";
  String _startTime = DateFormat("hh:mm:a").format(DateTime.now()).toString();
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body:Container(
        padding: const EdgeInsets.only(left: 20, right:20),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Task",
              style: headingStyle,
            ),
            MyInputField(title: "Title", hint: "Enter your title"),
            MyInputField(title: "Note", hint: "Enter your note"),
            MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
            widget: IconButton(
              icon:Icon(Icons.calendar_today_outlined,
              color:Colors.grey
              ),
              
              onPressed: (){
                print("Hi there");
                _getDateFromUser();
              },
            )
            ),
            Row(
              children:[
                Expanded(
                  child: MyInputField(
                    title:"Start Date",
                    hint: _startTime,
                    widget: IconButton(

                      onPressed: (){
                        _getTimeFromUser(isStartTime:true);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color:Colors.grey ,
                      
                      ), 
                    ) ,
                  )
                ),
                SizedBox(width: 12),
                Expanded(
                  child: MyInputField(
                    title:"End Date",
                    hint: _endtime,
                    widget: IconButton(

                      onPressed: (){
                        _getTimeFromUser(isStartTime:false);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color:Colors.grey ,
                      
                      ), 
                    ) ,
                  )
                )
              ],
            )
            
         
            


          ],
        ),
        ),
      )
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap:(){
           Get.back();
        },
        child: Icon(Icons.arrow_back,
        size: 20,
        color: Get.isDarkMode ? Colors.white:Colors.black,
        ), 
      ),
      actions: [
        CircleAvatar(
          backgroundImage: const AssetImage(
            "images/profile.jpg"
          ),
        ),
        SizedBox(width: 20,)
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
    firstDate: DateTime(2015), 
    lastDate: DateTime(2121)
    );
    if(_pickerDate != null){
      setState((){
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    }else{
      print("It is null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async{
    var _pickedTime= await _showTimePicker();
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime==null) {
      print("Time Canceld");
    }else if(isStartTime==true){
      setState(() {
        _startTime = _formatedTime;
      });
      
    }else if(isStartTime==false){
      setState(() {
        _endtime=_formatedTime;
      });
      
    }
  }  

  _showTimePicker(){
     return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input ,
      context: context, 
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]), 
        minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
  }

}
    


  




 
