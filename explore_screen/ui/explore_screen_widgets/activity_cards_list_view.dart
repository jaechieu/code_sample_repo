import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:code_sample_repo/common/activities_cubit/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:code_sample_repo/explore_screen/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:io' show Platform;

class ActivityCardsListView extends StatelessWidget {
  final String? selectedGroupType;
  final List<Activity> listOfFilteredActivities;
  final bool isFavoritesList;
  final ScrollController? scrollController;
  final bool isSharedList;
  final bool isFilteringOrSearching;
  const ActivityCardsListView({
    this.listOfFilteredActivities = const [],
    this.selectedGroupType,
    this.isFavoritesList = false,
    this.scrollController,
    required this.isSharedList,
    this.isFilteringOrSearching = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: listOfFilteredActivities.isNotEmpty
          ? ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.only(
                top: 100.h * .02,
              ),
              physics: BouncingScrollPhysics(),
              shrinkWrap: false,
              itemCount: listOfFilteredActivities.length,
              itemBuilder: (BuildContext context, int index) {
                final Activity currentActivity =
                    listOfFilteredActivities[index];

                return ActivityCard(
                  key: Key("activityCard$index"),
                  activity: currentActivity,
                  isSharedList: isSharedList,
                  scrollController: scrollController,
                  cardIndex: index,
                  selectedGroupType: selectedGroupType ??
                      (currentActivity.groupTypes.isNotEmpty
                          ? currentActivity.groupTypes
                          : "All"),
                );
              },
            )
          : EmptyListText(
              text: isFavoritesList
                  ? "This will be where your favorites are"
                  : isFilteringOrSearching
                      ? "Sorry there’s no results for that search"
                      : ""),
    );
  }
}
