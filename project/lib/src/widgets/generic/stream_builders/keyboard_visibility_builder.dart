import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Widget.
import 'package:project/src/widgets/generic/containers/conditional_widget.dart';

class KeyboardVisibilityBuilder extends StatelessWidget {
  final Widget child;
  final bool showIfVisible;

  const KeyboardVisibilityBuilder({
    required this.child,
    this.showIfVisible = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    return StreamBuilder<bool>(
      stream: stateBloc.keyboardIsShownStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) => ConditionalWidget(
        showChild: showIfVisible || !stateBloc.keyboardIsShown,
        createChild: () => child
      )
    );
  }
}
