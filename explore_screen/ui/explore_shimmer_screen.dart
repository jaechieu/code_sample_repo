import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:code_sample_repo/common/config/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:code_sample_repo/explore_screen/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:universal_platform/universal_platform.dart';

class ExploreShimmerScreen extends StatelessWidget {
  const ExploreShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      accentColor: Theme.of(context).colorScheme.primary,
      iconColor:
          // isDarkMode(context)
          //     ? CodeSampleRepoColors.darkGrey
          //     :
          CodeSampleRepoColors.extremelyLightGrey,
      border: BorderSide(
        color:
            // isDarkMode(context)
            //     ? CodeSampleRepoColors.darkGrey
            //     :
            CodeSampleRepoColors.extremelyLightGrey,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(
        100.w * .1,
      ),
      padding: EdgeInsets.zero,
      backdropColor:
          // isDarkMode(context)
          // ? CodeSampleRepoColors.grey.withOpacity(.96)
          // :
          Theme.of(context).colorScheme.secondary.withOpacity(.96),
      insets: EdgeInsets.zero,
      margins: EdgeInsets.only(
        top: kIsWeb
            ? 3.h
            : UniversalPlatform.isAndroid
                ? 6.h
                : 7.h,
        right: 20,
        left: 20,
      ),
      hint: "Pottery, Kayaking, Golfing...",
      hintStyle: CodeSampleRepoTextPresets.sfProRegular.copyWith(
        color: CodeSampleRepoColors.lightGrey,
        fontSize: 100.w * .031,
      ),
      openAxisAlignment: 0.0,
      elevation: 0,
      width: 600,
      scrollPadding: EdgeInsets.only(top: 16, bottom: 20),
      physics: BouncingScrollPhysics(),
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 500),
      transition: CircularFloatingSearchBarTransition(),
      debounceDelay: Duration(milliseconds: 500),
      actions: const [],
      automaticallyImplyBackButton: false,
      leadingActions: [
        FloatingSearchBarAction.searchToClear(),
      ],
      queryStyle: CodeSampleRepoTextPresets.sfProBold.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 100.w * .031,
      ),
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(),
        );
      },
      body: Column(
        children: [
          GroupTypeTabRow(
            setActivityGroupTypeCallback: (String) {},
            activityGroupType: "",
          ),
          CommonDivider(
            height: 0.75.h,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: [
                FilterTab(
                  text: "Location",
                  margin: EdgeInsets.symmetric(
                    horizontal: 100.w * .02,
                    vertical: 100.h * .009,
                  ),
                  onTap: () {},
                ),
                FilterTab(
                  text: "Price",
                  margin: EdgeInsets.only(
                    right: 100.w * .02,
                    top: 100.h * .009,
                    bottom: 100.h * .009,
                  ),
                  onTap: () => {},
                ),
                FilterTab(
                  text: "Categories",
                  margin: EdgeInsets.only(
                    right: 100.w * .02,
                    top: 100.h * .009,
                    bottom: 100.h * .009,
                  ),
                  onTap: () => {},
                ),
                FilterTab(
                  text: "Group Size",
                  margin: EdgeInsets.only(
                    right: 100.w * .02,
                    top: 100.h * .009,
                    bottom: 100.h * .009,
                  ),
                  onTap: () => {},
                ),
                FilterTab(
                  text: "Date",
                  margin: EdgeInsets.only(
                    right: 100.w * .02,
                    top: 100.h * .009,
                    bottom: 100.h * .009,
                  ),
                  onTap: () async {},
                ),
              ],
            ),
          ),
          CommonDivider(
            height: 0.75.h,
          ),
          ShimmerRectangle(
            minHeight: 100.h * 0.25,
            minWidth: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.only(top: 2.h),
          ),
          ShimmerRectangle(
            minHeight: 100.h * 0.25,
            minWidth: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.only(top: 2.h),
          )
        ],
      ),
    );
  }
}
