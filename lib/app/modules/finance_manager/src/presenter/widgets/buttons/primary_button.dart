import '../../../utils/umbrella_palette.dart';
import 'umbrella_button.dart';

class PrimaryButton extends UmbrellaButton {
  const PrimaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.width,
    super.height,
    super.icon,
  }) : super(
          backgroundColor: UmbrellaPalette.actionButtonColor,
          hoverColor: UmbrellaPalette.activePrimaryButton,
        );
}
