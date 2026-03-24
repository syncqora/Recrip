import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/di/get_injector.dart';
import 'base_page_controller.dart';

class BasePageView extends StatelessWidget {
  BasePageView({super.key});

  final BasePageController controller = Get.put(BasePageController());

  // Create a unique GlobalKey for each instance of BasePageView
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    controller.setScaffoldKey(scaffoldKey);
    appNav.setNavigationCallback((
      String newTitle,
      Widget newPage,
      dynamic arguments,
    ) {
      controller.updatePage(newTitle, newPage, arguments);
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, res) async {
        appNav.popPage();
      },
      canPop: appNav.canPop(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        backgroundColor: Get.theme.primaryColor,
        //drawer: AppDrawer(),
        body: GetBuilder<BasePageController>(
          builder: (controller) => controller.currentPage,
        ),
      ),
    );
  }
}
