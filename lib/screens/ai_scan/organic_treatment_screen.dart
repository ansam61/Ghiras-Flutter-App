import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class OrganicTreatmentScreen extends StatelessWidget {
  const OrganicTreatmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('الخطة العلاجية والبدائل العضوية'),
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
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLightGreen,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.spa_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'بروتوكول العلاج العضوي الآمن',
                            style: TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'علاج عفن الجذور بدون مواد كيميائية ضارة بالبيئة والصحة.',
                            style: TextStyle(
                              color: AppTheme.textDark,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                'خطوات العلاج الميداني خطوة بخطوة:',
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),

              // Step 1
              _stepCard(
                stepNumber: '1',
                title: 'تقليم وتطهير الجذور المتعفنة',
                description:
                    'إخراج النبتة بحذر من الأحواض، وقص الأجزاء البنية الرطبة بمقص معقم بالكحول لضمان سلامة الجذور السليمة.',
                icon: Icons.content_cut_rounded,
              ),
              const SizedBox(height: 14),

              // Step 2
              _stepCard(
                stepNumber: '2',
                title: 'استخدام بودرة القرفة الطبيعية كمطهر فطري',
                description:
                    'رش بودرة القرفة العضوية مباشرة على قطع الجذور، حيث تعتبر القرفة مضاداً فطرياً طبيعياً شديد الفاعلية.',
                icon: Icons.dry_cleaning_rounded,
              ),
              const SizedBox(height: 14),

              // Step 3
              _stepCard(
                stepNumber: '3',
                title: 'تغيير التربة وتطهير الوعاء',
                description:
                    'غسل الحوض جيداً بالماء والصابون، واستبدال التربة القديمة بتربة جديدة جيدة التصريف تحتوي على البيرلايت.',
                icon: Icons.autorenew_rounded,
              ),
              const SizedBox(height: 28),

              // Organic Alternatives Box
              const Text(
                'بدائل المبيدات العضوية الموصى بها:',
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _remedyItem(
                      name: 'محلول زيت النيم الطبيعي (Neem Oil)',
                      detail: 'خلط 5 مل زيت نيم مع ملعقة صابون عضوي في لتر ماء ورش الأوراق أسفل وفوق شهرياً.',
                    ),
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    _remedyItem(
                      name: 'محلول البابونج الخفيف',
                      detail: 'مغلي البابونج البارد يعتبر مطهراً عضوياً للتربة قبل الري لمنع نمو الفطريات.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم حفظ الخطة العلاجية في مفضلاتك 💚'),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.bookmark_added_rounded),
                label: const Text('حفظ الخطة في سجلي الطبي'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepCard({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppTheme.primaryLightGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _remedyItem({required String name, required String detail}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.verified_rounded,
          color: AppTheme.primaryGreen,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
