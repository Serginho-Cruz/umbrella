import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/expense_parcel_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/income_parcel_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/expense_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/income_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/expense_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/horizontal_listview.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/horizontal_infinity_container.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/income_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/shimmer/shimmer_finance_card.dart';

import '../widgets/horizontal_animated_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final IncomeStore _incomeStore = IncomeStore();
  final ExpenseStore _expenseStore = ExpenseStore();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GlobalKey<AnimatedListState> _incomeListKey = GlobalKey();
  late final GlobalKey<AnimatedListState> _expenseListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget._incomeStore.getAll();
    widget._expenseStore.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  'Olá! Obrigado por Voltar',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
              ),
              HorizontallyInfinityContainer(
                color: const Color(0xFFFAFAFA),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Receitas',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ScopedBuilder<IncomeStore, List<IncomeParcelModel>>(
                      store: widget._incomeStore,
                      onLoading: (context) {
                        return SizedBox(
                          height: 325,
                          child: HorizontalListView(
                            itemCount: 4,
                            itemCallback: (i) => const ShimmerFinanceCard(),
                          ),
                        );
                      },
                      onState: (context, state) {
                        //Retornar uma imagem
                        if (state.isEmpty) return Container();

                        return SizedBox(
                          height: 325,
                          child: HorizontalAnimatedList(
                            animatedListKey: _incomeListKey,
                            length: state.length,
                            itemBuilderFunction: (context, index) {
                              return IncomeCard(model: state[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              HorizontallyInfinityContainer(
                color: const Color(0xFFFAFAFA),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Despesas',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ScopedBuilder<ExpenseStore, List<ExpenseParcelModel>>(
                      store: widget._expenseStore,
                      onLoading: (context) {
                        return SizedBox(
                          height: 325,
                          child: HorizontalListView(
                            itemCount: 4,
                            itemCallback: (i) => const ShimmerFinanceCard(),
                          ),
                        );
                      },
                      onState: (context, state) {
                        //Retornar uma imagem
                        if (state.isEmpty) return Container();

                        return SizedBox(
                          height: 325,
                          child: HorizontalAnimatedList(
                            animatedListKey: _expenseListKey,
                            length: state.length,
                            itemBuilderFunction: (context, index) {
                              return ExpenseCard(model: state[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
