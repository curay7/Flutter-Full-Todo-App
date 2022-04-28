import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lonetodo/app/modules/home/models/todo_model.dart';

final _shoppingBox = Hive.box('todos');

class HomeController extends GetxController {
  // Implement HomeController

  final count = 0.obs;
  final textInput = "".obs;
  var items = <TodoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshItems(); // Load data when app starts
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  //!!!!!This is for LocalDatabase

  // Todo Get all items from the database
  refreshItems() async {
    print("fire RefreshItems");
    var data = _shoppingBox.keys.map((key) {
      final value = _shoppingBox.get(key);
      return {"key": key, "name": value["name"], "quantity": value['quantity']};
    }).toList();
    for (var item in data) {
      //! Todo:Quantity is null need to fix the data from hive database
      String tempVarQuantity = "";
      (item["quantity"] == null)
          ? tempVarQuantity = "0"
          : tempVarQuantity = item["quantity"];

      TodoModel initailData = TodoModel(
          todoText: item["name"], quantity: tempVarQuantity, id: item["key"]);
      items.add(initailData);
    }
  }

  //Todo Create new item
  createItem(newItem) async {
    TodoModel addedItem =
        TodoModel(todoText: newItem["name"], quantity: newItem["quantity"]);

    var addToHive = {
      "name": addedItem.todoText,
      "quantity": addedItem.quantity,
      "isDone": true
    };

    items.add(addedItem);
    await _shoppingBox.add(addToHive);
  }

  // Todo Retrieve a single item from the database by using its key
  void readItem(int key) {
    final item = _shoppingBox.get(key);
    return item;
  }

  // Todo Update a single item
  updateItem(int itemKey, TodoModel updateItem) async {
    items[items.indexWhere((todo) => todo.id == itemKey)] = updateItem;
    var putToHiveUpdate = {
      'name': updateItem.todoText,
      'quantity': updateItem.quantity
    };
    await _shoppingBox.put(itemKey, putToHiveUpdate);
  }

  // Todo Delete a single item
  deleteItem(itemKey) async {
    await _shoppingBox.delete(itemKey);
    items.removeWhere((item) => item.id == itemKey);

    Get.snackbar(
      "Lone Play",
      "An item has been deleted",
      icon: const Icon(Icons.person, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.black,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
    // Display a snackbar
    // ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('An item has been deleted')));
  }
}
