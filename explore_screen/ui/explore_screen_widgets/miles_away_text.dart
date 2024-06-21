import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_sample_repo/common/activities_cubit/index.dart';
import 'package:code_sample_repo/common/config/index.dart';
import 'package:code_sample_repo/common/users_cubit/index.dart';
import 'package:code_sample_repo/common/utils/index.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:seo_renderer/seo_renderer.dart';

class MilesAwayText extends StatefulWidget {
  const MilesAwayText({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  State<MilesAwayText> createState() => _MilesAwayTextState();
}

class _MilesAwayTextState extends State<MilesAwayText> {
  @override
  Widget build(BuildContext context) {
    final User currentUser = context.watch<UsersCubit>().getCurrentUser();
    String distanceInMilesAsString =
        currentUser.getUserDistanceAsStringIfLessThanTwentyMiles(
      Pair(
        widget.activity.latitude,
        widget.activity.longitude,
      ),
    );
    return Flexible(
      child: TextRenderer(
        text:
            "${widget.activity.neighborhood} • ${distanceInMilesAsString.isNotEmpty ? "$distanceInMilesAsString mi away" : ""}",
        child: Text(
          "${widget.activity.neighborhood} • ${distanceInMilesAsString.isNotEmpty ? "$distanceInMilesAsString mi away •" : ""} ${priceToDollarSigns(widget.activity.price)}",
          style: CodeSampleRepoTextPresets.sfProRegular.copyWith(
            fontSize: 100.w * .030,
          ),
        ),
      ),
    );
  }
}
