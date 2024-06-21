import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:code_sample_repo/common/activities_cubit/index.dart';
import 'package:code_sample_repo/common/config/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:code_sample_repo/common/users_cubit/index.dart';
import 'package:code_sample_repo/common/utils/index.dart';
import 'package:code_sample_repo/explore_screen/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:code_sample_repo/common/singletons/index.dart';

class LoadedExploreScreen extends HookWidget {
  final String? groupType;
  final List<Activity> listOfActivities;
  LoadedExploreScreen({
    required this.listOfActivities,
    this.groupType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    getUsersLatLng(
      context: context,
    );
    final floatingSearchBarController = useState(FloatingSearchBarController());
    ValueNotifier<String> searchString = useState("");
    final AdvancedFiltersNotifier advancedFiltersNotifier =
        AdvancedFiltersNotifier(
            activityGroupType: useState(groupType ?? "All"),
            locationFilter: useState("Bay Area, CA"),
            priceFilter: useState([]),
            categoryFilter: useState([]),
            dateFilter: useState("Date"),
            groupSizeFilter: useState(""));
    final List<Activity> matchedActivities = searchString.value.isEmpty
        ? listOfActivities
        : listOfActivities
            .where(
              (activity) => activity.name
                  .toLowerCase()
                  .contains(searchString.value.toLowerCase()),
            )
            .toList();

    return FloatingSearchBar(
      accentColor: Theme.of(context).colorScheme.primary,
      controller: floatingSearchBarController.value,
      autocorrect: false,
      iconColor:
          CodeSampleRepoColors.extremelyLightGrey,
      border: BorderSide(
        color:
            CodeSampleRepoColors.extremelyLightGrey,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(
        100.w * .1,
      ),
      padding: EdgeInsets.zero,
      backdropColor:
          CodeSampleRepoColors.extremelyLightGrey.withOpacity(.96),
      insets: EdgeInsets.zero,
      clearQueryOnClose: false,
      margins: EdgeInsets.only(
        top: kIsWeb
            ? 3.h
            : UniversalPlatform.isAndroid
                ? 6.h
                : 8.h,
        right: 20,
        left: 20,
      ),
      hint: "Pottery, Kayaking, Golfing...",
      hintStyle: CodeSampleRepoTextPresets.sfProRegular.copyWith(
        color:
            CodeSampleRepoColors.lightGrey,
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
      onQueryChanged: (query) {
        amplitudeSingleton.logEvent(
          event: "User typed in search bar",
          eventProperties: {"search term": query},
          context: context,
        );
        searchString.value = query;
        advancedFiltersNotifier.setActivityGroupTypeCallback("All");
      },
      onSubmitted: (query) {
        amplitudeSingleton.logEvent(
          event: "User searched for activity from search bar",
          eventProperties: {"search term": query},
          context: context,
        );
        searchString.value = query;
        advancedFiltersNotifier.setActivityGroupTypeCallback("All");
        floatingSearchBarController.value.close();
      },
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: searchString.value.isEmpty
              ? Container()
              : ColoredBox(
                  color:
                      CodeSampleRepoColors.extremelyLightGrey,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: matchedActivities.length,
                    itemBuilder: (BuildContext context, int index) {
                      Activity currentMatchedActivity =
                          matchedActivities[index];
                      return CommonInkWellWithTapPadding(
                        onTap: () {
                          searchString.value = currentMatchedActivity.name;
                          floatingSearchBarController.value.query =
                              currentMatchedActivity.name;
                          advancedFiltersNotifier
                              .setActivityGroupTypeCallback("All");
                          floatingSearchBarController.value.close();
                        },
                        child: Container(
                          key: Key("searchedActivity$index"),
                          padding: EdgeInsets.only(
                            left: 43,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            currentMatchedActivity.name,
                            style:
                                CodeSampleRepoTextPresets.sfProRegular.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 100.w * .028,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
      body: LoadedExploreScreenBody(
        listOfActivities: matchedActivities,
        advancedFiltersNotifier: advancedFiltersNotifier,
        isFilteringOrSearching: advancedFiltersNotifier.isFiltering() ||
            searchString.value.isNotEmpty,
      ),
    );
  }

  void getUsersLatLng({
    required BuildContext context,
  }) {
    final UsersCubit usersCubit = context.read<UsersCubit>();
    final User currentUser = usersCubit.getCurrentUser();
    final memoizedLocation = useMemoized(
      () {
        return getUsersLatitudeAndLongitudePair();
      },
      [currentUser.id],
    );
    final locationFuture = useFuture(memoizedLocation);

    if (locationFuture.connectionState == ConnectionState.done &&
        locationFuture.hasData) {
      currentUser.latLng = locationFuture.data;
      usersCubit.setCubit(currentUser);
    }
  }
}
