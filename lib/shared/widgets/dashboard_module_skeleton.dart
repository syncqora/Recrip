import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Skeleton shown while dashboard modules are loading.
class DashboardModuleSkeleton extends StatelessWidget {
  const DashboardModuleSkeleton({super.key, this.navIndex = 0});

  final int navIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 900;
        return Skeletonizer.zone(
          effect: const PulseEffect(
            from: Color(0xFFE6EBF7),
            to: Color(0xFFF4F6FC),
            duration: Duration(milliseconds: 1100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _moduleSkeletonFor(isCompact),
          ),
        );
      },
    );
  }

  Widget _moduleSkeletonFor(bool isCompact) {
    switch (navIndex) {
      case 1:
        return isCompact
            ? const _CompactMembersSkeleton()
            : const _DesktopMembersSkeleton();
      case 2:
        return isCompact
            ? const _CompactSubscriptionsSkeleton()
            : const _DesktopSubscriptionsSkeleton();
      case 3:
        return isCompact
            ? const _CompactRenewalsSkeleton()
            : const _DesktopRenewalsSkeleton();
      case 4:
        return isCompact
            ? const _CompactRemindersSkeleton()
            : const _DesktopRemindersSkeleton();
      case 5:
        return isCompact
            ? const _CompactReportsSkeleton()
            : const _DesktopReportsSkeleton();
      case 6:
        return isCompact
            ? const _CompactSettingsSkeleton()
            : const _DesktopSettingsSkeleton();
      case 0:
      default:
        return isCompact
            ? const _CompactDashboardSkeleton()
            : const _DesktopDashboardSkeleton();
    }
  }
}

class _DesktopDashboardSkeleton extends StatelessWidget {
  const _DesktopDashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone.text(words: 2),
                  SizedBox(height: 8),
                  Bone.text(words: 3),
                ],
              ),
            ),
            SizedBox(width: 16),
            Bone.button(height: 40, width: 120),
          ],
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _KpiCardSkeleton()),
            SizedBox(width: 16),
            Expanded(child: _KpiCardSkeleton()),
            SizedBox(width: 16),
            Expanded(child: _KpiCardSkeleton()),
            SizedBox(width: 16),
            Expanded(child: _KpiCardSkeleton()),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 2, child: _RenewalsTableSkeleton()),
              SizedBox(width: 18),
              Expanded(flex: 1, child: _InsightsColumnSkeleton()),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompactDashboardSkeleton extends StatelessWidget {
  const _CompactDashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Bone.text(words: 2),
        SizedBox(height: 8),
        Bone.text(words: 3),
        SizedBox(height: 14),
        Bone.button(height: 40, width: 150),
        SizedBox(height: 18),
        _KpiCardSkeleton(),
        SizedBox(height: 10),
        _KpiCardSkeleton(),
        SizedBox(height: 10),
        _KpiCardSkeleton(),
        SizedBox(height: 10),
        _KpiCardSkeleton(),
        SizedBox(height: 16),
        _RenewalsTableSkeleton(),
        SizedBox(height: 16),
        SizedBox(height: 360, child: _InsightsColumnSkeleton()),
      ],
    );
  }
}

class _KpiCardSkeleton extends StatelessWidget {
  const _KpiCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            Bone.circle(size: 36),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Bone.text(words: 1),
                  SizedBox(height: 8),
                  Bone.text(words: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RenewalsTableSkeleton extends StatelessWidget {
  const _RenewalsTableSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Row(
              children: [
                Expanded(child: Bone.text(words: 3)),
                SizedBox(width: 8),
                Bone.text(words: 2),
              ],
            ),
            SizedBox(height: 14),
            Bone.text(words: 12),
            SizedBox(height: 8),
            _TableRowSkeleton(),
            SizedBox(height: 8),
            _TableRowSkeleton(),
            SizedBox(height: 8),
            _TableRowSkeleton(),
            SizedBox(height: 8),
            _TableRowSkeleton(),
            SizedBox(height: 8),
            _TableRowSkeleton(),
            SizedBox(height: 8),
            _TableRowSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _TableRowSkeleton extends StatelessWidget {
  const _TableRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 3, child: Bone.text(words: 2)),
        SizedBox(width: 10),
        Expanded(flex: 2, child: Bone.text(words: 1)),
        SizedBox(width: 10),
        Expanded(flex: 2, child: Bone.text(words: 1)),
        SizedBox(width: 10),
        Expanded(flex: 2, child: Bone.button(height: 20, width: 72)),
        SizedBox(width: 10),
        Bone.icon(size: 18),
        SizedBox(width: 8),
        Bone.icon(size: 18),
      ],
    );
  }
}

class _InsightsColumnSkeleton extends StatelessWidget {
  const _InsightsColumnSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 2),
                SizedBox(height: 10),
                Bone.multiText(lines: 3),
                SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: Bone.button(height: 34, width: 130),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 14),
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone.text(words: 2),
                  SizedBox(height: 18),
                  Center(child: Bone.circle(size: 120)),
                  SizedBox(height: 18),
                  Bone.text(words: 5),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopMembersSkeleton extends StatelessWidget {
  const _DesktopMembersSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderWithActionSkeleton(),
        SizedBox(height: 20),
        _SearchAndFiltersRowSkeleton(),
        SizedBox(height: 18),
        Expanded(child: _LargeTableCardSkeleton()),
      ],
    );
  }
}

class _CompactMembersSkeleton extends StatelessWidget {
  const _CompactMembersSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _HeaderWithActionSkeleton(),
        SizedBox(height: 16),
        _SearchAndFiltersStackSkeleton(),
        SizedBox(height: 16),
        SizedBox(height: 360, child: _LargeTableCardSkeleton()),
      ],
    );
  }
}

class _DesktopSubscriptionsSkeleton extends StatelessWidget {
  const _DesktopSubscriptionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderWithActionSkeleton(),
        SizedBox(height: 20),
        Expanded(child: _LargeTableCardSkeleton()),
      ],
    );
  }
}

class _CompactSubscriptionsSkeleton extends StatelessWidget {
  const _CompactSubscriptionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _HeaderWithActionSkeleton(),
        SizedBox(height: 16),
        SizedBox(height: 360, child: _LargeTableCardSkeleton()),
      ],
    );
  }
}

class _DesktopRenewalsSkeleton extends StatelessWidget {
  const _DesktopRenewalsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderTextOnlySkeleton(),
        SizedBox(height: 18),
        _StatusTabsSkeleton(),
        SizedBox(height: 18),
        _SearchAndFiltersRowSkeleton(),
        SizedBox(height: 18),
        Expanded(child: _LargeTableCardSkeleton()),
      ],
    );
  }
}

class _CompactRenewalsSkeleton extends StatelessWidget {
  const _CompactRenewalsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _HeaderTextOnlySkeleton(),
        SizedBox(height: 16),
        _StatusTabsSkeleton(),
        SizedBox(height: 16),
        _SearchAndFiltersStackSkeleton(),
        SizedBox(height: 16),
        SizedBox(height: 360, child: _LargeTableCardSkeleton()),
      ],
    );
  }
}

class _DesktopRemindersSkeleton extends StatelessWidget {
  const _DesktopRemindersSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderWithActionSkeleton(),
        SizedBox(height: 20),
        _SimpleSectionCardSkeleton(),
        SizedBox(height: 16),
        Expanded(child: _SimpleSectionCardSkeleton()),
      ],
    );
  }
}

class _CompactRemindersSkeleton extends StatelessWidget {
  const _CompactRemindersSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _HeaderWithActionSkeleton(),
        SizedBox(height: 16),
        SizedBox(height: 220, child: _SimpleSectionCardSkeleton()),
        SizedBox(height: 16),
        SizedBox(height: 220, child: _SimpleSectionCardSkeleton()),
      ],
    );
  }
}

class _DesktopReportsSkeleton extends StatelessWidget {
  const _DesktopReportsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderTextOnlySkeleton(),
        SizedBox(height: 18),
        Row(
          children: [
            Expanded(child: _KpiCardSkeleton()),
            SizedBox(width: 12),
            Expanded(child: _KpiCardSkeleton()),
            SizedBox(width: 12),
            Expanded(child: _KpiCardSkeleton()),
            SizedBox(width: 12),
            Expanded(child: _KpiCardSkeleton()),
          ],
        ),
        SizedBox(height: 18),
        Expanded(child: _LargeTableCardSkeleton()),
      ],
    );
  }
}

class _CompactReportsSkeleton extends StatelessWidget {
  const _CompactReportsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _HeaderTextOnlySkeleton(),
        SizedBox(height: 16),
        _KpiCardSkeleton(),
        SizedBox(height: 10),
        _KpiCardSkeleton(),
        SizedBox(height: 10),
        _KpiCardSkeleton(),
        SizedBox(height: 10),
        _KpiCardSkeleton(),
        SizedBox(height: 16),
        SizedBox(height: 300, child: _LargeTableCardSkeleton()),
      ],
    );
  }
}

class _DesktopSettingsSkeleton extends StatelessWidget {
  const _DesktopSettingsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderTextOnlySkeleton(),
        SizedBox(height: 18),
        Expanded(
          child: Row(
            children: [
              SizedBox(width: 210, child: _SettingsSideNavSkeleton()),
              SizedBox(width: 14),
              Expanded(child: _SettingsFormSkeleton()),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompactSettingsSkeleton extends StatelessWidget {
  const _CompactSettingsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _HeaderTextOnlySkeleton(),
        SizedBox(height: 16),
        _SettingsSideNavSkeleton(),
        SizedBox(height: 12),
        SizedBox(height: 320, child: _SettingsFormSkeleton()),
      ],
    );
  }
}

class _HeaderWithActionSkeleton extends StatelessWidget {
  const _HeaderWithActionSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _HeaderTextOnlySkeleton()),
        SizedBox(width: 12),
        Bone.button(height: 40, width: 120),
      ],
    );
  }
}

class _HeaderTextOnlySkeleton extends StatelessWidget {
  const _HeaderTextOnlySkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Bone.text(words: 2), SizedBox(height: 8), Bone.text(words: 4)],
    );
  }
}

class _SearchAndFiltersRowSkeleton extends StatelessWidget {
  const _SearchAndFiltersRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Bone.button(height: 42)),
        SizedBox(width: 12),
        Bone.button(height: 42, width: 120),
        SizedBox(width: 12),
        Bone.button(height: 42, width: 120),
      ],
    );
  }
}

class _SearchAndFiltersStackSkeleton extends StatelessWidget {
  const _SearchAndFiltersStackSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Bone.button(height: 42),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: Bone.button(height: 42)),
            SizedBox(width: 10),
            Expanded(child: Bone.button(height: 42)),
          ],
        ),
      ],
    );
  }
}

class _StatusTabsSkeleton extends StatelessWidget {
  const _StatusTabsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Bone.button(height: 40, width: 70),
        SizedBox(width: 8),
        Bone.button(height: 40, width: 100),
        SizedBox(width: 8),
        Bone.button(height: 40, width: 100),
        SizedBox(width: 8),
        Bone.button(height: 40, width: 100),
      ],
    );
  }
}

class _LargeTableCardSkeleton extends StatelessWidget {
  const _LargeTableCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Bone.text(words: 10),
            SizedBox(height: 10),
            _TableRowSkeleton(),
            SizedBox(height: 10),
            _TableRowSkeleton(),
            SizedBox(height: 10),
            _TableRowSkeleton(),
            SizedBox(height: 10),
            _TableRowSkeleton(),
            SizedBox(height: 10),
            _TableRowSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _SimpleSectionCardSkeleton extends StatelessWidget {
  const _SimpleSectionCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Bone.text(words: 3),
            SizedBox(height: 8),
            Bone.multiText(lines: 2),
            SizedBox(height: 10),
            Bone.text(words: 10),
            SizedBox(height: 10),
            _TableRowSkeleton(),
            SizedBox(height: 10),
            _TableRowSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _SettingsSideNavSkeleton extends StatelessWidget {
  const _SettingsSideNavSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Bone.button(height: 36),
            SizedBox(height: 8),
            Bone.button(height: 36),
            SizedBox(height: 8),
            Bone.button(height: 36),
          ],
        ),
      ),
    );
  }
}

class _SettingsFormSkeleton extends StatelessWidget {
  const _SettingsFormSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Bone.text(words: 2)),
                SizedBox(width: 8),
                Bone.button(height: 36, width: 80),
                SizedBox(width: 8),
                Bone.button(height: 36, width: 80),
              ],
            ),
            SizedBox(height: 14),
            Bone.button(height: 80),
            SizedBox(height: 14),
            Bone.button(height: 40, width: 260),
            SizedBox(height: 10),
            Bone.button(height: 40, width: 260),
            SizedBox(height: 10),
            Bone.button(height: 40, width: 260),
          ],
        ),
      ),
    );
  }
}
