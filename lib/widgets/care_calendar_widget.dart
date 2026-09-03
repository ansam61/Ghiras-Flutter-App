import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CareCalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CareCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<CareCalendarWidget> createState() => _CareCalendarWidgetState();
}

class _CareCalendarWidgetState extends State<CareCalendarWidget> {
  late DateTime _currentMonth;
  late DateTime _focusedDate;

  @override
  void initState() {
    super.initState();
    _focusedDate = widget.selectedDate;
    _currentMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  String _getMonthName(int month) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstDayOffset =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.sleekShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Month Navigation Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded,
                    color: AppTheme.primaryGreen, size: 28),
                onPressed: _previousMonth,
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded,
                      color: AppTheme.primaryGreen, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded,
                    color: AppTheme.primaryGreen, size: 28),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Days of the week header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _WeekdayLabel('أحد'),
              _WeekdayLabel('إثن'),
              _WeekdayLabel('ثلا'),
              _WeekdayLabel('أرب'),
              _WeekdayLabel('خمي'),
              _WeekdayLabel('جمعة'),
              _WeekdayLabel('سبت'),
            ],
          ),
          const SizedBox(height: 12),

          // Calendar Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: daysInMonth + firstDayOffset,
            itemBuilder: (context, index) {
              if (index < firstDayOffset) {
                return const SizedBox();
              }
              final dayNumber = index - firstDayOffset + 1;
              final dayDate = DateTime(
                  _currentMonth.year, _currentMonth.month, dayNumber);
              final isSelected = DateUtils.isSameDay(dayDate, _focusedDate);
              final isToday = DateUtils.isSameDay(dayDate, DateTime.now());

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _focusedDate = dayDate;
                  });
                  widget.onDateSelected(dayDate);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryGreen
                        : isToday
                            ? AppTheme.mintSoft
                            : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday && !isSelected
                        ? Border.all(color: AppTheme.primaryGreen, width: 1.5)
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? AppTheme.primaryGreen
                                  : AppTheme.textDark,
                          fontWeight:
                              isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      if (isSelected)
                        const Positioned(
                          bottom: 4,
                          child: Icon(Icons.water_drop, size: 8, color: Colors.white),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String label;
  const _WeekdayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppTheme.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
