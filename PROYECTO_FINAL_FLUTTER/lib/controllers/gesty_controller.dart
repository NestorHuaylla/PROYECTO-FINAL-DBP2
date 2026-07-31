import 'package:flutter/material.dart';
import '../models/budget_model.dart';
import '../models/expense_model.dart';
import '../models/subscription_model.dart';
import '../models/savings_goal_model.dart';

class GestyController extends ChangeNotifier {
  // Símbolo de moneda configurable
  String currencySymbol = '\$';

  // Configuración de presupuestos (Semanal, Mensual, Anual)
  BudgetSettings _budgetSettings = BudgetSettings(
    isWeeklyActive: true,
    isMonthlyActive: true,
    isAnnualActive: true,
    weeklyBudget: 280.0,
    monthlyBudget: 1250.0,
    annualBudget: 15000.0,
  );

  BudgetSettings get budgetSettings => _budgetSettings;

  // Lista interna de gastos
  final List<Expense> _expenses = [
    Expense(
      id: 'exp_1',
      title: 'Alquiler del Departamento',
      amount: 480.00,
      category: 'Alquiler / Hipoteca',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: ExpenseType.fixed,
      notes: 'Pago mensual al propietario',
    ),
    Expense(
      id: 'exp_2',
      title: 'Servicio de Luz y Agua',
      amount: 65.50,
      category: 'Servicios (Luz/Agua/Gas)',
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: ExpenseType.fixed,
      notes: 'Recibo del mes actual',
    ),
    Expense(
      id: 'exp_3',
      title: 'Internet Fibra Óptica 300Mbps',
      amount: 39.90,
      category: 'Internet & Móvil',
      date: DateTime.now().subtract(const Duration(days: 4)),
      type: ExpenseType.fixed,
      notes: 'Conexión para teletrabajo y streaming',
    ),
    Expense(
      id: 'exp_4',
      title: 'Compra de Supermercado',
      amount: 112.40,
      category: 'Alimentación & Supermercado',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: ExpenseType.relative,
      notes: 'Víveres para la semana',
    ),
    Expense(
      id: 'exp_5',
      title: 'Cena con Amigos',
      amount: 42.00,
      category: 'Restaurantes & Salidas',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: ExpenseType.relative,
      notes: 'Restaurante italiano',
    ),
    Expense(
      id: 'exp_6',
      title: 'Entradas de Cine & Popcorn',
      amount: 24.00,
      category: 'Entretenimiento & Ocio',
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: ExpenseType.relative,
      notes: 'Estreno de fin de semana',
    ),
    Expense(
      id: 'exp_7',
      title: 'Café de Especialidad',
      amount: 6.50,
      category: 'Restaurantes & Salidas',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: ExpenseType.relative,
      notes: 'Reunión de trabajo',
    ),
  ];

  // Lista interna de suscripciones y pruebas gratuitas
  final List<Subscription> _subscriptions = [
    Subscription(
      id: 'sub_1',
      name: 'Netflix Premium 4K',
      platform: 'Netflix',
      cost: 15.99,
      billingCycle: BillingCycle.monthly,
      renewalDate: DateTime.now().add(const Duration(days: 14)),
      isFreeTrial: false,
    ),
    Subscription(
      id: 'sub_2',
      name: 'Spotify Familiar',
      platform: 'Spotify',
      cost: 10.99,
      billingCycle: BillingCycle.monthly,
      renewalDate: DateTime.now().add(const Duration(days: 8)),
      isFreeTrial: false,
    ),
    Subscription(
      id: 'sub_3',
      name: 'ChatGPT Plus (AI)',
      platform: 'ChatGPT',
      cost: 20.00,
      billingCycle: BillingCycle.monthly,
      renewalDate: DateTime.now().add(const Duration(days: 19)),
      isFreeTrial: false,
    ),
    Subscription(
      id: 'sub_4',
      name: 'Amazon Prime Video (Prueba)',
      platform: 'Prime Video',
      cost: 8.99,
      billingCycle: BillingCycle.monthly,
      renewalDate: DateTime.now().add(const Duration(days: 3)),
      isFreeTrial: true,
      freeTrialEndDate: DateTime.now().add(const Duration(days: 3)),
    ),
    Subscription(
      id: 'sub_5',
      name: 'Apple Music Audio Espacial',
      platform: 'Apple Music',
      cost: 10.99,
      billingCycle: BillingCycle.monthly,
      renewalDate: DateTime.now().add(const Duration(days: 2)),
      isFreeTrial: true,
      freeTrialEndDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Subscription(
      id: 'sub_6',
      name: 'iCloud+ 200 GB Storage',
      platform: 'iCloud',
      cost: 2.99,
      billingCycle: BillingCycle.monthly,
      renewalDate: DateTime.now().add(const Duration(days: 25)),
      isFreeTrial: false,
    ),
  ];

  // Lista de metas de ahorro motivacionales
  final List<SavingsGoal> _savingsGoals = [
    SavingsGoal(
      id: 'goal_1',
      title: 'Fondo de Emergencia (3 meses)',
      targetAmount: 3000.0,
      currentAmount: 1850.0,
      targetDate: DateTime.now().add(const Duration(days: 120)),
      colorHex: 0xFF10B981,
      icon: Icons.shield_outlined,
    ),
    SavingsGoal(
      id: 'goal_2',
      title: 'Viaje de Vacaciones a Cusco',
      targetAmount: 1200.0,
      currentAmount: 520.0,
      targetDate: DateTime.now().add(const Duration(days: 75)),
      colorHex: 0xFF06B6D4,
      icon: Icons.flight_takeoff_outlined,
    ),
    SavingsGoal(
      id: 'goal_3',
      title: 'Nueva Laptop para Desarrollo',
      targetAmount: 1500.0,
      currentAmount: 900.0,
      targetDate: DateTime.now().add(const Duration(days: 90)),
      colorHex: 0xFF8B5CF6,
      icon: Icons.laptop_mac_outlined,
    ),
  ];

  // --- GETTERS PRINCIPALES ---
  List<Expense> get expenses {
    final sorted = List<Expense>.from(_expenses);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  List<Expense> get fixedExpenses =>
      expenses.where((e) => e.type == ExpenseType.fixed).toList();

  List<Expense> get relativeExpenses =>
      expenses.where((e) => e.type == ExpenseType.relative).toList();

  List<Subscription> get subscriptions =>
      List.unmodifiable(_subscriptions);

  List<SavingsGoal> get savingsGoals =>
      List.unmodifiable(_savingsGoals);

  /// Lista de pruebas gratuitas próximas a vencer
  List<Subscription> get expiringTrials =>
      _subscriptions.where((s) => s.isTrialExpiringSoon).toList();

  // --- CÁLCULOS Y CONTADORES ---

  double get totalFixedSpent =>
      fixedExpenses.fold(0.0, (sum, e) => sum + e.amount);

  double get totalRelativeSpent =>
      relativeExpenses.fold(0.0, (sum, e) => sum + e.amount);

  double get totalSpent =>
      expenses.fold(0.0, (sum, e) => sum + e.amount);

  double get totalSubscriptionsMonthlyCost =>
      _subscriptions.fold(0.0, (sum, s) => sum + s.monthlyEquivalentCost);

  /// CONTADOR GLOBAL DE GASTOS RECOLECTADOS (Suma gastos del período + costo de suscripciones)
  double get totalCollectedExpensesCounter =>
      totalSpent + totalSubscriptionsMonthlyCost;

  /// Porcentaje de gasto semanal
  double get weeklySpent {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return expenses
        .where((e) => e.date.isAfter(weekStart.subtract(const Duration(seconds: 1))))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Puntaje de Salud Financiera GESTY Score (0 - 100)
  int get gestyScore {
    double score = 88.0;

    // Verificar cumplimiento de presupuesto mensual
    if (_budgetSettings.isMonthlyActive) {
      final monthlyRatio = totalCollectedExpensesCounter / _budgetSettings.monthlyBudget;
      if (monthlyRatio <= 0.70) {
        score += 10.0;
      } else if (monthlyRatio <= 0.95) {
        score += 5.0;
      } else if (monthlyRatio > 1.0) {
        score -= (monthlyRatio - 1.0) * 40.0;
      }
    }

    // Verificar proporción entre Gastos Fijos y Relativos
    final total = totalSpent;
    if (total > 0) {
      final fixedRatio = totalFixedSpent / total;
      // Proporción ideal entre 45% y 65% de gastos fijos
      if (fixedRatio >= 0.45 && fixedRatio <= 0.70) {
        score += 4.0;
      } else if (fixedRatio < 0.35) {
        // Demasiados gastos relativos/variables
        score -= 6.0;
      }
    }

    return score.clamp(10, 100).toInt();
  }

  String get healthStatusText {
    final score = gestyScore;
    if (score >= 85) return 'Excelente Salud Financiera';
    if (score >= 70) return 'Salud Financiera Estable';
    if (score >= 55) return 'Atención Recomendada';
    return 'Alerta de Sobregasto';
  }

  String get healthRecommendation {
    final score = gestyScore;
    if (score >= 85) {
      return 'Tus gastos fijos están bajo control y tus presupuestos se cumplen sin problemas. Sigue aportando a tus metas de ahorro.';
    }
    if (score >= 70) {
      return 'Tienes buen control general. Revisa las pruebas gratuitas que están por caducar para evitar cobros sorpresa.';
    }
    if (score >= 55) {
      return 'Tus gastos relativos están aumentando. Intenta recortar salidas u ocio para mantenerte dentro del presupuesto mensual.';
    }
    return 'Has superado el presupuesto asignado. Te sugerimos priorizar únicamente los Gastos Fijos por el resto del mes.';
  }

  // --- MÉTODOS DE MANIPULACIÓN DE ESTADO ---

  void toggleWeeklyBudget(bool active) {
    _budgetSettings = _budgetSettings.copyWith(isWeeklyActive: active);
    notifyListeners();
  }

  void toggleMonthlyBudget(bool active) {
    _budgetSettings = _budgetSettings.copyWith(isMonthlyActive: active);
    notifyListeners();
  }

  void toggleAnnualBudget(bool active) {
    _budgetSettings = _budgetSettings.copyWith(isAnnualActive: active);
    notifyListeners();
  }

  void updateBudgets({
    double? weekly,
    double? monthly,
    double? annual,
  }) {
    _budgetSettings = _budgetSettings.copyWith(
      weeklyBudget: weekly,
      monthlyBudget: monthly,
      annualBudget: annual,
    );
    notifyListeners();
  }

  void addExpense(Expense expense) {
    _expenses.insert(0, expense);
    notifyListeners();
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void addSubscription(Subscription subscription) {
    _subscriptions.add(subscription);
    notifyListeners();
  }

  void deleteSubscription(String id) {
    _subscriptions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void addSavingsGoal(SavingsGoal goal) {
    _savingsGoals.add(goal);
    notifyListeners();
  }

  void contributeToSavingsGoal(String id, double amount) {
    final index = _savingsGoals.indexWhere((g) => g.id == id);
    if (index != -1) {
      final goal = _savingsGoals[index];
      final updated = goal.copyWith(
        currentAmount: goal.currentAmount + amount,
      );
      _savingsGoals[index] = updated;
      notifyListeners();
    }
  }

  /// Formatea valores en formato moneda legible con símbolo configurable
  String formatCurrency(double value) {
    final isNegative = value < 0;
    final absVal = value.abs();
    final parts = absVal.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    int count = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      buffer.write(integerPart[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(',');
      }
    }

    final formattedInteger =
        buffer.toString().split('').reversed.join('');
    final sign = isNegative ? '-' : '';
    return '$sign$currencySymbol$formattedInteger.$decimalPart';
  }
}
