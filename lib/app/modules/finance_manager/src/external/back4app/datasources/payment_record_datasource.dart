import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_record.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/payment_record_datasource.dart';

import '../../../domain/entities/date.dart';
import '../functions.dart';
import '../mappers/payment_record_mapper.dart';
import '../parse_objects.dart';

class Back4AppPaymentRecordDatasource implements PaymentRecordDatasource {
  @override
  Future<String> register(
    PaymentRecord<Paiyable> record,
    Account account,
  ) async {
    var object = PaymentRecordMapper.toParse(record, noId: true);

    var response = await object.create();

    if (isResponseSuccesful(response)) {
      return (response.results!.first as ParseObject).objectId!;
    }

    throw extractFail(response);
  }

  @override
  Future<List<PaymentRecord<Paiyable>>> getAllOf({
    required Account account,
    required int month,
    required int year,
  }) async {
    var query = QueryBuilder(PaymentRecordObject());

    DateTime firstDay = DateTime(year, month);
    DateTime lastDay =
        firstDay.copyWith(day: Date.totalDaysOnMonth(month, year));

    query.whereGreaterThanOrEqualsTo('date', firstDay);
    query.whereLessThanOrEqualTo('date', lastDay);

    var response = await query.query();

    if (isResponseSuccesful(response)) {
      return (response.results as List<ParseObject>)
          .map(PaymentRecordMapper.fromParse)
          .toList();
    }

    throw extractFail(response);
  }

  @override
  Future<void> deleteAllOf(Paiyable paiyable) {
    // TODO: implement deleteAllOf
    throw UnimplementedError();
  }
}
