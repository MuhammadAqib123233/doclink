import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doclink/patient/common/category_card.dart';
import 'package:doclink/patient/common/dashboard_top_bar_title.dart';
import 'package:doclink/patient/generated/l10n.dart';
import 'package:doclink/patient/screen/specialists_detail_screen/specialists_detail_screen.dart';
import 'package:doclink/patient/screen/specialists_screen/specialists_screen_controller.dart';

class SpecialistsScreen extends StatelessWidget {
  const SpecialistsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpecialistsScreenController());
    return Column(
      children: [
        DashboardTopBarTitle(
          title: PS.current.specialists,
        ),
        GetBuilder(
          init: controller,
          builder: (context) {
            return Expanded(
              child: GridView.builder(
                itemCount: controller.categories?.length,
                padding: const EdgeInsets.all(7),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 180
                ),
                itemBuilder: (context, index) {
                  return CategoryCard(
                    categories: controller.categories?[index],
                    onTap: () {
                      Get.to(
                        () => const SpecialistsDetailScreen(),
                        arguments: controller.categories?[index],
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
