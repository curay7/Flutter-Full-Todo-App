import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lonetodo/app/modules/home/models/item_model.dart';
import '../controllers/home_controller.dart';

final HomeController _homeController = Get.put(HomeController());
final TextEditingController _nameCreateController = TextEditingController();
final TextEditingController _nameUpdateController = TextEditingController();
var statusController = false.obs;

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double oneContainerHeight = size.height * 0.50;
    double twoContainerHeight = size.height * 0.50;
    return SafeArea(
      child: Scaffold(
        body: _homeController.items.isEmpty
            ? const Center(
                child: Text(
                  'No Data',
                  style: TextStyle(fontSize: 30),
                ),
              )
            : Column(
                children: [
                  Obx(() {
                    if (!closeBottomContainer.value &&
                        closeTopContainer.value) {
                      return Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Tomorrow",
                                style: TextStyle(
                                    fontSize: 34, fontWeight: FontWeight.bold)),
                          ),
                          Spacer()
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Today",
                                style: TextStyle(
                                    fontSize: 34, fontWeight: FontWeight.bold)),
                          ),
                          Spacer()
                        ],
                      );
                    }
                  }),
                  customCardOne(context, size, twoContainerHeight),
                  Obx(() {
                    if (!closeBottomContainer.value &&
                        !closeTopContainer.value) {
                      return Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Tomorrow",
                                style: TextStyle(
                                    fontSize: 34, fontWeight: FontWeight.bold)),
                          ),
                          Spacer()
                        ],
                      );
                    } else {
                      return Text("");
                    }
                  }),
                  customCardTwo(context, size, oneContainerHeight),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createForm(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _editForm(BuildContext ctx, var id, String currentItemName,
      bool currentItemStatus) {
    _nameUpdateController.text = currentItemName;
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
              controller: _nameUpdateController,
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
                    print(id);
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
                        id: id,
                        nameItem: _nameUpdateController.text,
                        status: statusController.value));
                _nameUpdateController.text = '';
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
              controller: _nameCreateController,
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
                    {"name": _nameCreateController.text, "status": false});
                _nameCreateController.text = "";
                Navigator.pop(ctx);
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

  customCardOne(context, size, twoContainerHeight) {
    return Obx(() {
      if (closeTopContainer.value) {
        return customCardOneContent(context, size, twoContainerHeight);
      } else {
        return Expanded(
            flex: 2,
            child: customCardOneContent(context, size, twoContainerHeight));
      }
    });
  }

  customCardOneContent(context, size, twoContainerHeight) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: closeTopContainer.value ? 0 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size.width,
        alignment: Alignment.topCenter,
        height: closeTopContainer.value ? 0 : twoContainerHeight,
        child: ListView(
          controller: oneScrollController,
          children: _homeController.items.reversed
              .map(
                (currentItem) => Card(
                  color: Colors.transparent,
                  margin: const EdgeInsets.all(10),
                  elevation: 0,
                  child: tilesContentOne(context, currentItem),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  tilesContentOne(context, currentItem) {
    return ListTile(
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
                _editForm(
                    context, id, currentItem.nameItem, currentItem.status);
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
    );
  }

////////////////////////////////////////////////////////////////////////////////////////////
  customCardTwo(context, size, oneContainerHeight) {
    return Obx(() {
      if (closeBottomContainer.value) {
        return customCardTwoContent(context, size, oneContainerHeight);
      } else {
        return Expanded(
            flex: 1,
            child: customCardTwoContent(context, size, oneContainerHeight));
      }
    });
  }

  customCardTwoContent(context, size, oneContainerHeight) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: closeBottomContainer.value ? 0 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size.width,
        alignment: Alignment.topCenter,
        height: closeBottomContainer.value ? 0 : oneContainerHeight,
        child: ListView(
          controller: twoScrollController,
          children: _homeController.items.reversed
              .map(
                (currentItem) => Card(
                  color: Colors.white,
                  shadowColor: Colors.transparent,
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  child: tilesContentTwo(context, currentItem),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  tilesContentTwo(context, currentItem) {
    return ListTile(
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
                _editForm(
                    context, id, currentItem.nameItem, currentItem.status);
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
    );
  }
}
