import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lonetodo/app/modules/home/models/item_model.dart';

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

  //? Get all items from the database
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
          nameItem: item["name"], quantity: tempVarQuantity, id: item["key"]);
      items.add(initailData);
    }
  }

  //? Create new item
  Future<void> createItem(newItem) async {
    var addToHive = {
      "name": newItem["name"],
      "quantity": newItem["quantity"],
      "isDone": true
    };
    var newId = await _shoppingBox.add(addToHive);

    TodoModel addedItem = await TodoModel(
        id: newId, nameItem: newItem["name"], quantity: newItem["quantity"]);

    items.add(addedItem);
    print(newId);
  }

  //? Retrieve a single item from the database by using its key
  void readItem(int key) {
    final item = _shoppingBox.get(key);
    return item;
  }

  //? Update a single item
  updateItem(int itemKey, TodoModel updateItem) async {
    items[items.indexWhere((todo) => todo.id == itemKey)] = updateItem;
    var putToHiveUpdate = {
      'name': updateItem.nameItem,
      'quantity': updateItem.quantity
    };
    await _shoppingBox.put(itemKey, putToHiveUpdate);
  }

  //? Delete a single item
  deleteItem(itemKey) async {
    await _shoppingBox.delete(itemKey);
    items.removeWhere((item) => item.id == itemKey);

    Get.snackbar(
      "Lone Play",
      "An item has been deleted",
      icon: const Icon(Icons.person, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blueAccent,
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
    // Display a snackbar
    // ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('An item has been deleted')));
  }
}
