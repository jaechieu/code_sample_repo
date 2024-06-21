import 'package:flutter/material.dart';
import 'package:code_sample_repo/common/config/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomModalOption extends StatelessWidget {
  final Function(int) callback;
  final bool isSelected;
  final String text;
  final int index;
  final EdgeInsetsGeometry margin;
  const BottomModalOption({
    required this.callback,
    required this.isSelected,
    required this.text,
    required this.margin,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CommonInkWellWithTapPadding(
      onTap: () {
        callback(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 100.w * .02,
        ),
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            100.w * .025,
          ),
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          border: Border.all(
            color: isSelected
                ? CodeSampleRepoColors.transparent
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: CodeSampleRepoTextPresets.sfProBold.copyWith(
            fontSize: 100.w * .028,
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
