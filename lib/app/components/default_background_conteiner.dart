import 'package:flutter/widgets.dart';
import 'package:musculaquiz/app/utils/resources.dart';

class DefaultBackgroundContainer extends StatelessWidget {
  final Widget child;

  const DefaultBackgroundContainer({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            LOGIN_BACKGROUND,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: this.child,
    );
  }
}
