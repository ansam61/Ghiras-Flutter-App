import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'organic_treatment_screen.dart';

class AIDiagnosisResultScreen extends StatelessWidget {
  const AIDiagnosisResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('تقرير التشخيص النهائي'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Red Alert Box matching XD Screen 16
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.alertRedBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.alertRedText.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'عفن الجذور الفطري',
                              style: TextStyle(
                                color: AppTheme.alertRedText,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'دقة مطابقة الذكاء الاصطناعي: 96%',
                              style: TextStyle(
                                color: AppTheme.alertRedText,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppTheme.alertRedText,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.priority_high_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: Color(0xFFFCA5A5)),
                    const Text(
                      'الأعراض الظاهرة حالياً:',
                      style: TextStyle(
                        color: AppTheme.alertRedText,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'ذبول عام، وااصفرار الأوراق السفلية مع سيقان بنية رطبة متهالكة تفقد النبتة قوتها الحيوية.',
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Causes Box matching XD Screen 16
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تحليل أسباب الإصابة بالمرض:',
                      style: TextStyle(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _bulletPoint('كثرة ري النبتة قبل جفاف التربة تماماً'),
                    const SizedBox(height: 8),
                    _bulletPoint('انسداد فتحات تصريف المياه أسفل الحوض'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Emergency First Aid Box matching XD Screen 16
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLightGreen,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'إسعاف أولي طارئ لإنقاذها:',
                            style: TextStyle(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'أوقفي الري تماماً حالاً، وانقلي وعاء النبتة إلى منطقة جيدة التهوية وبعيدة عن الشمس الحارة.',
                            style: TextStyle(
                              color: AppTheme.textDark,
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Action Button matching XD Screen 16
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const OrganicTreatmentScreen()),
                  );
                },
                child: const Text('عرض الخطة العلاجية والبدائل العضوية'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppTheme.alertRedText,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
