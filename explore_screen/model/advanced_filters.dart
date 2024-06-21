import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_sample_repo/common/activities_cubit/index.dart';
import 'package:code_sample_repo/common/singletons/index.dart';
import 'package:code_sample_repo/common/utils/index.dart';

class AdvancedFiltersNotifier {
  ValueNotifier<String> activityGroupType;
  ValueNotifier<String> locationFilter;
  ValueNotifier<List<String>> priceFilter;
  ValueNotifier<List<String>> categoryFilter;
  ValueNotifier<String> dateFilter;
  ValueNotifier<String> groupSizeFilter;

  AdvancedFiltersNotifier({
    required this.activityGroupType,
    required this.locationFilter,
    required this.priceFilter,
    required this.categoryFilter,
    required this.dateFilter,
    required this.groupSizeFilter,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdvancedFiltersNotifier &&
          runtimeType == other.runtimeType &&
          activityGroupType.value == other.activityGroupType.value &&
          locationFilter.value == other.locationFilter.value &&
          priceFilter.value == other.priceFilter.value &&
          categoryFilter.value == other.categoryFilter.value &&
          dateFilter.value == other.dateFilter.value &&
          groupSizeFilter.value == other.groupSizeFilter.value;
  @override
  int get hashCode {
    return activityGroupType.value.hashCode;
  }

  // ignore: use_setters_to_change_properties
  void setActivityGroupTypeCallback(String newCategory) {
    amplitudeSingleton.logEvent(
      event: "User changed category",
      eventProperties: {"selected category": newCategory},
    );
    activityGroupType.value = newCategory;
  }

  // ignore: use_setters_to_change_properties
  void setLocationFilterCallback(String newLocation) {
    locationFilter.value =
        newLocation.isNotEmpty ? newLocation : "Bay Area, CA";
  }

  // ignore: use_setters_to_change_properties
  void setPriceFilterCallback(List<String> newPriceList) {
    priceFilter.value = newPriceList;
  }

  // ignore: use_setters_to_change_properties
  void setCategoryFilterCallback(List<String> newCategoryList) {
    categoryFilter.value = newCategoryList;
  }

  // ignore: use_setters_to_change_properties
  void setDateFilterCallback(String newDate) {
    dateFilter.value =
        newDate.isNotEmpty && dateFilter.value != newDate ? newDate : "Date";
  }

  void setGroupSizeFilterCallback(String newGroupSize) {
    groupSizeFilter.value = newGroupSize.isNotEmpty ? newGroupSize : "";
  }

  bool isGroupTypeFiltering() {
    return activityGroupType.value != "All";
  }

  bool isLocationFiltering() {
    return locationFilter.value != "Location";
  }

  bool isPriceFiltering() {
    return priceFilter.value.isNotEmpty;
  }

  bool isCategoryFiltering() {
    return categoryFilter.value.isNotEmpty;
  }

  bool isDateFiltering() {
    return dateFilter.value != "Date";
  }

  bool isGroupSizeFiltering() {
    return groupSizeFilter.value.isNotEmpty;
  }

  bool isFiltering() {
    return isGroupTypeFiltering() ||
        isPriceFiltering() ||
        isCategoryFiltering() ||
        isDateFiltering() ||
        isGroupSizeFiltering();
  }

  List<Activity> filterListOfActivities(
      List<Activity> listOfActivities, BuildContext context) {
    List<Activity> filteredList = List.from(listOfActivities);

    if (isGroupTypeFiltering()) {
      filteredList = filteredList
          .where(
            (activity) => activity.groupTypes
                .toLowerCase()
                .replaceSpacesAndConvertCSVToList()
                .contains(
                  activityGroupType.value.toLowerCase(),
                ),
          )
          .toList();

      final ActivitiesCubit activityCubit = context.read<ActivitiesCubit>();
      filteredList = activityCubit.shuffleActivities(filteredList);
    }

    if (isPriceFiltering()) {
      filteredList = filteredList.where((activity) {
        return priceFilter.value.contains(priceToDollarSigns(activity.price));
      }).toList();
    }

    if (isCategoryFiltering()) {
      filteredList = filteredList.where(
        (activity) {
          List<String> copyOfCategoryFilters = List.from(categoryFilter.value);

          copyOfCategoryFilters = copyOfCategoryFilters
              .map((e) => e.toLowerCase().replaceAll(" ", ""))
              .toList();
          for (final tag in activity.tags) {
            if (copyOfCategoryFilters
                .contains(tag.toLowerCase().replaceAll(" ", ""))) {
              return true;
            }
          }
          return false;
        },
      ).toList();
    }
    if (isDateFiltering()) {
      filteredList = filteredList
          .where(
            (activity) => activity.datetimes.any(
              (activtyDateTime) => isDateTimesSameDay(activtyDateTime,
                  formatMonthAndDayStringToDateTime(dateFilter.value)),
            ),
          )
          .toList();
    }

    if (isGroupSizeFiltering()) {
      filteredList = filteredList
          .where((activity) =>
              activity.minPeople <= int.parse(groupSizeFilter.value) &&
              int.parse(groupSizeFilter.value) <= activity.maxPeople)
          .toList();
    }

    return filteredList;
  }
}
