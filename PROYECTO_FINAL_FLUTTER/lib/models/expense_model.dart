import 'package:flutter/material.dart';

/// Define si un gasto es Fijo (predecible/comprometido) o Relativo/Variable (ocasional/flexible)
enum ExpenseType {
  /// Gastos Fijos: Aquellos con montos predecibles y periodicidad constante
  /// (Alquiler, Servicios, Internet, Hipoteca, Educación, Seguros).
  fixed,

  /// Gastos Relativos/Variables: Aquellos que fluctúan de acuerdo al estilo de vida
  /// o circunstancias (Alimentación, Entretenimiento, Salidas, Ropa, Gustos).
  relative,
}

extension ExpenseTypeExtension on ExpenseType {
  String get label {
    switch (this) {
      case ExpenseType.fixed:
        return 'Gasto Fijo';
      case ExpenseType.relative:
        return 'Gasto Relativo';
    }
  }

  String get shortLabel {
    switch (this) {
      case ExpenseType.fixed:
        return 'Fijo';
      case ExpenseType.relative:
        return 'Relativo';
    }
  }

  String get description {
    switch (this) {
      case ExpenseType.fixed:
        return 'Los Gastos Fijos son compromisos recurrentes y esenciales (alquiler, servicios, internet, educación). Son predecibles y deben cubrirse prioritariamente en cada ciclo financiero.';
      case ExpenseType.relative:
        return 'Los Gastos Relativos (o Variables) cambian según tus hábitos y decisiones diarias (comida fuera, ocio, ropa, caprichos). Controlar estos gastos es clave para aumentar el ahorro.';
    }
  }

  Color get color {
    switch (this) {
      case ExpenseType.fixed:
        return const Color(0xFF3B82F6); // Azul eléctrico
      case ExpenseType.relative:
        return const Color(0xFFF59E0B); // Ámbar moderno
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseType.fixed:
        return Icons.lock_clock_outlined;
      case ExpenseType.relative:
        return Icons.swap_calls_outlined;
    }
  }
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final ExpenseType type;
  final String notes;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.notes = '',
  });

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    ExpenseType? type,
    String? notes,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
      notes: notes ?? this.notes,
    );
  }

  /// Categorías sugeridas para Gastos Fijos
  static const List<String> fixedCategories = [
    'Alquiler / Hipoteca',
    'Servicios (Luz/Agua/Gas)',
    'Internet & Móvil',
    'Seguros',
    'Educación',
    'Transporte Fijo',
    'Otro Gasto Fijo',
  ];

  /// Categorías sugeridas para Gastos Relativos
  static const List<String> relativeCategories = [
    'Alimentación & Supermercado',
    'Restaurantes & Salidas',
    'Entretenimiento & Ocio',
    'Ropa & Moda',
    'Salud & Bienestar',
    'Regalos & Gustos',
    'Otro Gasto Relativo',
  ];

  static IconData getIconForCategory(String category) {
    switch (category) {
      case 'Alquiler / Hipoteca':
        return Icons.home_outlined;
      case 'Servicios (Luz/Agua/Gas)':
        return Icons.bolt_outlined;
      case 'Internet & Móvil':
        return Icons.wifi_outlined;
      case 'Seguros':
        return Icons.security_outlined;
      case 'Educación':
        return Icons.school_outlined;
      case 'Alimentación & Supermercado':
        return Icons.shopping_cart_outlined;
      case 'Restaurantes & Salidas':
        return Icons.restaurant_outlined;
      case 'Entretenimiento & Ocio':
        return Icons.movie_creation_outlined;
      case 'Ropa & Moda':
        return Icons.checkroom_outlined;
      case 'Salud & Bienestar':
        return Icons.favorite_border_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }
}
