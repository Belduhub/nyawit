import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Tentang Kami', style: AppTextStyles.appTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Title
            Text(
              'Nyawit',
              style: AppTextStyles.largeTitle.copyWith(
                color: AppColors.primaryGreen,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Aplikasi Pencatat & Pengelola Keuangan',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Developer Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor, width: 1),
              ),
              child: Column(
                children: [
                  Text(
                    'Dikembangkan Oleh',
                    style: AppTextStyles.heading3,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Developer 1 - Danang
                  _buildDeveloperCard(
                    name: AppConstants.developer1Name,
                    nim: AppConstants.developer1NIM,
                    imagePath: 'assets/danankmobile.jpeg',
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Developer 2 - Gorga
                  _buildDeveloperCard(
                    name: AppConstants.developer2Name,
                    nim: AppConstants.developer2NIM,
                    imagePath: 'assets/gorokmobile.jpeg',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Tentang Aplikasi
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tentang Aplikasi',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nyawit adalah aplikasi keuangan pribadi yang dibuat khusus untuk membantu mahasiswa dan anak muda mengelola uang jajan mereka. Nama "Nyawit" sendiri berasal dari bahasa Jawa yang artinya "nyari duwit" atau mencari uang. Aplikasi ini dirancang sederhana tapi cukup lengkap untuk kebutuhan sehari-hari.',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Dengan Nyawit, kamu bisa catat semua pemasukan dan pengeluaran, lihat statistik keuangan lewat grafik yang gampang dipahami, atur budget bulanan biar gak boros, dan pasang reminder untuk bayar-bayar rutin seperti kos, pulsa, atau subscription. Semua data disimpan lokal di HP, jadi privasi terjaga dan bisa dipakai offline.',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aplikasi ini dibuat sebagai tugas akhir mata kuliah Uji Kualitas Perangkat Lunak (UKPL) semester 6. Kami menerapkan berbagai metode testing mulai dari unit test, integration test, sampai security testing untuk memastikan aplikasi berjalan stabil dan aman digunakan.',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Tech Stack
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Technology Stack',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 16),
                  _buildTechItem('Framework', 'Flutter 3.x'),
                  _buildTechItem('Language', 'Dart'),
                  _buildTechItem('Database', 'SQLite'),
                  _buildTechItem('State Management', 'Provider'),
                  _buildTechItem('Architecture', 'MVC (Model-View-Controller)'),
                  _buildTechItem('Charts', 'FL Chart'),
                  _buildTechItem('Notifications', 'Flutter Local Notifications'),
                  _buildTechItem('Security', 'Crypto (Password Hashing)'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Footer
            Text(
              '© 2024 Nyawit',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dibuat di Yogyakarta, Indonesia',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperCard({
    required String name,
    required String nim,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: Row(
        children: [
          // Developer Photo
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryGreen, width: 2),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nim,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            ': ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
