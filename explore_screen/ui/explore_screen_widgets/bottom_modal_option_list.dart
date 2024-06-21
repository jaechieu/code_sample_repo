import 'package:flutter/material.dart';
import 'package:code_sample_repo/explore_screen/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomModalOptionList extends StatelessWidget {
  final Function(int) callback;
  final List<String> options;
  final List<int> selectedOptionIndexes;
  final bool tightenRow;
  const BottomModalOptionList({
    required this.callback,
    required this.selectedOptionIndexes,
    required this.options,
    this.tightenRow = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> columnChildren = [];
    List<Widget> rowWidgets = [];

    for (var i = 0; i < options.length; i++) {
      final Widget currentBottomModalOptionWidget = BottomModalOption(
        index: i,
        callback: callback,
        isSelected: selectedOptionIndexes.contains(i),
        margin: EdgeInsets.only(
          right: 100.w * .02,
          top: 100.h * .02,
        ),
        text: options[i],
      );
      rowWidgets.add(
        Flexible(
          fit: FlexFit.tight,
          flex: options[i] == "Exclusively On CodeSampleRepo"
              ? 4
              : tightenRow
                  ? 1
                  : 2,
          child: currentBottomModalOptionWidget,
        ),
      );
      if (rowWidgets.length == 4) {
        columnChildren.add(
          Row(
            children: rowWidgets,
          ),
        );
        rowWidgets = [];
      } else if (options[i] == "Exclusively On CodeSampleRepo" ||
          i + 1 == options.length) {
        rowWidgets.add(
          Flexible(
            flex: 4 - rowWidgets.length,
            child: SizedBox(),
          ),
        );
        columnChildren.add(
          Row(
            children: rowWidgets,
          ),
        );
        rowWidgets = [];
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 100.w * .04,
      ),
      child: Column(
        children: columnChildren,
      ),
    );
  }
}
