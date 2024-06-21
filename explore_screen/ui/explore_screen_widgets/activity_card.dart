import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:code_sample_repo/activity_screen/index.dart';
import 'package:code_sample_repo/common/activities_cubit/index.dart';
import 'package:code_sample_repo/common/config/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:code_sample_repo/common/singletons/index.dart';
import 'package:code_sample_repo/common/utils/index.dart';
import 'package:code_sample_repo/explore_screen/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:seo_renderer/seo_renderer.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final String selectedGroupType;
  final bool isSharedList;
  final ScrollController? scrollController;
  final int cardIndex;

  const ActivityCard({
    required this.activity,
    required this.selectedGroupType,
    required this.isSharedList,
    this.scrollController,
    required this.cardIndex,
    super.key,
  });

  Widget build(BuildContext context) {
    final int profilePhotoIndex = activity.getIndexOfProfilePhoto(
      selectedGroupType: selectedGroupType,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        amplitudeSingleton.logEvent(
          event: "user went to activity screen",
          eventProperties: {
            "Activity Name": activity.name,
            "Activity Id": activity.id
          },
          context: context,
        );
        context.pushNamed(
          ActivityScreen.name,
          pathParameters: {
            "activityId": activity.id,
          },
          queryParameters: {
            if (profilePhotoIndex != 0)
              "profilePhotoIndex": profilePhotoIndex.toString(),
          },
          extra: isSharedList,
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          right: 100.w * .07,
          left: 100.w * .07,
          bottom: 100.h * .028,
        ),
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: groupTypeToColor(context, selectedGroupType) ==
                              Theme.of(context).colorScheme.primary
                          ? CodeSampleRepoColors.transparent
                          : groupTypeToColor(
                              context,
                              selectedGroupType,
                            ),
                    ),
                    borderRadius: BorderRadius.circular(
                      100.w * .019,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      100.w * .015,
                    ),
                    child: kIsWeb
                        ? RetryNetworkImage(
                            activity.getPhoto(
                              profilePhotoIndex,
                            ),
                            height: 24.h,
                            width: double.maxFinite,
                            fit: BoxFit.cover,
                          )
                        : CommonActivityImageSwiper(
                            activity: activity,
                            selectedGroupType: selectedGroupType,
                            height: 24.h,
                            scrollController: scrollController,
                            initialIndex: profilePhotoIndex,
                            cardIndex: cardIndex,
                            autoplay: false,
                          ),
                  ),
                ),
                if (kIsWeb == false && !isSharedList)
                  FavoriteIcon(
                    activity: activity,
                    iconColor: CodeSampleRepoColors.white,
                    useMargin: true,
                  ),
              ],
            ),

            Container(
              margin: EdgeInsets.only(
                top: 0.8.h,
                bottom: 0.8.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///------------------ trip name ----------------------///
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: isTest() ? double.infinity : 65.w,
                    ),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: TextRenderer(
                        text: activity.name,
                        child: Text(
                          activity.name,
                          softWrap: true,
                          style: CodeSampleRepoTextPresets.sfProBold.copyWith(
                            fontSize: 3.2.w,
                            color: groupTypeToColor(
                              context,
                              selectedGroupType,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),

                  ///------------------ rating name ----------------------///
                  CommonRowWithStarAndRating(
                    rating: activity.rating,
                    ratingSampleSize: activity.ratingSampleSize,
                  )
                ],
              ),
            ),

            ///------------------ show mi away and ppl ----------------------///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ///------------------ show  mi away text ----------------------///
                MilesAwayText(
                  activity: activity,
                ),

                ///------------------ show ppl text ----------------------///
                Text(
                  activity.minPeople < activity.maxPeople
                      ? "${activity.minPeople} - ${activity.maxPeople} ppl"
                      : "${activity.minPeople} ppl",
                  style: CodeSampleRepoTextPresets.sfProRegular.copyWith(
                    fontSize: 100.w * .030,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
