import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            Container(
              width: 100,
              height: 100,
              child: CircleAvatar(
                radius: 100,
                child: ClipRRect(
                  child: Image.asset('assets/wolfAvatar.png'),
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
              // child: IconButton(
              //   icon: const Icon(
              //     Icons.person,
              //     color: Colors.black,
              //     size: 70,
              //   ),
              //   tooltip: 'Show Snackbar',
              //   onPressed: () {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(content: Text('This is a snackbar')));
              //   },
              // ),
            )
          ],
        ),
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
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "theFonts")),
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
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "theFonts")),
                          ),
                          Spacer(),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Hide completed",
                                style: TextStyle(
                                    fontFamily: "theFonts", fontSize: 13),
                              ))
                        ],
                      );
                    }
                  }),
                  Obx(() {
                    return customCardOne(context, size, twoContainerHeight);
                  }),
                  Obx(() {
                    if (!closeBottomContainer.value &&
                        !closeTopContainer.value) {
                      return Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Tomorrow",
                                style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "theFonts")),
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
          backgroundColor: Colors.black,
          onPressed: () {
            _createForm(context, size);
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
                Color getColor(Set<MaterialState> states) {
                  const Set<MaterialState> interactiveStates = <MaterialState>{
                    MaterialState.pressed,
                    MaterialState.hovered,
                    MaterialState.focused,
                  };
                  if (states.any(interactiveStates.contains)) {
                    return Colors.blue;
                  }
                  return Colors.red;
                }

                return Checkbox(
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0))),
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: false,
                  onChanged: (bool? value) {},
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
                        status: statusController.value,
                        date: _homeController.selectedDate.value.toString(),
                        time: _homeController.selectedTime.value.toString()));
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

  void _createForm(BuildContext ctx, size) async {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        height: size.height * 0.80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
                backgroundColor: Colors.grey[100],
                iconTheme: IconThemeData(color: Colors.black),
                toolbarHeight: 70.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                )),
            Container(
              margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Add a Task",
                        style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            fontFamily: "theFonts")),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text("Name",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                fontFamily: "theFonts")),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          flex: 8,
                          child: TextField(
                            controller: _nameCreateController,
                            decoration: const InputDecoration(hintText: 'Name'),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text("Hours",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                fontFamily: "theFonts")),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          flex: 8,
                          child: OutlinedButton(
                            child: Row(
                              children: [
                                Icon(Icons.schedule),
                                SizedBox(
                                  width: 50,
                                ),
                                Obx(
                                  () => Text(
                                    "${_homeController.selectedTime.value.hour}:${_homeController.selectedTime.value.minute}",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                )
                                // Text(
                                //   "Select Time",
                                //   textAlign: TextAlign.center,
                                // )
                              ],
                            ),
                            onPressed: () {
                              // ignore: unnecessary_statements
                              _homeController.chooseTime();
                            },
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(15)),
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 15))),
                          )

                          //  ElevatedButton(
                          //   onPressed: () {
                          //     _homeController.chooseTime();
                          //   },
                          //   child: Text('Select Time'),
                          // )
                          )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text("Date",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                fontFamily: "theFonts")),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Obx(
                                    () => Text(
                                      DateFormat("dd-MM-yyyy")
                                          .format(_homeController
                                              .selectedDate.value)
                                          .toString(),
                                    ),
                                  )
                                ],
                              ),
                              onPressed: () {
                                // ignore: unnecessary_statements
                                _homeController.chooseDate();
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(15)),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(fontSize: 15))),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _homeController.createItem({
                        "name": _nameCreateController.text,
                        "time": _homeController.selectedTime.value,
                        "date": _homeController.selectedDate.value,
                        "status": false
                      });
                      _nameCreateController.text = "";
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      padding: EdgeInsets.all(15),
                      minimumSize: Size(300, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  customCardOne(context, size, twoContainerHeight) {
    if (closeTopContainer.value) {
      return customCardOneContent(context, size, twoContainerHeight);
    } else {
      return Expanded(
          flex: 2,
          child: customCardOneContent(context, size, twoContainerHeight));
    }
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
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.grey;
    }

    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Checkbox(
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.0))),
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: false,
              onChanged: (bool? value) {},
            ),
          ),
        ),
        SizedBox(
          width: 17,
        ),
        Expanded(
            flex: 9,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                      style: TextStyle(fontSize: 15, fontFamily: "theFonts"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "12:42 PM",
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xffA3A3A3),
                          fontFamily: "theFonts"),
                    ),
                  ),
                ),
              ],
            )),
        Spacer()
      ],
    );
    // return ListTile(
    //   title: Text(currentItem.nameItem),
    //   subtitle: Text("${currentItem.status}"),
    //   trailing: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       // Edit button
    //       IconButton(
    //           icon: const Icon(Icons.edit),
    //           onPressed: () {
    //             var id = currentItem.id;
    //             _editForm(
    //                 context, id, currentItem.nameItem, currentItem.status);
    //           }),
    //       // Delete button
    //       IconButton(
    //         icon: const Icon(Icons.delete),
    //         onPressed: () {
    //           var id = currentItem.id;
    //           _homeController.deleteItem(id);
    //         },
    //       ),
    //     ],
    //   ),
    // );
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
                  color: Colors.transparent,
                  margin: const EdgeInsets.all(10),
                  elevation: 0,
                  child: tilesContentTwo(context, currentItem),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  tilesContentTwo(context, currentItem) {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 13,
            width: 13,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.black,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(
          width: 17,
        ),
        Expanded(
            flex: 9,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                      style: TextStyle(fontSize: 15, fontFamily: "theFonts"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "12:42 PM",
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xffA3A3A3),
                          fontFamily: "theFonts"),
                    ),
                  ),
                ),
              ],
            )),
        Spacer()
      ],
    );
    // return ListTile(
    //   title: Text(currentItem.nameItem),
    //   subtitle: Text("${currentItem.status}"),
    //   trailing: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       // Edit button
    //       IconButton(
    //           icon: const Icon(Icons.edit),
    //           onPressed: () {
    //             var id = currentItem.id;
    //             _editForm(
    //                 context, id, currentItem.nameItem, currentItem.status);
    //           }),
    //       // Delete button
    //       IconButton(
    //         icon: const Icon(Icons.delete),
    //         onPressed: () {
    //           var id = currentItem.id;
    //           _homeController.deleteItem(id);
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}
