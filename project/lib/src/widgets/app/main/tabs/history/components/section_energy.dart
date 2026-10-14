import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/calendar.dart';
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/history_periods.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import './energy_bar_chart.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class SectionEnergy extends StatefulWidget {
  const SectionEnergy({
    super.key
  });

  @override
  State<SectionEnergy> createState() => _SectionEnergyState();
}

class _SectionEnergyState extends State<SectionEnergy> {
  late StateBloc stateBloc;
  late HistoryBloc historyBloc;

  late ScreenPropertiesModel screenProperties;

  late List<int> values;

  @override
  Widget build(BuildContext context) {
    _init();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _createHeader(),
        const SizedBox(height: Sizes.margin16),

        _createBarChart(),
      ]
    );
  }

  // Method that initializes the variables.
  void _init() {
    stateBloc = BlocProvider.stateBloc(context);
    historyBloc = BlocProvider.historyBloc(context);

    screenProperties = ScreenPropertiesModel(context: context);

    values = _getValues();
  }

  // Method that creates the header.
  Widget _createHeader() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: Sizes.margin4,
    children: [
      TextInter(
        text: _getTotal(values),
        fontSize: screenProperties.fontExtraTitle * 1.4,
        fontWeight: FontWeight.w800,
        textAlign: TextAlign.center
      ),

      TextInter(
        text: AppLocalizations.of(context)!.translate('energy_provided'),
        fontSize: screenProperties.fontSmallest,
        color: CustomColors.textSecondary,
        textAlign: TextAlign.center
      ),
    ],
  );

  // Method that creates the chart bar.
  Widget _createBarChart() => EnergyBarChart(
    values: values,
    labels: List<String>.generate(values.length, (int index) => _getLabel(index)),
    isScrollable: historyBloc.historyPeriod == HistoryPeriods.month
  );

  // Method that returns the values of the chart: the energy list, or a list of zeros with the length of the period (skeleton).
  List<int> _getValues() {
    if (historyBloc.energyList.isNotEmpty) {
      return historyBloc.energyList;
    }

    switch (historyBloc.historyPeriod) {
      case HistoryPeriods.month: {
        final DateTime now = DateTime.now();
        return List<int>.filled(DateUtils.getDaysInMonth(now.year, now.month), Numbers.zero);
      }
      case HistoryPeriods.year: return List<int>.filled(DateTime.monthsPerYear, Numbers.zero);
      default: return List<int>.filled(DateTime.daysPerWeek, Numbers.zero);
    }
  }

  // Method that returns the total energy of the period in kWh.
  String _getTotal(List<int> values) {
    final int total = values.fold(Numbers.zero, (int sum, int value) => sum + value);

    return Utils.formatEnergyKwh(energyWh: total, languageCode: stateBloc.session.languageCode);
  }

  // Method that returns the label of a value.
  String _getLabel(int index) {
    switch (historyBloc.historyPeriod) {
      case HistoryPeriods.week: return index >= Calendar.shortWeekdays.length
        ? Strings.emptyString
        : AppLocalizations.of(context)!.translate(Calendar.shortWeekdays[index]);
      case HistoryPeriods.month: return '${ index + 1 }';
      case HistoryPeriods.year: {
        if (index >= Calendar.months.length) {
          return Strings.emptyString;
        }

        final String month = AppLocalizations.of(context)!.translate(Calendar.months[index]);

        return month.isEmpty ? Strings.emptyString : month.substring(0, 1).toUpperCase();
      }
      default: return Strings.emptyString;
    }
  }
}
