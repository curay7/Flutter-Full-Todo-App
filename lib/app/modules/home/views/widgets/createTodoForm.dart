import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/home_controller.dart';

final HomeController _homeController = Get.put(HomeController());
final TextEditingController _nameCreateController = TextEditingController();

void createForm(BuildContext ctx, size) async {
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
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Add a Task",
                      style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          fontFamily: "theFonts")),
                ),
                const SizedBox(
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
                const SizedBox(
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
                            ],
                          ),
                          onPressed: () {
                            // ignore: unnecessary_statements
                            _homeController.chooseTime();
                          },
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(15)),
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 15))),
                        ))
                  ],
                ),
                const SizedBox(
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
                                const Icon(Icons.calendar_today),
                                const SizedBox(
                                  width: 50,
                                ),
                                Obx(
                                  () => Text(
                                    DateFormat("dd-MM-yyyy")
                                        .format(
                                            _homeController.selectedDate.value)
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
                                    const EdgeInsets.all(15)),
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
                    print(_homeController.selectedTime.value);
                    print(_homeController.selectedDate.value);
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
