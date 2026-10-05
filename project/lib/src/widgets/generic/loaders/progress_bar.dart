import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/widgets/generic/dialog/dialog_custom.dart';

class ProgressBar extends StatelessWidget {
  final Stream? stream;
  final Color color;

  const ProgressBar({
    this.stream,
    this.color = CustomColors.lime,
    super.key
  });

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: stream,
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.data == null) {
        return Container();
      }

      ScreenPropertiesModel screenProperties = ScreenPropertiesModel(context: context);

      return DialogCustom(
        child: Row(
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(color)),
            const SizedBox(width: Sizes.margin24),
            Expanded(child: Text(snapshot.data, style: TextStyle(fontSize: screenProperties.fontSmall, color: Colors.black, fontWeight: FontWeight.normal))),
          ],
        )
      );
    },
  );
}
