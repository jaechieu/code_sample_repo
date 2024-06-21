import 'package:flutter/material.dart';
import 'package:code_sample_repo/common/config/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:seo_renderer/seo_renderer.dart';

class CategoryTab extends StatelessWidget {
  final String tabText;
  final Function() tabCallback;
  final Color tabColor;
  final bool isSelected;

  const CategoryTab({
    required this.tabText,
    required this.tabCallback,
    required this.tabColor,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CommonInkWellWithTapPadding(
        onTap: () {
          tabCallback();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ///------------------ text ----------------------///
            TextRenderer(
              text: tabText,
              child: Text(
                tabText,
                style: isSelected
                    ? CodeSampleRepoTextPresets.sfProBold.copyWith(
                        color: tabColor,
                        fontSize: 100.w * .03,
                      )
                    : CodeSampleRepoTextPresets.sfProRegular.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 100.w * .031,
                      ),
              ),
            ),

            if (isSelected)
              Container(
                margin: EdgeInsets.only(
                  top: 9,
                ),
                width: double.maxFinite,
                height: 100.w * .006,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(
                    100.w * .1,
                  ),
                ),
              ),
            if (isSelected == false)
              Text(
                "•",
                style: CodeSampleRepoTextPresets.sfProBold.copyWith(
                  color: tabColor,
                  fontSize: 100.w * .035,
                ),
              )
          ],
        ),
      ),
    );
  }
}
