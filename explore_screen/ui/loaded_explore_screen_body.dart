import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:code_sample_repo/common/activities_cubit/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:code_sample_repo/explore_screen/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoadedExploreScreenBody extends HookWidget {
  final List<Activity> listOfActivities;
  final AdvancedFiltersNotifier advancedFiltersNotifier;
  final bool isFilteringOrSearching;
  const LoadedExploreScreenBody({
    required this.listOfActivities,
    required this.advancedFiltersNotifier,
    required this.isFilteringOrSearching,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useScrollController();
    useEffect(() {
      return () {
        if (controller.hasClients) {
          controller.jumpTo(0);
        }
      };
    }, [advancedFiltersNotifier.activityGroupType.value]);

    return Column(
      children: [
        GroupTypeTabRow(
          setActivityGroupTypeCallback:
              advancedFiltersNotifier.setActivityGroupTypeCallback,
          activityGroupType: advancedFiltersNotifier.activityGroupType.value,
        ),
        CommonDivider(
          height: 0.75.h,
        ),
        AdvancedFiltersRow(
          advancedFiltersNotifier: advancedFiltersNotifier,
        ),
        CommonDivider(
          height: 0.75.h,
        ),
        ActivityCardsListView(
          listOfFilteredActivities: advancedFiltersNotifier
              .filterListOfActivities(listOfActivities, context),
          selectedGroupType: advancedFiltersNotifier.activityGroupType.value,
          scrollController: controller,
          isSharedList: false,
          isFilteringOrSearching: isFilteringOrSearching,
        ),
      ],
    );
  }
}
