import 'package:flutter/material.dart';
import '../controllers/gesty_controller.dart';
import '../theme/app_theme.dart';

class BudgetsScreen extends StatelessWidget {
  final GestyController controller;

  const BudgetsScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final settings = controller.budgetSettings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuestos GESTY'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BANNER EXPLICATIVO
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryCyan.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.track_changes_outlined,
                        color: AppTheme.primaryCyan,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Control Flexible de Presupuestos',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Activa y ajusta independientemente tus límites para el control semanal, mensual y anual. GESTY sumará tus gastos recolectados automáticamente.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // PRESUPUESTO SEMANAL
              _buildBudgetConfigCard(
                context: context,
                title: 'Presupuesto Semanal',
                subtitle: 'Control para gastos del día a día y supermercado',
                isActive: settings.isWeeklyActive,
                currentAmount: settings.weeklyBudget,
                spentAmount: controller.weeklySpent,
                icon: Icons.date_range_outlined,
                onToggle: (val) => controller.toggleWeeklyBudget(val),
                onEdit: () => _showEditBudgetDialog(
                  context: context,
                  title: 'Presupuesto Semanal',
                  currentValue: settings.weeklyBudget,
                  onSave: (val) => controller.updateBudgets(weekly: val),
                ),
              ),
              const SizedBox(height: 16),

              // PRESUPUESTO MENSUAL
              _buildBudgetConfigCard(
                context: context,
                title: 'Presupuesto Mensual',
                subtitle: 'Límite principal que incluye suscripciones y fijos',
                isActive: settings.isMonthlyActive,
                currentAmount: settings.monthlyBudget,
                spentAmount: controller.totalCollectedExpensesCounter,
                icon: Icons.calendar_month_outlined,
                isHighlighted: true,
                onToggle: (val) => controller.toggleMonthlyBudget(val),
                onEdit: () => _showEditBudgetDialog(
                  context: context,
                  title: 'Presupuesto Mensual',
                  currentValue: settings.monthlyBudget,
                  onSave: (val) => controller.updateBudgets(monthly: val),
                ),
              ),
              const SizedBox(height: 16),

              // PRESUPUESTO ANUAL
              _buildBudgetConfigCard(
                context: context,
                title: 'Presupuesto Anual',
                subtitle: 'Meta de gasto proyectada para todo el año',
                isActive: settings.isAnnualActive,
                currentAmount: settings.annualBudget,
                spentAmount: controller.totalCollectedExpensesCounter * 12,
                icon: Icons.event_note_outlined,
                onToggle: (val) => controller.toggleAnnualBudget(val),
                onEdit: () => _showEditBudgetDialog(
                  context: context,
                  title: 'Presupuesto Anual',
                  currentValue: settings.annualBudget,
                  onSave: (val) => controller.updateBudgets(annual: val),
                ),
              ),
              const SizedBox(height: 24),

              // TIPS DE PRESUPUESTO
              _buildReliabilityTipCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetConfigCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isActive,
    required double currentAmount,
    required double spentAmount,
    required IconData icon,
    required ValueChanged<bool> onToggle,
    required VoidCallback onEdit,
    bool isHighlighted = false,
  }) {
    final progress =
        (currentAmount > 0) ? (spentAmount / currentAmount).clamp(0.0, 1.0) : 0.0;
    final pct =
        (currentAmount > 0) ? (spentAmount / currentAmount * 100).toInt() : 0;

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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? AppTheme.primaryCyan.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color:
                          isHighlighted ? AppTheme.primaryCyan : Colors.white70,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch.adaptive(
                value: isActive,
                onChanged: onToggle,
                activeThumbColor: AppTheme.primaryCyan,
              ),
            ],
          ),
          if (isActive) ...[
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Límite asignado:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      controller.formatCurrency(currentAmount),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryCyan,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 14),
                  label: const Text('Modificar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryCyan.withValues(alpha: 0.15),
                    foregroundColor: AppTheme.primaryCyan,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gastado: ${controller.formatCurrency(spentAmount)}',
                  style: const TextStyle(fontSize: 12.5),
                ),
                Text(
                  '$pct% consumido',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: pct >= 90
                        ? AppTheme.crimsonAlert
                        : (pct >= 75
                            ? AppTheme.amberWarning
                            : AppTheme.emeraldGreen),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  pct >= 90
                      ? AppTheme.crimsonAlert
                      : (pct >= 75
                          ? AppTheme.amberWarning
                          : AppTheme.emeraldGreen),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReliabilityTipCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.emeraldGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.emeraldGreen.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppTheme.emeraldGreen,
            size: 26,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fiabilidad y Precisión GESTY',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.emeraldGreen,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Al activar presupuestos independientes, GESTY recalcula en tiempo real tu GESTY Score y emite alertas si un gasto variable pone en riesgo tus gastos fijos del mes.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditBudgetDialog({
    required BuildContext context,
    required String title,
    required double currentValue,
    required ValueChanged<double> onSave,
  }) {
    final textController =
        TextEditingController(text: currentValue.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Modificar $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ingresa el nuevo monto límite para este período:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: textController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: '${controller.currencySymbol} ',
                hintText: '1000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryCyan,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              final val = double.tryParse(textController.text);
              if (val != null && val >= 0) {
                onSave(val);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
