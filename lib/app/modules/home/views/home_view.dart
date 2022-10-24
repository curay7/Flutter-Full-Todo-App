import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:lonetodo/app/modules/home/models/item_model.dart';
import '../controllers/home_controller.dart';
import '../views/widgets/createTodoForm.dart';

final HomeController _homeController = Get.put(HomeController());

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
        appBar: _appBar(),
        body: Obx(() {
          return _homeController.items.isEmpty
              ? const Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(fontSize: 30),
                  ),
                )
              : _bodyContent(context, oneContainerHeight, twoContainerHeight);
        }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            createForm(context, size);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        Container(
          width: 90,
          height: 90,
          padding: EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/wolfAvatar.png'),
          ),
        )
      ],
    );
  }

  _bodyContent(context, oneContainerHeight, twoContainerHeight) {
    return Column(
      children: [
        Obx(
          () {
            if (!closeBottomContainer.value && closeTopContainer.value) {
              return cardHeader("Tomorrow", Container());
            } else {
              return cardHeader(
                  "Today",
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Hide Completed",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "theFonts",
                            fontWeight: FontWeight.bold),
                      )));
            }
          },
        ),
        Obx(() {
          return customCard(context, 2, oneScrollController);
        }),
        Obx(() {
          if (!closeBottomContainer.value && !closeTopContainer.value) {
            return cardHeader("Tomorrow", Container());
          } else {
            return Container();
          }
        }),
        Obx(() {
          return customCardTwo(context);
        }),
      ],
    );
  }

  cardHeader(String textHeader, Widget widget) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Text(textHeader,
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  fontFamily: "theFonts")),
        ),
        Spacer(),
        widget
      ],
    );
  }

  customCard(context, flexSize, scorllController) {
    if (closeTopContainer.value) {
      return customCardContent(context, scorllController);
    } else {
      return Expanded(
          flex: flexSize, child: customCardContent(context, scorllController));
    }
  }

  customCardTwo(context) {
    if (closeBottomContainer.value) {
      return customCardContent(context, twoScrollController);
    } else {
      return Expanded(
          flex: 1, child: customCardContent(context, twoScrollController));
    }
  }

  customCardContent(context, scrollController) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.topCenter,
        height: 0,
        child: Obx(() {
          return ListView(
            controller: scrollController,
            children: _homeController.items.reversed
                .map(
                  (currentItem) => Card(
                    color: Colors.transparent,
                    margin: const EdgeInsets.all(10),
                    elevation: 0,
                    child: tilesContent(context, currentItem),
                  ),
                )
                .toList(),
          );
        }),
      ),
    );
  }

  tilesContent(context, currentItem) {
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
                      currentItem.nameItem,
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
                      DateFormat("dd-MM-yyyy")
                          .format(DateTime.parse('2022-01-08')),
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
  }
}
