import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/controllers/auth_controller.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_credit_card.dart';

import '../../domain/entities/credit_card.dart';

class CreditCardStore extends Store<List<CreditCard>> {
  CreditCardStore({
    required ManageCreditCard manageCreditCard,
    required AuthController authController,
  })  : _manageCreditCard = manageCreditCard,
        _authController = authController,
        super([]);

  final ManageCreditCard _manageCreditCard;
  final AuthController _authController;
  bool _hasAll = false;

  Future<void> getAll() async {
    if (_hasAll) return;

    if (!_authController.isLogged) {
      return;
    }

    setLoading(true);

    var result = await _manageCreditCard.getAll(_authController.user!);

    result.fold((cards) {
      update(cards);
      _hasAll = true;
    }, (error) {
      setError(error);
    });

    setLoading(false);
  }
}
