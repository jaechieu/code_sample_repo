import 'package:flutter/material.dart';
import 'package:code_sample_repo/common/config/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:code_sample_repo/explore_screen/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showMultipleOptionsModalBottomSheet({
  List<String>? options,
  List<String>? alreadySelectedOptions,
  String? alreadySelectedString,
  required BuildContext context,
  Function(List<String>)? callback,
  Function(String)? callbackString,
  String title = "",
  String description = "",
  bool tightenRow = false,
  bool? groupSize = false,
}) {
  List<int> selectedOptionIndexes = [];
  int groupSizeCnt = alreadySelectedString?.isNotEmpty == true
      ? int.parse(alreadySelectedString!)
      : 4;
  if (options != null) {
    selectedOptionIndexes = alreadySelectedOptions != null
        ? List<int>.generate(options.length, (i) => i)
            .where((i) => alreadySelectedOptions.contains(options[i]))
            .toList()
        : [];
  }
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: CodeSampleRepoColors.transparent,
    barrierColor: CodeSampleRepoColors.slightlyLightGrey.withOpacity(0.6),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                100.w * .035,
              ),
              topRight: Radius.circular(
                100.w * .035,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // ///------------------ show grey container ----------------------///
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 8,
                    ),
                    height: 3,
                    width: 48,
                    decoration: BoxDecoration(
                      color: CodeSampleRepoColors.extremelyLightGrey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  )
                ],
              ),

              BottomModalSheetTitle(
                text: title,
                margin: EdgeInsets.only(
                  left: 100.w * .05,
                  top: 100.h * .03,
                  bottom: 100.h * .005,
                ),
              ),

              if (description.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(
                    left: 100.w * .05,
                    bottom: 100.h * .02,
                  ),
                  child: Text(
                    description,
                    style: CodeSampleRepoTextPresets.sfProRegular.copyWith(
                      color: CodeSampleRepoColors.slightlyLightGrey,
                      fontSize: 100.w * .0325,
                    ),
                  ),
                ),

              if (groupSize == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BottomModalOptionSelector(
                      selectedNumberOfPeople: groupSizeCnt,
                      callback: (int newSelectedOption) {
                        setState(
                          () {
                            groupSizeCnt = newSelectedOption;
                          },
                        );
                      },
                    )
                  ],
                )
              else
                BottomModalOptionList(
                  tightenRow: tightenRow,
                  selectedOptionIndexes: selectedOptionIndexes,
                  options: options!,
                  callback: (int newSelectedOption) {
                    setState(
                      () {
                        if (selectedOptionIndexes.contains(newSelectedOption)) {
                          selectedOptionIndexes.remove(newSelectedOption);
                        } else {
                          selectedOptionIndexes.add(newSelectedOption);
                        }
                      },
                    );
                  },
                ),

              WideRoundedButton(
                text: "View Results",
                buttonColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.secondary,
                onTap: () {
                  if (groupSize == true) {
                    callbackString!(groupSizeCnt.toString());
                  } else {
                    selectedOptionIndexes.sort();
                    List<String> outputList = [];
                    for (int i = 0; i < selectedOptionIndexes.length; i++) {
                      outputList.add(options![selectedOptionIndexes[i]]);
                    }
                    callback!(outputList);
                  }
                  Navigator.pop(context);
                },
                margin: EdgeInsets.only(
                  top: 100.h * .02,
                  left: 100.w * .04,
                  right: 100.w * .04,
                ),
              ),
              // ///------------------ clear text button ----------------------///
              WideRoundedButton(
                text: "Clear",
                buttonColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.primary,
                onTap: () {
                  if (groupSize == true)
                    callbackString!("");
                  else
                    callback!([]);
                  Navigator.pop(context);
                },
                margin: EdgeInsets.only(
                  top: 100.h * .01,
                  bottom: 100.h * .02,
                  left: 100.w * .04,
                  right: 100.w * .04,
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}
