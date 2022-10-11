import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_simple/src/screenservice.dart';
import 'package:get/get.dart';

class CountdownButtonController extends GetxController {
  var countdown = 90;
  var countdownCurrent = 90.obs;
  var isCountdown = false.obs;

  void startCountDown() {
    isCountdown.value = true;
    countdownCurrent.value = countdown;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      countdownCurrent.value--;
      // print(countdownCurrent.value);
      if (countdownCurrent.value <= 0) {
        timer.cancel();
        isCountdown.value = false;
      }
    });
  }
}

class ResendButton extends StatelessWidget {
  final service = Get.find<ScreenService>();
  final c = Get.put(CountdownButtonController());
  ResendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: c.isCountdown.isTrue
              ? null
              : () {
                  service.onSendEmailVerification();
                  c.startCountDown();
                },
          child: c.isCountdown.isTrue
              ? Text('Wait for ${c.countdownCurrent.value} seconds')
              : const Text('Resend verification email'),
        )));
  }
}
