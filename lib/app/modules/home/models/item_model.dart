class TodoModel {
  final int? id;
  final String nameItem;
  final bool status;
  final String? date;
  final String? hour;

  TodoModel(
      {required this.nameItem,
      required this.status,
      this.id,
      this.date,
      this.hour});
}
