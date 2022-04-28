import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lonetodo/app/modules/home/models/todo_model.dart';
import '../controllers/home_controller.dart';

final HomeController _homeController = Get.put(HomeController());
final TextEditingController _nameController = TextEditingController();
final TextEditingController _quantityController = TextEditingController();

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: _homeController.items.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : Obx(
              () => ListView(
                children: _homeController.items.reversed
                    .map(
                      (currentItem) => Card(
                        color: Colors.orange.shade100,
                        margin: const EdgeInsets.all(10),
                        elevation: 3,
                        child: ListTile(
                          title: Text(currentItem.todoText),
                          subtitle: Text("${currentItem.quantity}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit button
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showForm(context, currentItem.id)),
                              // Delete button
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  var id = currentItem.id;
                                  _homeController.deleteItem(id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
      // : ListView.builder(
      //     // the list of items
      //     itemCount: _homeController.items.length,
      //     itemBuilder: (_, index) {
      //       final currentItem = _homeController.items[index];
      //       //return Card(child: Text("${currentItem["name"]}"));
      //       return Card(
      //         color: Colors.orange.shade100,
      //         margin: const EdgeInsets.all(10),
      //         elevation: 3,
      //         child: ListTile(
      //           title: Text(currentItem.todoText),
      //           subtitle: Text("${currentItem.quantity}"),
      //           trailing: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               // Edit button
      //               IconButton(
      //                   icon: const Icon(Icons.edit),
      //                   onPressed: () =>
      //                       _showForm(context, currentItem.id)),
      //               // Delete button
      //               IconButton(
      //                 icon: const Icon(Icons.delete),
      //                 onPressed: () {
      //                   var id = currentItem.id;
      //                   _homeController.deleteItem(id);
      //                 },
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
          _homeController.items.firstWhere((item) => item.id == itemKey);
      _nameController.text = existingItem.todoText;
      _quantityController.text = existingItem.quantity.toString();
    }

    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Quantity'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new item
                      if (itemKey == null) {
                        _homeController.createItem({
                          "name": _nameController.text,
                          "quantity": _quantityController.text
                        });
                      }

                      // update an existing item
                      if (itemKey != null) {
                        _homeController.updateItem(
                            itemKey,
                            TodoModel(
                                todoText: _nameController.text.trim(),
                                quantity: _quantityController.text.trim()));
                      }

                      // Clear the text fields
                      _nameController.text = '';
                      _quantityController.text = '';

                      // Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text(itemKey == null ? 'Create New' : 'Update'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ));
  }
}
