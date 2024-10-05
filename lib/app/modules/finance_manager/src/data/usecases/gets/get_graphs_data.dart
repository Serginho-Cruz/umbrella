import 'package:result_dart/result_dart.dart';
import 'dart:math' show Random;

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/category.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../../domain/usecases/gets/get_graphs_data.dart';

class GetGraphsDataImpl implements GetGraphsData {
  @override
  AsyncResult<Map<Category, double>, Fail> valueOfEachExpenseCategory(
    List<Account> accounts,
  ) {
    Map<Category, double> map = {};

    const categories = [
      Category(id: 'aa', icon: 'alimentation.png', name: 'Alimentação'),
      Category(id: 'bb', icon: 'bill.png', name: 'Conta'),
      Category(id: 'cc', icon: 'celebration.png', name: 'Comemoração'),
      Category(id: 'dd', icon: 'clothing.png', name: 'Vestimenta'),
      Category(id: 'ee', icon: 'cosmetics.png', name: 'Cosméticos'),
      Category(id: 'ff', icon: 'health.png', name: 'Saúde'),
      Category(id: 'gg', icon: 'home.png', name: 'Moradia'),
      Category(id: 'hh', icon: 'others.png', name: 'Outros'),
      Category(id: 'ii', icon: 'repairs.png', name: 'Reparos'),
      Category(id: 'jj', icon: 'study.png', name: 'Estudo'),
      Category(id: 'kk', icon: 'transport.png', name: 'Transporte'),
    ];

    for (var category in categories) {
      map[category] = Random().nextDouble() * 300;
    }

    map.removeWhere((_, value) => value == 0);

    return Future.delayed(const Duration(seconds: 2), () => Success(map));
  }

  @override
  AsyncResult<Map<Category, double>, Fail> valueOfEachIncomeCategory(
    List<Account> accounts,
  ) {
    Map<Category, double> map = {};

    const categories = [
      Category(id: 'aa', icon: 'alimentation.png', name: 'Alimentação'),
      Category(id: 'bb', icon: 'bill.png', name: 'Conta'),
      Category(id: 'cc', icon: 'celebration.png', name: 'Comemoração'),
      Category(id: 'dd', icon: 'clothing.png', name: 'Vestimenta'),
      Category(id: 'ee', icon: 'cosmetics.png', name: 'Cosméticos'),
      Category(id: 'ff', icon: 'health.png', name: 'Saúde'),
      Category(id: 'gg', icon: 'home.png', name: 'Moradia'),
      Category(id: 'hh', icon: 'others.png', name: 'Outros'),
      Category(id: 'ii', icon: 'repairs.png', name: 'Reparos'),
      Category(id: 'jj', icon: 'study.png', name: 'Estudo'),
      Category(id: 'kk', icon: 'transport.png', name: 'Transporte'),
    ];

    for (var category in categories) {
      map[category] = Random().nextDouble() * 500;
    }

    map.removeWhere((_, value) => value == 0);

    return Future.delayed(const Duration(seconds: 2), () => Success(map));
  }

  @override
  AsyncResult<Map<String, double>, Fail> valueOfEachPerson(
    List<Account> accounts,
  ) {
    // TODO: implement valueOfEachPerson
    throw UnimplementedError();
  }

  @override
  AsyncResult<Map<PaymentMethod, double>, Fail> valuePaidWithEachMethod(
    List<Account> accounts,
  ) {
    // TODO: implement valuePaidWithEachMethod
    throw UnimplementedError();
  }
}
