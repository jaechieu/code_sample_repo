import 'package:flutter/material.dart';
import 'package:code_sample_repo/common/config/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomModalSheetTitle extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry margin;

  const BottomModalSheetTitle({
    required this.text,
    required this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        text,
        style: CodeSampleRepoTextPresets.sfProBold.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 100.w * .038,
        ),
      ),
    );
  }
}
