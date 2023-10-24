import 'package:get/get.dart';
import 'package:task_management_app/db/db_helper.dart';
import 'package:task_management_app/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  } 

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  // get all the task from the database
  void getTask() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void deleteTask(Task task) {
    DBHelper.delete(task);
    getTask();
  }

  void markTaskCompleted(int id) async{
    await DBHelper.update(id);
    getTask();
  }
}