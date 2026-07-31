import 'package:flutter/material.dart';
import '../models/subscription_model.dart';
import '../controllers/gesty_controller.dart';
import '../theme/app_theme.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final GestyController controller;
  final VoidCallback? onDelete;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.controller,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final brandColor = Subscription.getPlatformColor(subscription.platform);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration(context),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono con color de marca
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: brandColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: brandColor.withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    Subscription.getPlatformIcon(subscription.platform),
                    color: brandColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),

                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.refresh_outlined,
                            size: 13,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            subscription.billingCycle == BillingCycle.monthly
                                ? 'Cobro mensual'
                                : 'Cobro anual',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•  Renueva: ${_formatDate(subscription.renewalDate)}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      if (subscription.isFreeTrial &&
                          subscription.freeTrialEndDate != null) ...[
                        const SizedBox(height: 8),
                        _buildTrialBadge(subscription.daysUntilTrialEnds),
                      ],
                    ],
                  ),
                ),

                // Costo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      controller.formatCurrency(subscription.cost),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subscription.billingCycle == BillingCycle.monthly
                          ? '/mes'
                          : '/año',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onDelete != null)
            Positioned(
              top: 6,
              right: 6,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.grey.withValues(alpha: 0.6),
                ),
                onPressed: onDelete,
                tooltip: 'Eliminar suscripción',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrialBadge(int days) {
    Color badgeColor = AppTheme.primaryCyan;
    String text = 'Prueba gratis: $days días restantes';

    if (days <= 2) {
      badgeColor = AppTheme.crimsonAlert;
      text = days == 0 ? '¡VENCE HOY! Cancela si no usarás' : '¡Vence en $days días!';
    } else if (days <= 5) {
      badgeColor = AppTheme.amberWarning;
      text = 'Vence pronto: $days días';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.5),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 13,
            color: badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}
