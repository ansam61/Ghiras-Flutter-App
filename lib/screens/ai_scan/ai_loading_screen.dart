import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'ai_diagnosis_result_screen.dart';

class AILoadingScreen extends StatefulWidget {
  const AILoadingScreen({super.key});

  @override
  State<AILoadingScreen> createState() => _AILoadingScreenState();
}

class _AILoadingScreenState extends State<AILoadingScreen> {
  double _progress = 0.25;

  @override
  void initState() {
    super.initState();
    _startScanningAnimation();
  }

  void _startScanningAnimation() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _progress = 0.75);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _progress = 1.0);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AIDiagnosisResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Circular Progress Ring matching XD Screen 15
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 10,
                      backgroundColor: const Color(0xFFE2E8F0),
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.eco_rounded,
                          color: AppTheme.primaryGreen,
                          size: 40,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(_progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: AppTheme.primaryGreen,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Status Text matching XD Screen 15
              const Text(
                'AI جاري تحليل الأوراق بالـ',
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'نطابق بنية الخلايا والبقع مع قاعدة البيانات...\nيرجى الانتظار بضع ثوان لقراءة دقيقة',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              // Bottom Tip Box matching XD Screen 15
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.tipYellowBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.tipYellowBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEF3C7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: AppTheme.tipYellowText,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'هل تعلم؟',
                            style: TextStyle(
                              color: AppTheme.tipYellowText,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'أغلب أمراض النباتات المنزلية سببها المباشر هو زيادة الري.',
                            style: TextStyle(
                              color: AppTheme.tipYellowText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
