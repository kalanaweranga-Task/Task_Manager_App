class Task {
  int? id;
  String? title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  String? category;
  int? remind;
  String? repeat;
  int? isCompleted;

  Task({
    this.id,
    this.title,
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.category,
    this.remind,
    this.repeat,
    this.isCompleted,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    color = json['color'];
    category = json['category'];
    remind = json['remind'];
    repeat = json['repeat'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['color'] = color;
    data['category'] = category;
    data['remind'] = remind;
    data['repeat'] = repeat;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
