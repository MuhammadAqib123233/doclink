import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doclink/patient/common/custom_ui.dart';
import 'package:doclink/patient/common/top_bar_area.dart';
import 'package:doclink/patient/generated/l10n.dart';
import 'package:doclink/patient/model/notification/notification.dart';
import 'package:doclink/patient/screen/notification_screen/notification_screen_controller.dart';
import 'package:doclink/utils/color_res.dart';
import 'package:doclink/utils/my_text_style.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationScreenController());
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: Column(
        children: [
          TopBarArea(title: PS.current.notifications),
          const SizedBox(
            height: 10,
          ),
          GetBuilder(
            init: controller,
            builder: (context) {
              return Expanded(
                child: controller.isLoading
                    ? CustomUi.loaderWidget()
                    : ListView.builder(
                        controller: controller.scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: controller.notifications?.length,
                        itemBuilder: (context, index) {
                          NotificationData? notifications =
                              controller.notifications?[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notifications?.title ?? '',
                                        style: MyTextStyle.montserratMedium(
                                          size: 15,
                                          color: ColorRes.darkJungleGreen,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        notifications?.description ?? '',
                                        style: MyTextStyle.montserratLight(
                                          size: 13,
                                          color: ColorRes.smokeyGrey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(thickness: 1),
                              ],
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
