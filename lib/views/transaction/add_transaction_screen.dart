import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../models/category_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _customCategoryController = TextEditingController();
  
  String _selectedType = 'expense';
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _showCustomCategoryField = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.accentGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih kategori terlebih dahulu'),
            backgroundColor: AppColors.accentRed,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      
      final userId = authProvider.currentUser!.id!;
      Category? categoryToUse = _selectedCategory;

      // If "Lainnya" is selected and custom category is entered
      if (_selectedCategory!.name == 'Lainnya' && 
          _showCustomCategoryField && 
          _customCategoryController.text.trim().isNotEmpty) {
        
        // Create new custom category
        final success = await categoryProvider.addCustomCategory(
          name: _customCategoryController.text.trim(),
          type: _selectedType,
          userId: userId,
        );

        if (success) {
          // Find the newly created category
          final categories = _selectedType == 'income'
              ? categoryProvider.incomeCategories
              : categoryProvider.expenseCategories;
          
          categoryToUse = categories.firstWhere(
            (cat) => cat.name == _customCategoryController.text.trim(),
            orElse: () => _selectedCategory!,
          );
        }
      }

      final amount = double.parse(_amountController.text);
      
      final success = await transactionProvider.addTransaction(
        userId: userId,
        categoryId: categoryToUse!.id!,
        categoryName: categoryToUse.name,
        amount: amount,
        type: _selectedType,
        date: _selectedDate,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (success && mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaksi berhasil ditambahkan'),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menambahkan transaksi'),
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
        title: Text('Tambah Transaksi', style: AppTextStyles.heading3),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Type Selector
                Text('Tipe Transaksi', style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeButton(
                        type: 'income',
                        label: 'Pemasukan',
                        icon: Icons.arrow_downward,
                        color: AppColors.accentGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTypeButton(
                        type: 'expense',
                        label: 'Pengeluaran',
                        icon: Icons.arrow_upward,
                        color: AppColors.accentRed,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Amount Field
                CustomTextField(
                  controller: _amountController,
                  label: 'Nominal',
                  hint: 'Masukkan nominal',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.money, color: AppColors.textSecondary),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nominal tidak boleh kosong';
                    }
                    if (double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Nominal harus lebih dari 0';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Category Dropdown
                Text('Kategori', style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                )),
                const SizedBox(height: 8),
                Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, _) {
                    final categories = _selectedType == 'income'
                        ? categoryProvider.incomeCategories
                        : categoryProvider.expenseCategories;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonFormField<Category>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: InputBorder.none,
                        ),
                        dropdownColor: Colors.white,
                        style: AppTextStyles.bodyLarge,
                        hint: Text('Pilih kategori', style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        )),
                        items: categories.map((category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (Category? value) {
                          setState(() {
                            _selectedCategory = value;
                            // Show custom category field if "Lainnya" is selected
                            _showCustomCategoryField = value?.name == 'Lainnya';
                            if (!_showCustomCategoryField) {
                              _customCategoryController.clear();
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
                
                // Custom Category Field (shown when "Lainnya" is selected)
                if (_showCustomCategoryField) ...[
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _customCategoryController,
                    label: 'Nama Kategori Baru (Opsional)',
                    hint: 'Masukkan nama kategori baru',
                    prefixIcon: const Icon(Icons.category, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kosongkan jika ingin menggunakan kategori "Lainnya"',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentYellow,
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Date Picker
                Text('Tanggal', style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                )),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.textSecondary),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('dd MMMM yyyy').format(_selectedDate),
                          style: AppTextStyles.bodyLarge,
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Note Field
                CustomTextField(
                  controller: _noteController,
                  label: 'Catatan (Opsional)',
                  hint: 'Tambahkan catatan',
                  maxLines: 3,
                  prefixIcon: const Icon(Icons.note, color: AppColors.textSecondary),
                ),
                
                const SizedBox(height: 32),
                
                // Submit Button
                CustomButton(
                  text: 'Simpan Transaksi',
                  onPressed: _handleSubmit,
                  isLoading: _isLoading,
                  backgroundColor: _selectedType == 'income' 
                      ? AppColors.accentGreen 
                      : AppColors.accentRed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String type,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedType == type;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedCategory = null; // Reset category when type changes
          _showCustomCategoryField = false;
          _customCategoryController.clear();
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.textSecondary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
