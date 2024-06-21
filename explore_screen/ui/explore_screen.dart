import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_sample_repo/common/activities_cubit/index.dart';
import 'package:code_sample_repo/common/design_library/index.dart';
import 'package:code_sample_repo/explore_screen/index.dart';

class ExploreScreen extends StatelessWidget {
  final String? groupType;
  const ExploreScreen({
    this.groupType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivitiesCubit, RequestState<List<Activity>>>(
      listener: (context, state) => {},
      buildWhen: (previous, current) {
        if (current.status == RequestStatus.loaded) {
          return true;
        }
        return previous.status != current.status;
      },
      builder: (context, state) {
        switch (state.status) {
          case RequestStatus.init:
            return ExploreShimmerScreen();
          case RequestStatus.loading:
            return ExploreShimmerScreen();
          case RequestStatus.loaded:
            return LoadedExploreScreen(
              listOfActivities: state.value ?? [],
              groupType: groupType,
            );
          case RequestStatus.error:
            return ErrorScreen();
        }
      },
    );
  }
}
