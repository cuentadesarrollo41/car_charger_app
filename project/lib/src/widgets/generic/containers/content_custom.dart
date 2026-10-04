import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/session_model.dart';

class ContentCustom extends StatelessWidget {
  final Widget Function() createChild;
  final bool safeBottom;

  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  const ContentCustom({
    required this.createChild,
    this.safeBottom = false,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.topPadding = 0,
    this.bottomPadding = 0,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    return StreamBuilder<SessionModel>(
      stream: stateBloc.sessionStream,
      builder: (BuildContext context, AsyncSnapshot<SessionModel> snapshot) => SafeArea(
        bottom: safeBottom,
        child: _createContainer(
          createChild()
        )
      )
    );
  }

  // Method that creates the title.
  Widget _createContainer(Widget child) => Container(
    width: double.infinity,
    padding: EdgeInsets.only(
      left: leftPadding,
      right: rightPadding,
      top: topPadding,
      bottom: bottomPadding,
    ),
    child: child
  );
}
