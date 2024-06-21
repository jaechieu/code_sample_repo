import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:code_sample_repo/common/utils/index.dart';
import 'package:code_sample_repo/explore_screen/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupTypeTabRow extends StatelessWidget {
  const GroupTypeTabRow({
    super.key,
    required this.setActivityGroupTypeCallback,
    required this.activityGroupType,
  });

  final Function(String) setActivityGroupTypeCallback;
  final String activityGroupType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: kIsWeb ? 12.h : 14.5.h,
        bottom: 100.h * .014,
        right: 100.w * .01,
        left: 100.w * .01,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final String groupType
              in code_sample_repoConstants.groupTypesOptionList)
            CategoryTab(
              tabText: groupType,
              tabCallback: () => setActivityGroupTypeCallback(groupType),
              tabColor: groupTypeToColor(context, groupType),
              isSelected: activityGroupType == groupType,
            ),
        ],
      ),
    );
  }
}
