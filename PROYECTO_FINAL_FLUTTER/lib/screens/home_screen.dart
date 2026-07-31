import 'package:flutter/material.dart';
import '../controllers/gesty_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/subscription_counter_card.dart';
import '../widgets/budget_overview_card.dart';
import '../widgets/expense_card.dart';
import '../widgets/expense_type_info_modal.dart';

class HomeScreen extends StatelessWidget {
  final GestyController controller;
  final Function(int) onNavigate;

  const HomeScreen({
    super.key,
    required this.controller,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final expiringTrials = controller.expiringTrials;
    final recentExpenses = controller.expenses.take(4).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER CON SALUDO Y GESTY SCORE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryCyan.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_balance_outlined,
                          color: AppTheme.primaryCyan,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '¡Hola, Gestor!',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                'GESTY Finanzas',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.emeraldGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // GESTY SCORE BADGE
                  GestureDetector(
                    onTap: () => onNavigate(4), // Ir a Análisis & Metas
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.emeraldGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.emeraldGreen.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                            color: AppTheme.emeraldGreen,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Score ${controller.gestyScore}',
                            style: const TextStyle(
                              color: AppTheme.emeraldGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ALERTA DE PRUEBAS GRATUITAS POR VENCER (Si hay alguna)
              if (expiringTrials.isNotEmpty) ...[
                _buildTrialAlertBanner(context, expiringTrials.length),
                const SizedBox(height: 18),
              ],

              // TARJETA DE CONTADOR GLOBAL DE GASTOS RECOLECTADOS
              SubscriptionCounterCard(controller: controller),
              const SizedBox(height: 24),

              // RESUMEN GASTOS FIJOS VS RELATIVOS
              _buildFixedVsRelativeCard(context),
              const SizedBox(height: 24),

              // SECCIÓN: PRESUPUESTOS CONFIGURADOS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Presupuestos Activos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigate(1), // Ir a Presupuestos
                    child: const Text('Configurar'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              BudgetOverviewCard(controller: controller),
              const SizedBox(height: 24),

              // TRANSACCIONES RECIENTES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transacciones Recientes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigate(2), // Ir a Gastos
                    child: const Text('Ver Todos'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (recentExpenses.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No hay transacciones registradas',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...recentExpenses.map(
                  (expense) => ExpenseCard(
                    expense: expense,
                    controller: controller,
                    onDelete: () => controller.deleteExpense(expense.id),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrialAlertBanner(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.crimsonAlert.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.crimsonAlert.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppTheme.crimsonAlert,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡Alerta de Pruebas Gratuitas!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.crimsonAlert,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Tienes $count prueba${count > 1 ? 's' : ''} gratuita${count > 1 ? 's' : ''} a punto de vencer. Revísala para evitar cobros sorpresa.',
                  style: const TextStyle(fontSize: 12.5),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => onNavigate(3), // Ir a Suscripciones
            child: const Text(
              'Revisar',
              style: TextStyle(
                color: AppTheme.crimsonAlert,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedVsRelativeCard(BuildContext context) {
    final totalFixed = controller.totalFixedSpent;
    final totalRelative = controller.totalRelativeSpent;
    final total = totalFixed + totalRelative;

    final fixedRatio = (total > 0) ? (totalFixed / total).clamp(0.0, 1.0) : 0.5;
    final relativeRatio = 1.0 - fixedRatio;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.balance_outlined,
                    color: AppTheme.primaryCyan,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Gastos Fijos vs. Gastos Relativos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => ExpenseTypeInfoModal.show(context),
                icon: const Icon(
                  Icons.help_outline_rounded,
                  color: AppTheme.primaryCyan,
                  size: 20,
                ),
                tooltip: '¿Qué significa esta clasificación?',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(
                    flex: (fixedRatio * 100).toInt().clamp(5, 95),
                    child: Container(color: AppTheme.electricBlue),
                  ),
                  Expanded(
                    flex: (relativeRatio * 100).toInt().clamp(5, 95),
                    child: Container(color: AppTheme.amberWarning),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.electricBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Fijos (${(fixedRatio * 100).toInt()}%): ${controller.formatCurrency(totalFixed)}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.amberWarning,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Relativos (${(relativeRatio * 100).toInt()}%): ${controller.formatCurrency(totalRelative)}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
