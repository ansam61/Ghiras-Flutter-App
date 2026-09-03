import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'ai_loading_screen.dart';

class AIScannerScreen extends StatelessWidget {
  const AIScannerScreen({super.key});

  void _captureAndAnalyze(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AILoadingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark Theme matching XD Screen 14
      body: SafeArea(
        child: Stack(
          children: [
            // Header Action Icons matching XD Screen 14
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    'ماسح غراس الذكي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.flash_on_rounded, color: Colors.amber, size: 22),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            // Camera Viewfinder Box with Green Corner Borders matching XD Screen 14
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.primaryGreen.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Leaf Watermark inside frame
                        Center(
                          child: Icon(
                            Icons.eco_rounded,
                            size: 140,
                            color: AppTheme.primaryGreen.withOpacity(0.15),
                          ),
                        ),
                        // Corner Guides matching XD Screen 14
                        const Positioned(
                          top: 12,
                          left: 12,
                          child: Icon(Icons.crop_free_rounded,
                              color: AppTheme.primaryGreen, size: 36),
                        ),
                        const Positioned(
                          top: 12,
                          right: 12,
                          child: Icon(Icons.crop_free_rounded,
                              color: AppTheme.primaryGreen, size: 36),
                        ),
                        const Positioned(
                          bottom: 12,
                          left: 12,
                          child: Icon(Icons.crop_free_rounded,
                              color: AppTheme.primaryGreen, size: 36),
                        ),
                        const Positioned(
                          bottom: 12,
                          right: 12,
                          child: Icon(Icons.crop_free_rounded,
                              color: AppTheme.primaryGreen, size: 36),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Instruction Pill matching XD Screen 14
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'ضع ورقة النبتة المصابة داخل الإطار',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Shutter & Controls matching XD Screen 14
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery Pick Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.photo_library_rounded,
                          color: Colors.white, size: 26),
                      onPressed: () => _captureAndAnalyze(context),
                    ),
                  ),

                  // Big Center Shutter Button
                  GestureDetector(
                    onTap: () => _captureAndAnalyze(context),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        color: AppTheme.primaryGreen,
                      ),
                      child: Center(
                        child: Container(
                          width: 62,
                          height: 62,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Camera Flip Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.cameraswitch_rounded,
                          color: Colors.white, size: 26),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
