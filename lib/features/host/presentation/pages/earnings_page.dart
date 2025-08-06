import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  String _selectedPeriod = 'monthly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Earnings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Earnings', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              '\$15,250.00',
              style: AppTextStyles.h1.copyWith(color: AppColors.success),
            ),
            const SizedBox(height: 24),

            // Period selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPeriodChip('Daily', 'daily'),
                _buildPeriodChip('Monthly', 'monthly'),
                _buildPeriodChip('Annually', 'annually'),
              ],
            ),

            const SizedBox(height: 24),

            // Earnings chart
            Text(
              'Earnings Overview (${_selectedPeriod.capitalizeFirst()})',
              style: AppTextStyles.h5,
            ),
            const SizedBox(height: 16),
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: BarChart(
                BarChartData(
                  barGroups: _getBarGroups(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          '\$${value.toInt()}',
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(
                          _getBottomTitles(value),
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      //tooltipBgColor: AppColors.primary,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '\$${rod.toY.toInt()}',
                          AppTextStyles.bodySmall.copyWith(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Text('Transaction History', style: AppTextStyles.h5),
            const SizedBox(height: 16),

            // Transaction list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5, // Replace with actual data
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(Icons.payments, color: AppColors.primary),
                    ),
                    title: Text(
                      'Booking #${1000 + index}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${DateFormat('MMM dd, yyyy').format(DateTime.now().subtract(Duration(days: index * 7)))} - Property ${index + 1}',
                      style: AppTextStyles.bodySmall,
                    ),
                    trailing: Text(
                      '+\$${(index + 1) * 150}.00',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodChip(String label, String value) {
    final isSelected = _selectedPeriod == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedPeriod = value;
        });
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    // Dummy data for chart
    List<double> data;
    switch (_selectedPeriod) {
      case 'daily':
        data = [100, 150, 200, 120, 180, 250, 170];
        break;
      case 'monthly':
        data = [1200, 1500, 1800, 1300, 1600, 2000];
        break;
      case 'annually':
        data = [10000, 12000, 11000, 14000, 13000, 16000];
        break;
      default:
        data = [0, 0, 0, 0, 0, 0];
    }

    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index],
            color: AppColors.primary,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  String _getBottomTitles(double value) {
    switch (_selectedPeriod) {
      case 'daily':
        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return days[value.toInt() % days.length];
      case 'monthly':
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
        return months[value.toInt() % months.length];
      case 'annually':
        final years = ['2020', '2021', '2022', '2023', '2024', '2025'];
        return years[value.toInt() % years.length];
      default:
        return '';
    }
  }
}

extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
