import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lonetodo/app/modules/home/models/item_model.dart';
import '../controllers/home_controller.dart';

final HomeController _homeController = Get.put(HomeController());
final TextEditingController _nameController = TextEditingController();
var statusController = false.obs;

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
                          title: Text(currentItem.nameItem),
                          subtitle: Text("${currentItem.status}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit button
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    var id = currentItem.id;
                                    _editForm(context, id, currentItem.nameItem,
                                        currentItem.status);
                                  }),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editForm(BuildContext ctx, var id, String currentItemName,
      bool currentItemStatus) {
    _nameController.text = currentItemName;
    statusController.value = currentItemStatus;
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
            Obx(
              () {
                return Checkbox(
                  value: statusController.value,
                  onChanged: (value) {
                    bool onChangeBool =
                        (value.toString() == 'true') ? true : false;
                    statusController.value = onChangeBool;
                  },
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _homeController.updateItem(
                    id,
                    TodoModel(
                        nameItem: _nameController.text,
                        status: statusController.value));
                _nameController.text = '';
              },
              child: const Text('update'),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  void _createForm(BuildContext ctx) async {
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
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                _homeController.createItem(
                    {"name": _nameController.text, "quantity": false});
              },
              child: const Text("Create"),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
