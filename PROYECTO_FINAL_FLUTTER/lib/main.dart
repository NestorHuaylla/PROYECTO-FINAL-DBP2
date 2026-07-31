import 'package:flutter/material.dart';
import 'controllers/gesty_controller.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/budgets_screen.dart';
import 'screens/expenses_screen.dart';
import 'screens/subscriptions_screen.dart';
import 'screens/analytics_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GestyApp());
}

class GestyApp extends StatefulWidget {
  const GestyApp({super.key});

  @override
  State<GestyApp> createState() => _GestyAppState();
}

class _GestyAppState extends State<GestyApp> {
  final GestyController _controller = GestyController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'GESTY - Gestión Inteligente de Gastos',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark, // Modo oscuro financiero premium por defecto
          home: GestyMainNavigation(controller: _controller),
        );
      },
    );
  }
}

class GestyMainNavigation extends StatefulWidget {
  final GestyController controller;

  const GestyMainNavigation({
    super.key,
    required this.controller,
  });

  @override
  State<GestyMainNavigation> createState() => _GestyMainNavigationState();
}

class _GestyMainNavigationState extends State<GestyMainNavigation> {
  int _currentIndex = 0;

  void _onNavigate(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        controller: widget.controller,
        onNavigate: _onNavigate,
      ),
      BudgetsScreen(
        controller: widget.controller,
      ),
      ExpensesScreen(
        controller: widget.controller,
      ),
      SubscriptionsScreen(
        controller: widget.controller,
      ),
      AnalyticsScreen(
        controller: widget.controller,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavigate,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Presupuestos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Gastos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions_outlined),
              activeIcon: Icon(Icons.subscriptions),
              label: 'Suscripciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'Análisis',
            ),
          ],
        ),
      ),
    );
  }
}
