import 'package:flutter/material.dart';
import 'package:code_sample_repo/activity_screen/index.dart';
import 'package:code_sample_repo/common/utils/index.dart';
import 'package:code_sample_repo/explore_screen/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdvancedFiltersRow extends StatelessWidget {
  final AdvancedFiltersNotifier advancedFiltersNotifier;
  const AdvancedFiltersRow({
    required this.advancedFiltersNotifier,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: [
          FilterTab(
            text: advancedFiltersNotifier.locationFilter.value,
            margin: EdgeInsets.symmetric(
              horizontal: 100.w * .02,
              vertical: 100.h * .009,
            ),
            onTap: () {
              // TODO add support later when we support more areas
              // advancedFiltersNotifier
              //     .setLocationFilterCallback("Bay Area, CA");
              showSnackBarMessage(
                context: context,
                message: "More areas coming soon!",
              );
            },
            isFiltering: advancedFiltersNotifier.isLocationFiltering(),
          ),
          FilterTab(
            text: advancedFiltersNotifier.priceFilter.value.isNotEmpty
                ? advancedFiltersNotifier.priceFilter.value.join(",")
                : "Price",
            margin: EdgeInsets.only(
              right: 100.w * .02,
              top: 100.h * .009,
              bottom: 100.h * .009,
            ),
            onTap: () => showMultipleOptionsModalBottomSheet(
              title: "Price",
              tightenRow: true,
              context: context,
              callback: advancedFiltersNotifier.setPriceFilterCallback,
              options: code_sample_repoConstants.pricesOptionList,
              alreadySelectedOptions: advancedFiltersNotifier.priceFilter.value,
            ),
            isFiltering: advancedFiltersNotifier.isPriceFiltering(),
          ),
          FilterTab(
            text: advancedFiltersNotifier.categoryFilter.value.isNotEmpty
                ? advancedFiltersNotifier.categoryFilter.value.join(", ")
                : "Categories",
            margin: EdgeInsets.only(
              right: 100.w * .02,
              top: 100.h * .009,
              bottom: 100.h * .009,
            ),
            onTap: () => showMultipleOptionsModalBottomSheet(
              title: "Categories",
              tightenRow: true,
              context: context,
              callback: advancedFiltersNotifier.setCategoryFilterCallback,
              options: code_sample_repoConstants.categoriesOptionList,
              alreadySelectedOptions:
                  advancedFiltersNotifier.categoryFilter.value,
            ),
            isFiltering: advancedFiltersNotifier.isCategoryFiltering(),
          ),
          FilterTab(
            text: advancedFiltersNotifier.groupSizeFilter.value.isNotEmpty
                ? advancedFiltersNotifier.groupSizeFilter.value.toString() +
                    " People"
                : "Group Size",
            margin: EdgeInsets.only(
              right: 100.w * .02,
              top: 100.h * .009,
              bottom: 100.h * .009,
            ),
            onTap: () => showMultipleOptionsModalBottomSheet(
              title: "Group Size",
              groupSize: true,
              context: context,
              callbackString:
                  advancedFiltersNotifier.setGroupSizeFilterCallback,
              alreadySelectedString:
                  advancedFiltersNotifier.groupSizeFilter.value,
            ),
            isFiltering: advancedFiltersNotifier.isGroupSizeFiltering(),
          ),
          FilterTab(
            text: advancedFiltersNotifier.dateFilter.value,
            margin: EdgeInsets.only(
              right: 100.w * .02,
              top: 100.h * .009,
              bottom: 100.h * .009,
            ),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) => SelectDateCalendarDialog(
                  selectedDateTimeString:
                      advancedFiltersNotifier.dateFilter.value,
                  datetimeCallBack: (String newTime) async {
                    advancedFiltersNotifier.setDateFilterCallback(
                      newTime,
                    );
                  },
                ),
              );
            },
            isFiltering: advancedFiltersNotifier.isDateFiltering(),
          ),
        ],
      ),
    );
  }
}
