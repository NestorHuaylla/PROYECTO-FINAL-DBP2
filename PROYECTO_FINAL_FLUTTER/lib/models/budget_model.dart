class BudgetSettings {
  bool isWeeklyActive;
  bool isMonthlyActive;
  bool isAnnualActive;

  double weeklyBudget;
  double monthlyBudget;
  double annualBudget;

  BudgetSettings({
    this.isWeeklyActive = true,
    this.isMonthlyActive = true,
    this.isAnnualActive = false,
    this.weeklyBudget = 250.0,
    this.monthlyBudget = 1200.0,
    this.annualBudget = 14000.0,
  });

  /// Crea una copia con campos actualizados
  BudgetSettings copyWith({
    bool? isWeeklyActive,
    bool? isMonthlyActive,
    bool? isAnnualActive,
    double? weeklyBudget,
    double? monthlyBudget,
    double? annualBudget,
  }) {
    return BudgetSettings(
      isWeeklyActive: isWeeklyActive ?? this.isWeeklyActive,
      isMonthlyActive: isMonthlyActive ?? this.isMonthlyActive,
      isAnnualActive: isAnnualActive ?? this.isAnnualActive,
      weeklyBudget: weeklyBudget ?? this.weeklyBudget,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      annualBudget: annualBudget ?? this.annualBudget,
    );
  }

  /// Calcula el porcentaje consumido del presupuesto (de 0.0 a 1.0+)
  double getProgress(double spent, double total) {
    if (total <= 0) return 0.0;
    return (spent / total).clamp(0.0, 1.5);
  }

  /// Indica si al menos un presupuesto está activo
  bool get hasAnyActive => isWeeklyActive || isMonthlyActive || isAnnualActive;
}
