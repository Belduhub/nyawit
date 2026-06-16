import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../providers/auth_provider.dart';
import '../../providers/category_provider.dart';
import '../../services/database_service.dart';
import '../../models/transaction_model.dart' as models;
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class DeveloperTestingScreen extends StatefulWidget {
  const DeveloperTestingScreen({super.key});

  @override
  State<DeveloperTestingScreen> createState() => _DeveloperTestingScreenState();
}

class _DeveloperTestingScreenState extends State<DeveloperTestingScreen> {
  final DatabaseService _dbHelper = DatabaseService.instance;
  
  bool _isLoadTesting = false;
  bool _isStressTesting = false;
  
  String? _loadTestResult;
  String? _stressTestResult;
  
  int _loadTestDuration = 0;
  int _stressTestDuration = 0;

  Future<void> _runLoadTest() async {
    setState(() {
      _isLoadTesting = true;
      _loadTestResult = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final userId = authProvider.currentUser!.id!;
      
      // Get categories
      final expenseCategories = categoryProvider.expenseCategories;
      final incomeCategories = categoryProvider.incomeCategories;
      
      if (expenseCategories.isEmpty && incomeCategories.isEmpty) {
        setState(() {
          _loadTestResult = 'Error: Tidak ada kategori yang tersedia';
          _isLoadTesting = false;
        });
        return;
      }

      final random = Random();
      final List<models.Transaction> testTransactions = [];
      
      // Generate 1000 transactions
      final startTime = DateTime.now();
      
      for (int i = 0; i < AppConstants.loadTestCount; i++) {
        final isIncome = random.nextBool();
        final categories = isIncome ? incomeCategories : expenseCategories;
        
        if (categories.isEmpty) continue;
        
        final category = categories[random.nextInt(categories.length)];
        final amount = (random.nextInt(50000) + 1000).toDouble();
        final daysAgo = random.nextInt(365);
        final date = DateTime.now().subtract(Duration(days: daysAgo));
        
        testTransactions.add(models.Transaction(
          userId: userId,
          categoryId: category.id!,
          categoryName: category.name,
          amount: amount,
          type: isIncome ? 'income' : 'expense',
          date: date,
          note: 'Load Test Transaction #${i + 1}',
        ));
      }
      
      // Bulk insert
      await _dbHelper.bulkInsertTransactions(testTransactions);
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      
      setState(() {
        _loadTestDuration = duration;
        _loadTestResult = '✅ Load Test Berhasil!\n\n'
            '📊 Data yang diinsert: ${AppConstants.loadTestCount} transaksi\n'
            '⏱️ Waktu eksekusi: $duration ms (${(duration / 1000).toStringAsFixed(2)} detik)\n'
            '⚡ Kecepatan: ${(AppConstants.loadTestCount / (duration / 1000)).toStringAsFixed(2)} transaksi/detik';
        _isLoadTesting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Load Test selesai dalam $duration ms'),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _loadTestResult = '❌ Load Test Gagal!\n\nError: $e';
        _isLoadTesting = false;
      });
    }
  }

  Future<void> _runStressTest() async {
    setState(() {
      _isStressTesting = true;
      _stressTestResult = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final userId = authProvider.currentUser!.id!;
      
      // Get categories
      final expenseCategories = categoryProvider.expenseCategories;
      final incomeCategories = categoryProvider.incomeCategories;
      
      if (expenseCategories.isEmpty && incomeCategories.isEmpty) {
        setState(() {
          _stressTestResult = 'Error: Tidak ada kategori yang tersedia';
          _isStressTesting = false;
        });
        return;
      }

      final random = Random();
      final startTime = DateTime.now();
      
      // Insert in batches of 1000 for better performance
      const batchSize = 1000;
      final totalBatches = (AppConstants.stressTestCount / batchSize).ceil();
      
      for (int batch = 0; batch < totalBatches; batch++) {
        final List<models.Transaction> batchTransactions = [];
        final currentBatchSize = batch == totalBatches - 1 
            ? AppConstants.stressTestCount - (batch * batchSize)
            : batchSize;
        
        for (int i = 0; i < currentBatchSize; i++) {
          final isIncome = random.nextBool();
          final categories = isIncome ? incomeCategories : expenseCategories;
          
          if (categories.isEmpty) continue;
          
          final category = categories[random.nextInt(categories.length)];
          final amount = (random.nextInt(100000) + 1000).toDouble();
          final daysAgo = random.nextInt(730); // 2 years
          final date = DateTime.now().subtract(Duration(days: daysAgo));
          
          batchTransactions.add(models.Transaction(
            userId: userId,
            categoryId: category.id!,
            categoryName: category.name,
            amount: amount,
            type: isIncome ? 'income' : 'expense',
            date: date,
            note: 'Stress Test Transaction #${batch * batchSize + i + 1}',
          ));
        }
        
        // Bulk insert batch
        await _dbHelper.bulkInsertTransactions(batchTransactions);
        
        // Update progress
        if (mounted) {
          setState(() {
            _stressTestResult = '⏳ Progress: ${((batch + 1) / totalBatches * 100).toStringAsFixed(1)}%\n'
                'Batch ${batch + 1} of $totalBatches completed...';
          });
        }
      }
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      
      setState(() {
        _stressTestDuration = duration;
        _stressTestResult = '✅ Stress Test Berhasil!\n\n'
            '📊 Data yang diinsert: ${AppConstants.stressTestCount} transaksi\n'
            '⏱️ Waktu eksekusi: $duration ms (${(duration / 1000).toStringAsFixed(2)} detik)\n'
            '⚡ Kecepatan: ${(AppConstants.stressTestCount / (duration / 1000)).toStringAsFixed(2)} transaksi/detik\n\n'
            '💡 Tip: Pantau penggunaan RAM/CPU melalui Flutter DevTools';
        _isStressTesting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stress Test selesai dalam $duration ms'),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _stressTestResult = '❌ Stress Test Gagal!\n\nError: $e';
        _isStressTesting = false;
      });
    }
  }

  Future<void> _clearAllTestData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Hapus Semua Data Test', style: AppTextStyles.heading3),
        content: Text(
          'Apakah Anda yakin ingin menghapus SEMUA transaksi? '
          'Tindakan ini tidak dapat dibatalkan!',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus Semua', style: TextStyle(color: AppColors.accentRed)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final userId = authProvider.currentUser!.id!;
        
        await _dbHelper.clearAllTransactions(userId);
        
        setState(() {
          _loadTestResult = null;
          _stressTestResult = null;
          _loadTestDuration = 0;
          _stressTestDuration = 0;
        });
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Semua data test berhasil dihapus'),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Future<void> _showAllUsers() async {
    try {
      final users = await _dbHelper.getAllUsers();
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Registered Users (${users.length})'),
            content: SizedBox(
              width: double.maxFinite,
              child: users.isEmpty
                  ? const Text('Belum ada user terdaftar')
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.accentGreen,
                            child: Text(user.fullName[0].toUpperCase()),
                          ),
                          title: Text(user.fullName),
                          subtitle: Text('@${user.username}'),
                          trailing: Text('ID: ${user.id}'),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading users: $e'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Future<void> _confirmResetDatabase() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.warning, color: AppColors.accentRed),
            SizedBox(width: 8),
            Text('PERINGATAN!'),
          ],
        ),
        content: const Text(
          'Ini akan menghapus SELURUH DATABASE termasuk:\n'
          '• Semua user dan akun\n'
          '• Semua transaksi\n'
          '• Semua kategori\n'
          '• Semua reminder\n\n'
          'Anda harus login ulang setelah reset.\n\n'
          'Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('RESET DATABASE', style: TextStyle(color: AppColors.accentRed, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _dbHelper.deleteDatabase();
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Database berhasil direset! Silakan restart aplikasi.'),
            backgroundColor: AppColors.accentGreen,
            duration: Duration(seconds: 5),
          ),
        );
        
        // Logout and return to login screen
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.logout();
        
        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Developer Testing', style: AppTextStyles.heading3),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.accentGreen),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Halaman ini untuk menguji performa aplikasi dengan Load & Stress Testing',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Load Test Section
              Text('Load Test (1.000 Data)', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Text(
                'Menguji kecepatan insert 1.000 transaksi ke database SQLite',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 16),
              
              CustomButton(
                text: 'Run Load Test',
                onPressed: _isLoadTesting || _isStressTesting ? () {} : _runLoadTest,
                isLoading: _isLoadTesting,
                backgroundColor: AppColors.accentGreen,
              ),
              
              if (_loadTestResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Text(
                    _loadTestResult!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Stress Test Section
              Text('Stress Test (20.000 Data)', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Text(
                'Menguji batas ketahanan aplikasi dengan insert 20.000 transaksi secara massal',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 16),
              
              CustomButton(
                text: 'Run Stress Test',
                onPressed: _isLoadTesting || _isStressTesting ? () {} : _runStressTest,
                isLoading: _isStressTesting,
                backgroundColor: AppColors.accentRed,
              ),
              
              if (_stressTestResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Text(
                    _stressTestResult!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Clear Data Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber, color: AppColors.accentYellow),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Setelah testing, hapus data test untuk membersihkan database',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Hapus Semua Data Test',
                      onPressed: _isLoadTesting || _isStressTesting 
                          ? () {} 
                          : _clearAllTestData,
                      backgroundColor: AppColors.accentRed,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Database Debug Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bug_report, color: AppColors.accentRed),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Debug Tools - Untuk mengatasi masalah database',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showAllUsers,
                            icon: const Icon(Icons.people),
                            label: const Text('Lihat Users'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGreen,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _confirmResetDatabase,
                            icon: const Icon(Icons.delete_forever),
                            label: const Text('Reset DB'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Test Summary
              if (_loadTestDuration > 0 || _stressTestDuration > 0) ...[
                Text('Ringkasan Test', style: AppTextStyles.heading3),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    children: [
                      if (_loadTestDuration > 0)
                        _buildSummaryRow(
                          'Load Test',
                          '${AppConstants.loadTestCount} data',
                          '$_loadTestDuration ms',
                        ),
                      if (_loadTestDuration > 0 && _stressTestDuration > 0)
                        const Divider(height: 32),
                      if (_stressTestDuration > 0)
                        _buildSummaryRow(
                          'Stress Test',
                          '${AppConstants.stressTestCount} data',
                          '$_stressTestDuration ms',
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String count, String duration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(count, style: AppTextStyles.bodySmall),
          ],
        ),
        Text(
          duration,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.accentGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
