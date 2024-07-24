import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/paiyable_store.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/paiyable.dart';
import '../../domain/models/paiyable_model.dart';

class PaymentScreen<E extends Paiyable, T extends PaiyableModel<E>>
    extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.model,
    required this.store,
    this.isCreditAllowed = true,
    this.unallowedCard,
  });

  final T model;
  final PaiyableStore<E, T> store;
  final bool isCreditAllowed;
  final CreditCard? unallowedCard;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
