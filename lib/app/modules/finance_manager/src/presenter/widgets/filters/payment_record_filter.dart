import 'package:flutter/material.dart';

import '../../stores/payment_record_store.dart';
import '../buttons/filter_button.dart';
import '../dialogs/payment_record_filter_dialog.dart';
import 'umbrella_search_bar.dart';

class PaymentRecordFilter extends StatelessWidget {
  const PaymentRecordFilter({super.key, required this.recordStore});

  final PaymentRecordStore recordStore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UmbrellaSearchBar(
          onSubmitted: recordStore.setNameFilter,
          onChanged: recordStore.setNameFilter,
          width: MediaQuery.sizeOf(context).width * 0.9 - 75.0,
          height: 50.0,
        ),
        FilterButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => PaymentRecordFilterDialog(
                recordStore: recordStore,
              ),
            );
          },
        ),
      ],
    );
  }
}
