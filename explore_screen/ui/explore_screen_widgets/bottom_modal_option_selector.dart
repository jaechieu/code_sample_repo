import 'dart:math';

import 'package:flutter/material.dart';
import 'package:code_sample_repo/common/config/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomModalOptionSelector extends StatefulWidget {
  static const int minPeople = 1;
  static const int maxPeople = 50;

  final Function(int) callback;
  int selectedNumberOfPeople;

  BottomModalOptionSelector({
    required this.callback,
    required this.selectedNumberOfPeople,
    Key? key,
  }) : super(key: key);

  @override
  _BottomModalOptionSelectorState createState() =>
      _BottomModalOptionSelectorState();
}

class _BottomModalOptionSelectorState extends State<BottomModalOptionSelector> {
  @override
  void initState() {
    super.initState();
  }

  void setNumberOfPeopleCallback(int newNumberOfPeople) {
    setState(
      () {
        widget.selectedNumberOfPeople =
            newNumberOfPeople > BottomModalOptionSelector.minPeople
                ? min(newNumberOfPeople, BottomModalOptionSelector.maxPeople)
                : BottomModalOptionSelector.minPeople;
        widget.callback(widget.selectedNumberOfPeople);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ///------------------ enter number of people ----------------------///

      Container(
        child: Text(
          "Select group size",
          textAlign: TextAlign.center,
          style: CodeSampleRepoTextPresets.sfProRegular.copyWith(
            color: CodeSampleRepoColors.grey,
            fontSize: 2.8.w,
          ),
        ),
        margin: EdgeInsets.only(
          top: 100.h * .02,
        ),
      ),

      Container(
        margin: EdgeInsets.only(
          bottom: 100.h * .05,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 100.h * .004,
          horizontal: 100.w * .0156,
        ),
        alignment: Alignment.center,
        width: 100.w * .6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.w * .09),
          border: Border.all(
            color: CodeSampleRepoColors.lightGrey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///------------------ show minus icon ----------------------///
            CommonInkWellWithTapPadding(
              tapPadding: 5,
              onTap: () => setNumberOfPeopleCallback(
                widget.selectedNumberOfPeople - 1,
              ),
              child: CommonImageAsset(
                color: widget.selectedNumberOfPeople ==
                        BottomModalOptionSelector.minPeople
                    ? CodeSampleRepoColors.lightGrey
                    : null,
                assetPath: "assets/icons/minus_icon.png",
              ),
            ),

            ///------------------ number of people show ----------------------///
            HeaderText(
              text: "${widget.selectedNumberOfPeople}",
              textStyle: CodeSampleRepoTextPresets.sfProRegular.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 3.5.w,
              ),
            ),

            ///------------------ show plus icon ----------------------///
            CommonInkWellWithTapPadding(
              tapPadding: 5,
              onTap: () => setNumberOfPeopleCallback(
                widget.selectedNumberOfPeople + 1,
              ),
              child: CommonImageAsset(
                  color: widget.selectedNumberOfPeople ==
                          BottomModalOptionSelector.maxPeople
                      ? CodeSampleRepoColors.lightGrey
                      : null,
                  assetPath: "assets/icons/plus_icon.png"),
            ),
          ],
        ),
      )
    ]);
  }
}
