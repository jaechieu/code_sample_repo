import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_sample_repo/booking_screen/index.dart';
import 'package:code_sample_repo/common/activities_cubit/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:code_sample_repo/common/users_cubit/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FavoriteIcon extends StatefulWidget {
  final Activity activity;
  final Color? iconColor;
  final bool useMargin;
  const FavoriteIcon({
    required this.activity,
    this.iconColor,
    this.useMargin = false,
    super.key,
  });

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    final User currentUser = context.watch<UsersCubit>().getCurrentUser();
    bool isFavorited =
        currentUser.isActivityInFirstFavoriteList(widget.activity);

    return Container(
      margin: widget.useMargin
          ? EdgeInsets.only(
              top: 100.h * .012,
              right: 100.w * .012,
            )
          : null,
      child: Align(
        alignment: Alignment(0.95, 1),
        child: CommonInkWellWithTapPadding(
          tapPadding: 10,
          onTap: () {
            blockFunctionIfWeb(
              function: () {
                setState(() {
                  isFavorited = !isFavorited;
                });
                handleFavoriteIconOntap(
                    context: context, activity: widget.activity);
              },
              context: context,
            );
          },
          child: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            size: 100.w * .065,
            color: widget.iconColor,
          ),
        ),
      ),
    );
  }
}
