import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/credit_card_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/expense_parcel_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/income_parcel_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/credit_card_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/expense_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/income_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/credit_card_widget.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/expense_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/lists/horizontal_listview.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/horizontal_infinity_container.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/income_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/shimmer/shimmer_container.dart';

import '../../domain/entities/date.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/lists/horizontal_animated_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final IncomeStore _incomeStore = IncomeStore();
  final ExpenseStore _expenseStore = ExpenseStore();
  final CreditCardStore _creditCardStore = CreditCardStore();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GlobalKey<AnimatedListState> _incomeListKey = GlobalKey();
  late final GlobalKey<AnimatedListState> _expenseListKey = GlobalKey();
  late final GlobalKey<AnimatedListState> _creditCardListKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget._incomeStore.getAll();
    widget._expenseStore.getAll();
    widget._creditCardStore.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: Drawer(
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: const Text(
                  'Home',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
                ),
                initialMonthAndYear: Date.today(),
                onMonthChange: (_, __) {},
              ),
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
                            itemCallback: (i) => const ShimmerContainer(
                              height: 300,
                              width: 250,
                            ),
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
                            itemCallback: (i) => const ShimmerContainer(
                              height: 300,
                              width: 250,
                            ),
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
                        'Cartões de Crédito',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ScopedBuilder<CreditCardStore, List<CreditCardModel>>(
                      store: widget._creditCardStore,
                      onLoading: (context) {
                        return SizedBox(
                          height: 240,
                          child: HorizontalListView(
                            itemCount: 4,
                            itemCallback: (i) => const ShimmerContainer(
                              height: 150,
                              width: 275,
                              borderRadius: 10.0,
                            ),
                          ),
                        );
                      },
                      onState: (context, state) {
                        if (state.isEmpty) return Container();

                        return SizedBox(
                          height: 240,
                          child: HorizontalAnimatedList(
                            itemBuilderFunction: (context, index) =>
                                CreditCardWidget(creditCard: state[index]),
                            length: state.length,
                            animatedListKey: _creditCardListKey,
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
