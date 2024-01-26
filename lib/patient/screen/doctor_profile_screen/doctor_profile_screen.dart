import 'package:cached_network_image/cached_network_image.dart';
import 'package:doclink/patient/model/custom/categories.dart';
import 'package:doclink/patient/screen/confirm_booking_screen/confirm_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doclink/patient/common/custom_ui.dart';
import 'package:doclink/patient/generated/l10n.dart';
import 'package:doclink/patient/screen/doctor_profile_screen/doctor_profile_screen_controller.dart';
import 'package:doclink/patient/screen/doctor_profile_screen/widget/award_page.dart';
import 'package:doclink/patient/screen/doctor_profile_screen/widget/detail_page.dart';
import 'package:doclink/patient/screen/doctor_profile_screen/widget/doctor_profile_card.dart';
import 'package:doclink/patient/screen/doctor_profile_screen/widget/education_page.dart';
import 'package:doclink/patient/screen/doctor_profile_screen/widget/experience_page.dart';
import 'package:doclink/patient/screen/doctor_profile_screen/widget/list_of_category.dart';
import 'package:doclink/patient/screen/doctor_profile_screen/widget/review_page.dart';
import 'package:doclink/patient/screen/select_date_time_screen/select_date_time_screen.dart';
import 'package:doclink/utils/asset_res.dart';
import 'package:doclink/utils/color_res.dart';
import 'package:doclink/utils/const_res.dart';
import 'package:doclink/utils/extention.dart';
import 'package:doclink/utils/font_res.dart';
import 'package:doclink/utils/my_text_style.dart';
import 'package:doclink/utils/update_res.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:shared_preferences/shared_preferences.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorProfileScreenController());
    List<dynamic> args = Get.arguments;
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: CustomScrollView(
        controller: controller.scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          GetBuilder(
            init: controller,
            builder: (controller) {
              var temp = (controller.currentExtent * 0.233333);
              var size = temp < 35.0 ? 35.0 : temp;
              var o = (-1 * (size - 70)) * 0.02857143;
              var opacity = 1 - (o > 1.0 ? 1.0 : o);
              return SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                expandedHeight: controller.maxExtent,
                collapsedHeight: 60,
                stretch: true,
                shadowColor: Colors.transparent,
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1,
                  titlePadding: const EdgeInsets.all(0),
                  collapseMode: CollapseMode.pin,
                  title: Stack(
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            color: ColorRes.white,
                            padding: EdgeInsets.only(
                              bottom: 10,
                              left: Directionality.of(context) ==
                                      TextDirection.rtl
                                  ? 0.0
                                  : opacity > .8
                                      ? 10
                                      : (1 - opacity) * 56,
                              right: Directionality.of(context) !=
                                      TextDirection.rtl
                                  ? 0.0
                                  : opacity > .8
                                      ? 10
                                      : (1 - opacity) * 56,
                              top: 10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  controller.doctorData?.name ??
                                      PS.current.unKnown,
                                  style: const TextStyle(
                                      fontFamily: FontRes.extraBold,
                                      color: ColorRes.charcoalGrey,
                                      fontSize: 19),
                                ),
                                const Spacer(),
                                Visibility(
                                  visible: controller.doctorData?.rating ==
                                              null ||
                                          controller.doctorData?.rating == 0.0
                                      ? false
                                      : true,
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Container(
                                      height: 28,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: ColorRes.mangoOrange
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${controller.doctorData?.rating?.toStringAsFixed(1).toString().replaceAll('0.0', '0') ?? 0}',
                                            style: const TextStyle(
                                              color: ColorRes.mangoOrange,
                                              fontSize: 18,
                                              fontFamily: FontRes.semiBold,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(
                                            Icons.star,
                                            size: 15,
                                            color: ColorRes.mangoOrange,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Column()
                        ],
                      ),
                      SafeArea(
                        bottom: false,
                        child: Align(
                          alignment:
                              Directionality.of(context) == TextDirection.rtl
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 7,
                              top: 20,
                            ),
                            child: InkWell(
                              onTap: () {
                                Get.back(result: controller.isBackFavDoc);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: ColorRes.white,
                                    shape: BoxShape.circle),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        bottom: false,
                        child: Align(
                          alignment:
                              Directionality.of(context) == TextDirection.rtl
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 15, left: 7, top: 20),
                            child: InkWell(
                              onTap: controller.updateProfileApiCall,
                              child: GetBuilder(
                                init: controller,
                                builder: (context) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                        color: ColorRes.white,
                                        shape: BoxShape.circle),
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      controller.isFavouriteId
                                          ? Icons.bookmark
                                          : Icons.bookmark_border_rounded,
                                      color: controller.isFavouriteId
                                          ? ColorRes.havelockBlue
                                          : Colors.black,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  stretchModes: const [
                    StretchMode.zoomBackground,
                  ],
                  background: controller.doctorData?.image != null
                      ? CachedNetworkImage(
                          imageUrl:
                              '${ConstRes.itemBaseURL}${controller.doctorData?.image}',
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) {
                            return CustomUi.doctorPlaceHolder(
                                gender: controller.doctorData?.gender,
                                radius: 0);
                          },
                        )
                      : CustomUi.doctorPlaceHolder(
                          gender: controller.doctorData?.gender, radius: 0),
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: GetBuilder(
              init: controller,
              builder: (context) {
                return controller.isLoading
                    ? CustomUi.loaderWidget()
                    : Column(
                        children: [
                          Column(
                            children: [
                              DoctorProfileCard(data: controller.doctorData),
                              const SizedBox(
                                height: 10,
                              ),
                              ListOfCategory(
                                categories: controller.list,
                                onCategoryChange: controller.onCategoryChange,
                                selectedCategoryIndex:
                                    controller.selectedCategoryIndex,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              controller.selectedCategoryIndex == 0
                                  ? DetailPage(controller: controller)
                                  : controller.selectedCategoryIndex == 1
                                      ? ReviewPage(controller: controller)
                                      : controller.selectedCategoryIndex == 2
                                          ? EducationPage(
                                              controller: controller)
                                          : controller.selectedCategoryIndex ==
                                                  3
                                              ? ExperiencePage(
                                                  controller: controller)
                                              : AwardPage(
                                                  controller: controller)
                            ],
                          ),
                        ],
                      );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: MyTextStyle.linearTopGradient,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: ()async{
                      var args = Get.arguments as List;
                      if(args.length > 1){
                         DateTime currentDate = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
      String formattedTime = DateFormat('HH:mm').format(currentDate);
                        AppointmentDetail detail = AppointmentDetail(
                          date: formattedDate,
          time:  formattedTime.replaceAll(':', ''),
          problem: 'None',
          type: 0,
          patientId: controller.patientList[0]?.id,
          documents: [],
          serviceAmount: controller.doctorData?.consultationFee,
          patient_symptoms: args[1]['patient_symptoms'],
                        );
                        Get.to(()=>ConfirmBookingScreen(), arguments: [detail, controller.doctorData,args[1]]);
                      }
                      else{
                        Get.to(
                          () => SelectDateTimeScreen(addAppointment: 0),
                          arguments: [controller.doctorData, null]);
                      }
                    },
                    child: Container(
      height: MediaQuery.of(context).size.width * 0.12, // Adjust the height using a percentage of screen width
      decoration: BoxDecoration(
        color: Color(0xFFEFEFEF).withOpacity(0.15), // Adjust the color as needed
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: GetBuilder(
        init: controller,
        builder: (controller2) {
          return RichText(
            text: TextSpan(
              text: args.length > 1 ? '${PS.current.bookNow} :' : 'Schedule Booking :',
              style: MyTextStyle.montserratSemiBold(
                size: MediaQuery.of(context).size.width < 400 ? 12 
                : MediaQuery.of(context).size.width < 600 ? 14
                : MediaQuery.of(context).size.width < 960 ? 16
                : 16,
                color: Color(0xFFFFFFFF), // Adjust the text color as needed
              ),
              children: [
                TextSpan(
                  text:
                      '$dollar${(controller.doctorData?.consultationFee ?? 0).numFormat}',
                  style: MyTextStyle.montserratExtraBold(
                    size: MediaQuery.of(context).size.width < 400 ? 12 
                : MediaQuery.of(context).size.width < 600 ? 14
                : MediaQuery.of(context).size.width < 960 ? 16
                : 16,
                    color: Color(0xFFFFFFFF), // Adjust the text color as needed
                  ),
                )
              ],
            ),
          );
        },
      ),
    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: controller.onChatBtnTap,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: ColorRes.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(14),
                    child: Image.asset(
                      AssetRes.icChat,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: controller.onCallBtnTap,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: ColorRes.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: const Icon(
                      Icons.call_rounded,
                      color: ColorRes.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
