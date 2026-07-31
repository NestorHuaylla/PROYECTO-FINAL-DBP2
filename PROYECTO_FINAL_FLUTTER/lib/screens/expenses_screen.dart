import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../controllers/gesty_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/expense_card.dart';
import '../widgets/expense_type_info_modal.dart';

class ExpensesScreen extends StatefulWidget {
  final GestyController controller;

  const ExpensesScreen({
    super.key,
    required this.controller,
  });

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  int _selectedFilter = 0; // 0: Todos, 1: Fijos, 2: Relativos

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    List<Expense> filteredList;
    String filterLabel;
    double filterTotal;

    if (_selectedFilter == 1) {
      filteredList = controller.fixedExpenses;
      filterLabel = 'Gastos Fijos (Esenciales)';
      filterTotal = controller.totalFixedSpent;
    } else if (_selectedFilter == 2) {
      filteredList = controller.relativeExpenses;
      filterLabel = 'Gastos Relativos (Estilo de vida)';
      filterTotal = controller.totalRelativeSpent;
    } else {
      filteredList = controller.expenses;
      filterLabel = 'Total de Gastos Registrados';
      filterTotal = controller.totalSpent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos GESTY'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Guía de Fijos vs Relativos',
            onPressed: () => ExpenseTypeInfoModal.show(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // PESTAÑAS DE FILTRADO (Todos / Fijos / Relativos)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    _buildFilterTab(0, 'Todos', Icons.list_alt),
                    _buildFilterTab(
                        1, 'Fijos', Icons.lock_clock_outlined, AppTheme.electricBlue),
                    _buildFilterTab(
                        2, 'Relativos', Icons.swap_calls_outlined, AppTheme.amberWarning),
                  ],
                ),
              ),
            ),

            // BANNER CON TOTAL RESUMIDO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filterLabel,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.formatCurrency(filterTotal),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryCyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${filteredList.length} ítems',
                        style: const TextStyle(
                          color: AppTheme.primaryCyan,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // LISTADO DE GASTOS
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No hay gastos en esta categoría',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final exp = filteredList[index];
                        return ExpenseCard(
                          expense: exp,
                          controller: controller,
                          onDelete: () => controller.deleteExpense(exp.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseModal(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Gasto'),
      ),
    );
  }

  Widget _buildFilterTab(
    int index,
    String label,
    IconData icon, [
    Color? activeColor,
  ]) {
    final isSelected = _selectedFilter == index;
    final color = activeColor ?? AppTheme.primaryCyan;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: color.withValues(alpha: 0.5), width: 1)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? color : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddExpenseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddExpenseSheet(controller: widget.controller),
    );
  }
}

class _AddExpenseSheet extends StatefulWidget {
  final GestyController controller;

  const _AddExpenseSheet({required this.controller});

  @override
  State<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<_AddExpenseSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  ExpenseType _selectedType = ExpenseType.fixed;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = Expense.fixedCategories.first;
  }

  void _onTypeChanged(ExpenseType type) {
    setState(() {
      _selectedType = type;
      _selectedCategory = (type == ExpenseType.fixed)
          ? Expense.fixedCategories.first
          : Expense.relativeCategories.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = (_selectedType == ExpenseType.fixed)
        ? Expense.fixedCategories
        : Expense.relativeCategories;

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
                'Registrar Gasto en GESTY',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Clasifica correctamente entre Gasto Fijo y Relativo para optimizar tu GESTY Score.',
                style: TextStyle(color: Colors.grey, fontSize: 12.5),
              ),
              const SizedBox(height: 18),

              // SELECTOR TIPO DE GASTO
              const Text(
                'Tipo de Gasto (Fiabilidad Financiera):',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeOption(
                      ExpenseType.fixed,
                      'Gasto Fijo',
                      Icons.lock_clock_outlined,
                      AppTheme.electricBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeOption(
                      ExpenseType.relative,
                      'Gasto Relativo',
                      Icons.swap_calls_outlined,
                      AppTheme.amberWarning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // TÍTULO
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título o Concepto',
                  hintText: 'Ej. Alquiler, Supermercado, Cine...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // MONTO Y CATEGORÍA
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Monto',
                        prefixText: '${widget.controller.currencySymbol} ',
                        hintText: '0.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 6,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      isExpanded: true,
                      items: categories
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(
                                  c,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategory = val);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // NOTAS
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notas adicionales (Opcional)',
                  hintText: 'Añade un comentario o referencia...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // BOTÓN GUARDAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedType.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Registrar Gasto',
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

  Widget _buildTypeOption(
    ExpenseType type,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => _onTypeChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExpense() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText);

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un título y monto válidos'),
        ),
      );
      return;
    }

    final newExpense = Expense(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      amount: amount,
      category: _selectedCategory,
      date: DateTime.now(),
      type: _selectedType,
      notes: _notesController.text.trim(),
    );

    widget.controller.addExpense(newExpense);
    Navigator.of(context).pop();
  }
}
