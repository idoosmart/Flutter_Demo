/// 手机日历 .cal 裁剪策略
sealed class PhoneCalendarCropStrategy {
  const PhoneCalendarCropStrategy();

  int get cropStrategyId;

  Map<String, dynamic> toJson();
}

/// 默认策略 1：双端裁剪，保留基准月
class TrimBothEndsKeepAnchorMonthStrategy extends PhoneCalendarCropStrategy {
  final int anchorYear;
  final int anchorMonth;
  final int syncMonthsBefore;
  final int syncMonthsAfter;

  const TrimBothEndsKeepAnchorMonthStrategy({
    required this.anchorYear,
    required this.anchorMonth,
    this.syncMonthsBefore = 6,
    this.syncMonthsAfter = 6,
  });

  @override
  int get cropStrategyId => 1;

  @override
  Map<String, dynamic> toJson() => {
        'crop_strategy': cropStrategyId,
        'anchor_year': anchorYear,
        'anchor_month': anchorMonth,
        'sync_months_before': syncMonthsBefore,
        'sync_months_after': syncMonthsAfter,
      };
}

class PhoneCalendarCropStrategyRegistry {
  static TrimBothEndsKeepAnchorMonthStrategy defaultStrategy(DateTime anchor) {
    return TrimBothEndsKeepAnchorMonthStrategy(
      anchorYear: anchor.year,
      anchorMonth: anchor.month,
    );
  }

  static PhoneCalendarCropStrategy resolve(PhoneCalendarCropStrategy? strategy) {
    return strategy ?? defaultStrategy(DateTime.now());
  }

  static String? validate(PhoneCalendarCropStrategy strategy) {
    if (strategy is TrimBothEndsKeepAnchorMonthStrategy) {
      if (strategy.anchorYear <= 0 || strategy.anchorMonth < 1 || strategy.anchorMonth > 12) {
        return 'anchor_year/anchor_month invalid';
      }
      return null;
    }
    return 'unsupported crop strategy';
  }
}
