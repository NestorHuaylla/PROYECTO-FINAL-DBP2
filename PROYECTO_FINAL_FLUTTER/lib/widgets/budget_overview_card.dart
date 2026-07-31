import 'package:flutter/material.dart';
import '../controllers/gesty_controller.dart';
import '../theme/app_theme.dart';

class BudgetOverviewCard extends StatelessWidget {
  final GestyController controller;

  const BudgetOverviewCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final settings = controller.budgetSettings;

    if (!settings.hasAnyActive) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration(context),
        child: Column(
          children: [
            const Icon(
              Icons.account_balance_wallet_outlined,
              size: 44,
              color: AppTheme.amberWarning,
            ),
            const SizedBox(height: 12),
            const Text(
              'No hay presupuestos activos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Activa y configura tus presupuestos semanal, mensual o anual en la pestaña Presupuestos para un seguimiento constante.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.pie_chart_outline,
                      color: AppTheme.primaryCyan,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Estado de Presupuestos',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.emeraldGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Activo',
                  style: TextStyle(
                    color: AppTheme.emeraldGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Presupuesto Semanal
          if (settings.isWeeklyActive)
            _buildBudgetBar(
              context: context,
              label: 'Semanal',
              spent: controller.weeklySpent,
              total: settings.weeklyBudget,
              icon: Icons.date_range,
            ),

          // Presupuesto Mensual
          if (settings.isMonthlyActive) ...[
            if (settings.isWeeklyActive) const SizedBox(height: 16),
            _buildBudgetBar(
              context: context,
              label: 'Mensual (Total Recolectado)',
              spent: controller.totalCollectedExpensesCounter,
              total: settings.monthlyBudget,
              icon: Icons.calendar_month,
              isHighlighted: true,
            ),
          ],

          // Presupuesto Anual
          if (settings.isAnnualActive) ...[
            if (settings.isWeeklyActive || settings.isMonthlyActive)
              const SizedBox(height: 16),
            _buildBudgetBar(
              context: context,
              label: 'Anual Proyectado',
              spent: controller.totalCollectedExpensesCounter * 12,
              total: settings.annualBudget,
              icon: Icons.event_note,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBudgetBar({
    required BuildContext context,
    required String label,
    required double spent,
    required double total,
    required IconData icon,
    bool isHighlighted = false,
  }) {
    final progress = (total > 0) ? (spent / total).clamp(0.0, 1.0) : 0.0;
    final percentage = (total > 0) ? (spent / total * 100).toInt() : 0;

    Color progressColor = AppTheme.emeraldGreen;
    if (progress >= 0.9) {
      progressColor = AppTheme.crimsonAlert;
    } else if (progress >= 0.75) {
      progressColor = AppTheme.amberWarning;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: isHighlighted ? AppTheme.primaryCyan : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isHighlighted ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${controller.formatCurrency(spent)} ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
                Text(
                  '/ ${controller.formatCurrency(total)} ($percentage%)',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }
}
