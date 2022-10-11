import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

/// A modal dialog for ToC and Privacy Policy
class ModalDialog {
  /// Opens a modal dialog for ToC and Privacy Policy
  static void open(String html) {
    Get.dialog(
      Builder(builder: (BuildContext context) {
        return Scaffold(
            body: ListView(
          shrinkWrap: true,
          children: [
            IconButton(
                alignment: Alignment.topLeft,
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back)),
            Padding(padding: const EdgeInsets.all(16), child: HtmlWidget(html)),
          ],
        ));
      }),
    );

    // Navigator.of(Get.context!).push(MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return Scaffold(
    //           body: ListView(
    //         shrinkWrap: true,
    //         children: [
    //           IconButton(
    //               alignment: Alignment.topLeft,
    //               onPressed: () => Get.back(),
    //               icon: const Icon(Icons.arrow_back)),
    //           Padding(
    //               padding: const EdgeInsets.all(16), child: HtmlWidget(html)),
    //         ],
    //       ));
    //     },
    //     fullscreenDialog: true));
  }
}
