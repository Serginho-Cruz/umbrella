import '../../../utils/umbrella_palette.dart';
import 'umbrella_button.dart';

class SecondaryButton extends UmbrellaButton {
  const SecondaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.icon,
  }) : super(
          backgroundColor: UmbrellaPalette.secondaryButtonColor,
          hoverColor: UmbrellaPalette.activeSecondaryButton,
        );
}
