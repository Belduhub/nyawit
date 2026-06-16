import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/transaction_card.dart';
import 'add_transaction_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  String _filterType = 'all'; // 'all', 'income', 'expense'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Semua Transaksi', style: AppTextStyles.heading3),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: AppColors.primaryGreen),
            onSelected: (value) {
              setState(() {
                _filterType = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Semua')),
              const PopupMenuItem(value: 'income', child: Text('Pemasukan')),
              const PopupMenuItem(value: 'expense', child: Text('Pengeluaran')),
            ],
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, _) {
          var transactions = transactionProvider.transactions;
          
          // Apply filter
          if (_filterType != 'all') {
            transactions = transactions
                .where((t) => t.type == _filterType)
                .toList();
          }

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada transaksi',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionCard(
                transaction: transaction,
                onDelete: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text('Hapus Transaksi', style: AppTextStyles.heading3),
                      content: Text(
                        'Apakah Anda yakin ingin menghapus transaksi ini?',
                        style: AppTextStyles.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Hapus', style: TextStyle(color: AppColors.accentRed)),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    if (!mounted) return;
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    final success = await transactionProvider.deleteTransaction(
                      transaction.id!,
                      authProvider.currentUser!.id!,
                    );

                    if (success) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transaksi berhasil dihapus'),
                          backgroundColor: AppColors.accentGreen,
                        ),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
          if (result == true) {
            if (!mounted) return;
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            await Provider.of<TransactionProvider>(context, listen: false)
                .loadTransactions(authProvider.currentUser!.id!);
          }
        },
        backgroundColor: AppColors.accentGreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
