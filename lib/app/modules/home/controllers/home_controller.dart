import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lonetodo/app/modules/home/models/item_model.dart';

final _shoppingBox = Hive.box('todos');

//This line is for container one and container two that output data from todo,
final ScrollController oneScrollController = ScrollController();
var closeBottomContainer = false.obs;

final ScrollController twoScrollController = ScrollController();
var closeTopContainer = false.obs;

class HomeController extends GetxController {
  // Implement HomeController

  final count = 0.obs;
  final textInput = "".obs;
  var items = <TodoModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    oneScrollController.addListener(() {
      double value = oneScrollController.offset / 119;
      closeBottomContainer.value = oneScrollController.offset > 50;
      print(closeBottomContainer);
    });

    twoScrollController.addListener(() {
      double value = twoScrollController.offset / 119;
      closeTopContainer.value = twoScrollController.offset > 50;
      //print(twoScrollController);
      //(twoScrollController.offset > 25) ? closeTopContainer.toggle() : null;
    });
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

  // ignore: slash_for_doc_comments
  /**
   * ? Get all items from the database
   * 
   * 
   */
  refreshItems() async {
    var data = _shoppingBox.keys.map((key) {
      final value = _shoppingBox.get(key);
      return {"key": key, "name": value["name"], "status": value['status']};
    }).toList();
    for (var item in data) {
      TodoModel initailData = TodoModel(
          nameItem: item["name"], status: item["status"], id: item["key"]);
      items.add(initailData);
    }
  }

  // ignore: slash_for_doc_comments
  /**
   *  ?Create new item
   * 
   * 
   */

  void createItem(newItem) async {
    var addToHive = {
      "name": newItem["name"],
      "status": newItem["status"],
      "isDone": true
    };
    var newId = await _shoppingBox.add(addToHive);

    TodoModel addedItem = TodoModel(
        id: newId, nameItem: newItem["name"], status: newItem["status"]);

    items.add(addedItem);
  }

  // ignore: slash_for_doc_comments
  /**
   * ? Retrieve a single item from the database by using its key
   * 
   * 
   */
  void readItem(int key) {
    final item = _shoppingBox.get(key);
    return item;
  }

  // ignore: slash_for_doc_comments
  /**
   *  ?Update a single item
   * 
   * 
   */
  updateItem(int itemKey, TodoModel updateItem) async {
    items[items.indexWhere((todo) => todo.id == itemKey)] = updateItem;
    var putToHiveUpdate = {
      'name': updateItem.nameItem,
      'status': updateItem.status
    };
    await _shoppingBox.put(itemKey, putToHiveUpdate);
  }

  // ignore: slash_for_doc_comments
  /***
   *   ?Delete a single item
   * 
   * 
   * 
   * 
   */
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
  }
}
