import 'package:flutter/material.dart';
import '../models/subscription_model.dart';
import '../controllers/gesty_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/subscription_card.dart';

class SubscriptionsScreen extends StatelessWidget {
  final GestyController controller;

  const SubscriptionsScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final subscriptions = controller.subscriptions;
    final expiringTrials = controller.expiringTrials;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suscripciones & Pruebas'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BANNER RESUMEN COSTO MENSUAL
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.emeraldGradient,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.emeraldGreen.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL SUSCRIPCIONES (MES)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          controller.formatCurrency(
                              controller.totalSubscriptionsMonthlyCost),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${subscriptions.length} plataformas registradas',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.subscriptions_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SECCIÓN PRUEBAS GRATUITAS POR VENCER (SI HAY)
              if (expiringTrials.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppTheme.crimsonAlert,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pruebas Gratuitas Próximas a Vencer (${expiringTrials.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.crimsonAlert,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cancélalas a tiempo si no deseas que se conviertan en cobro recurrente.',
                  style: TextStyle(color: Colors.grey, fontSize: 12.5),
                ),
                const SizedBox(height: 12),
                ...expiringTrials.map(
                  (sub) => SubscriptionCard(
                    subscription: sub,
                    controller: controller,
                    onDelete: () => controller.deleteSubscription(sub.id),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // TODAS LAS SUSCRIPCIONES
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Todas las Suscripciones y Servicios',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (subscriptions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(28),
                    child: Text(
                      'No tienes suscripciones registradas en GESTY',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...subscriptions.map(
                  (sub) => SubscriptionCard(
                    subscription: sub,
                    controller: controller,
                    onDelete: () => controller.deleteSubscription(sub.id),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSubscriptionModal(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Suscripción / Prueba'),
      ),
    );
  }

  void _showAddSubscriptionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddSubscriptionSheet(controller: controller),
    );
  }
}

class _AddSubscriptionSheet extends StatefulWidget {
  final GestyController controller;

  const _AddSubscriptionSheet({required this.controller});

  @override
  State<_AddSubscriptionSheet> createState() => _AddSubscriptionSheetState();
}

class _AddSubscriptionSheetState extends State<_AddSubscriptionSheet> {
  final _nameController = TextEditingController();
  final _costController = TextEditingController();

  String _selectedPlatform = 'Netflix';
  BillingCycle _billingCycle = BillingCycle.monthly;
  bool _isFreeTrial = false;
  int _trialDays = 7;

  final List<String> _platforms = [
    'Netflix',
    'Spotify',
    'Prime Video',
    'ChatGPT',
    'Apple Music',
    'iCloud',
    'HBO Max',
    'Disney+',
    'YouTube Premium',
    'Otro Servicio',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Agregar Suscripción o Prueba',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // PLATAFORMA
              DropdownButtonFormField<String>(
                initialValue: _selectedPlatform,
                decoration: InputDecoration(
                  labelText: 'Plataforma / Servicio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: _platforms
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedPlatform = val;
                      if (_nameController.text.isEmpty ||
                          _platforms.contains(_nameController.text)) {
                        _nameController.text = val;
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 14),

              // NOMBRE O PLAN
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Plan',
                  hintText: 'Ej. Netflix 4K, Spotify Duo...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // COSTO Y CICLO DE COBRO
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextField(
                      controller: _costController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Costo',
                        prefixText: '${widget.controller.currencySymbol} ',
                        hintText: '9.99',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: DropdownButtonFormField<BillingCycle>(
                      initialValue: _billingCycle,
                      decoration: InputDecoration(
                        labelText: 'Ciclo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: BillingCycle.monthly,
                          child: Text('Mensual'),
                        ),
                        DropdownMenuItem(
                          value: BillingCycle.annual,
                          child: Text('Anual'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _billingCycle = val);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // SWITCH PRUEBA GRATUITA
              SwitchListTile.adaptive(
                title: const Text(
                  '¿Es una Prueba Gratuita (Free Trial)?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: const Text(
                  'Actívate una alerta para evitar cobros sorpresa antes de la fecha límite.',
                  style: TextStyle(fontSize: 12),
                ),
                value: _isFreeTrial,
                activeThumbColor: AppTheme.primaryCyan,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) => setState(() => _isFreeTrial = val),
              ),

              if (_isFreeTrial) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Días restantes de prueba:'),
                    DropdownButton<int>(
                      value: _trialDays,
                      items: [1, 2, 3, 5, 7, 14, 30]
                          .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text('$d días'),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _trialDays = val);
                        }
                      },
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveSubscription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryCyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Guardar en GESTY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveSubscription() {
    final name = _nameController.text.trim();
    final costText = _costController.text.trim();
    final cost = double.tryParse(costText);

    if (name.isEmpty || cost == null || cost < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un nombre y costo válidos'),
        ),
      );
      return;
    }

    final newSub = Subscription(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      platform: _selectedPlatform,
      cost: cost,
      billingCycle: _billingCycle,
      renewalDate: DateTime.now().add(const Duration(days: 30)),
      isFreeTrial: _isFreeTrial,
      freeTrialEndDate: _isFreeTrial
          ? DateTime.now().add(Duration(days: _trialDays))
          : null,
    );

    widget.controller.addSubscription(newSub);
    Navigator.of(context).pop();
  }
}
