import 'package:flutter/material.dart';
import '../controllers/gesty_controller.dart';
import '../theme/app_theme.dart';

class SubscriptionCounterCard extends StatelessWidget {
  final GestyController controller;

  const SubscriptionCounterCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final expiringCount = controller.expiringTrials.length;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryCyan.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'CONTADOR DE GASTOS RECOLECTADOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              if (expiringCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.crimsonAlert,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$expiringCount por vencer',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),

          // Número total animado o en fuente grande
          Text(
            controller.formatCurrency(controller.totalCollectedExpensesCounter),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Suma total de gastos del período + costo mensual de suscripciones',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 18),
          Divider(
            color: Colors.white.withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 14),

          // Desglose: Gastos Fijos/Relativos vs Suscripciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSubItem(
                label: 'Gastos en Cartera',
                amount: controller.formatCurrency(controller.totalSpent),
                icon: Icons.receipt_long_outlined,
              ),
              _buildSubItem(
                label: 'Suscripciones (Mes)',
                amount: controller
                    .formatCurrency(controller.totalSubscriptionsMonthlyCost),
                icon: Icons.subscriptions_outlined,
              ),
              _buildSubItem(
                label: 'Pruebas Gratis',
                amount: '${controller.expiringTrials.length} activas',
                icon: Icons.av_timer_outlined,
                isTextOnly: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubItem({
    required String label,
    required String amount,
    required IconData icon,
    bool isTextOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTextOnly ? 13 : 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
