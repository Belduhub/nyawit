import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/budget_provider.dart';
import '../../utils/constants.dart';
import '../../utils/budget_calculator.dart';
import '../../widgets/transaction_card.dart';
import '../transaction/add_transaction_screen.dart';
import '../transaction/transaction_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser!.id!;
    
    await Provider.of<CategoryProvider>(context, listen: false).loadCategories(userId);
    await Provider.of<TransactionProvider>(context, listen: false).loadTransactions(userId);
    
    final now = DateTime.now();
    await Provider.of<BudgetProvider>(context, listen: false)
        .loadMonthlyBudget(userId, now.month, now.year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildBalanceCard(),
                  const SizedBox(height: 16),
                  _buildBudgetIndicator(),
                  const SizedBox(height: 24),
                  _buildExpenseChart(),
                  const SizedBox(height: 24),
                  _buildRecentTransactions(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
          if (result == true) {
            _loadData();
          }
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      alignment: Alignment.centerLeft,
      child: Text(
        AppConstants.appName,
        style: AppTextStyles.appTitle,
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, _) {
        final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
        
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.accentGreen,
            border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2), width: 1),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Saldo
              Opacity(
                opacity: 0.90,
                child: Text(
                  'TOTAL SALDO',
                  style: AppTextStyles.labelText.copyWith(
                    color: const Color(0xFF00422B),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatter.format(transactionProvider.balance),
                style: AppTextStyles.balanceAmount,
              ),
              
              const SizedBox(height: 24),
              
              // Income & Expense Cards
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Pemasukan',
                          style: AppTextStyles.labelText.copyWith(
                            color: Colors.white.withOpacity(0.80),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.arrow_downward, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              formatter.format(transactionProvider.totalIncome),
                              style: AppTextStyles.heading2.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Pengeluaran',
                          style: AppTextStyles.labelText.copyWith(
                            color: Colors.white.withOpacity(0.80),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              formatter.format(transactionProvider.totalExpense),
                              style: AppTextStyles.heading2.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBudgetIndicator() {
    return Consumer2<BudgetProvider, TransactionProvider>(
      builder: (context, budgetProvider, transactionProvider, _) {
        if (!budgetProvider.hasTarget) {
          return Card(
            color: AppColors.cardBackground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.accentBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Belum ada target bulanan',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: _showSetBudgetDialog,
                    child: Text(
                      'Atur',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.accentBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final expense = budgetProvider.monthlyExpense;
        final target = budgetProvider.monthlyTarget!;
        final budgetColor = BudgetCalculator.getBudgetColor(expense, target);
        final budgetMessage = BudgetCalculator.getBudgetMessage(expense, target);
        final percentage = BudgetCalculator.calculatePercentage(expense, target);
        final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

        return Card(
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target Bulanan',
                      style: AppTextStyles.heading3,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      color: AppColors.textSecondary,
                      onPressed: _showSetBudgetDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatter.format(expense),
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: budgetColor,
                      ),
                    ),
                    Text(
                      '/ ${formatter.format(target)}',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(budgetColor),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: budgetColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        budgetMessage,
                        style: AppTextStyles.bodySmall.copyWith(color: budgetColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSetBudgetDialog() {
    final controller = TextEditingController();
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    
    if (budgetProvider.monthlyTarget != null) {
      controller.text = budgetProvider.monthlyTarget!.toStringAsFixed(0);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Atur Target Bulanan', style: AppTextStyles.heading3),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            labelText: 'Target Pengeluaran',
            labelStyle: AppTextStyles.bodyMedium,
            prefixText: 'Rp ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final now = DateTime.now();
                await budgetProvider.setMonthlyTarget(
                  authProvider.currentUser!.id!,
                  value,
                  now.month,
                  now.year,
                );
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Target berhasil diatur')),
                  );
                }
              }
            },
            child: Text('Simpan', style: TextStyle(color: AppColors.accentBlue)),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseChart() {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, _) {
        final expenseData = transactionProvider.expenseByCategory;
        
        if (expenseData.isEmpty) {
          return Card(
            color: AppColors.cardBackground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Grafik Pengeluaran', style: AppTextStyles.heading3),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data pengeluaran',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Grafik Pengeluaran per Kategori', style: AppTextStyles.heading3),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: _buildPieChartSections(expenseData),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildLegend(expenseData),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildPieChartSections(Map<String, double> data) {
    final colors = [
      AppColors.accentRed,
      AppColors.accentBlue,
      AppColors.accentGreen,
      AppColors.accentYellow,
      Colors.purple,
      Colors.orange,
    ];

    final total = data.values.fold(0.0, (sum, value) => sum + value);
    int colorIndex = 0;

    return data.entries.map((entry) {
      final percentage = (entry.value / total * 100);
      final color = colors[colorIndex % colors.length];
      colorIndex++;

      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        color: color,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<Widget> _buildLegend(Map<String, double> data) {
    final colors = [
      AppColors.accentRed,
      AppColors.accentBlue,
      AppColors.accentGreen,
      AppColors.accentYellow,
      Colors.purple,
      Colors.orange,
    ];

    int colorIndex = 0;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return data.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                entry.key,
                style: AppTextStyles.bodyMedium,
              ),
            ),
            Text(
              formatter.format(entry.value),
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildRecentTransactions() {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, _) {
        final recentTransactions = transactionProvider.transactions.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transaksi Terakhir', style: AppTextStyles.heading3),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TransactionListScreen()),
                    );
                  },
                  child: Text(
                    'Lihat Semua',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.accentBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (recentTransactions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Belum ada transaksi',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentTransactions.length,
                itemBuilder: (context, index) {
                  return TransactionCard(
                    transaction: recentTransactions[index],
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
