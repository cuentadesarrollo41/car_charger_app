import 'package:flutter/material.dart';

// Helpers.
import 'package:project/src/helpers/helper_app_update.dart';

class AppUpdateLifecycleWidget extends StatefulWidget {
  final Widget child;

  const AppUpdateLifecycleWidget({
    required this.child,
    super.key
  });

  @override
  State<AppUpdateLifecycleWidget> createState() => _AppUpdateLifecycleWidgetState();
}

class _AppUpdateLifecycleWidgetState extends State<AppUpdateLifecycleWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      if (mounted) {
        HelperAppUpdate.checkIsOutdated(context: context);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      HelperAppUpdate.checkIsOutdated(context: context);
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}