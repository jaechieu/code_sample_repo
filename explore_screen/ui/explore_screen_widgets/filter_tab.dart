import 'package:flutter/material.dart';
import 'package:code_sample_repo/common/config/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FilterTab extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry margin;
  final Function() onTap;
  final bool isFiltering;

  const FilterTab({
    required this.text,
    required this.margin,
    required this.onTap,
    this.isFiltering = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CommonInkWellWithTapPadding(
      onTap: () => onTap(),
      child: Container(
        height: 100.w * .085,
        margin: margin,
        padding: EdgeInsets.symmetric(
          horizontal: 100.w * .045,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            100.w * .028,
          ),
          color: isFiltering
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          border: Border.all(
            color: isFiltering
                ? CodeSampleRepoColors.transparent
                : CodeSampleRepoColors.slightlyLightGrey,
          ),
        ),
        child: Text(
          text,
          style: isFiltering
              ? CodeSampleRepoTextPresets.sfProBold.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 100.w * .03,
                )
              : CodeSampleRepoTextPresets.sfProRegular.copyWith(
                  color: CodeSampleRepoColors.slightlyLightGrey,
                  fontSize: 100.w * .03,
                ),
        ),
      ),
    );
  }
}
