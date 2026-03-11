import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildKPIGrid(),
            const SizedBox(height: 24),
            _buildChartPlaceholder("Live Vote Trend"),
            const SizedBox(height: 24),
            const Text("Recent Alerts", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildAlertList(),
            const SizedBox(height: 24),
            const Text("Region Breakdown", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildRegionTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Command Center", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 8),
        Text("Real-time election monitoring overview", style: TextStyle(color: Colors.white70, fontSize: 16)),
      ],
    );
  }

  Widget _buildKPIGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.0,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        KPICard(title: "TOTAL VOTES", value: "3,651,210", color: Colors.blue),
        KPICard(title: "ACTIVE BOOTHS", value: "65/75", color: Colors.green),
        KPICard(title: "ACTIVE ALERTS", value: "8", color: Colors.red),
        KPICard(title: "TURNOUT", value: "20.98%", color: Colors.teal),
      ],
    );
  }

  // FIXED: Added the missing Chart Placeholder method
  Widget _buildChartPlaceholder(String title) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Center(child: Text(title, style: const TextStyle(color: Colors.white24))),
    );
  }

  // FIXED: Added the missing Alert List method
  Widget _buildAlertList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
          child: const Text("Alert: Ledger Tampering Suspected", style: TextStyle(color: Colors.redAccent)),
        );
      },
    );
  }

  // FIXED: Added the missing Region Table method
  Widget _buildRegionTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("Region")),
          DataColumn(label: Text("Votes")),
          DataColumn(label: Text("Turnout")),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text("Mumbai North")),
            DataCell(Text("4,416")),
            DataCell(Text("64%")),
          ]),
        ],
      ),
    );
  }
}

class KPICard extends StatelessWidget {
  final String title, value;
  final Color color;
  const KPICard({required this.title, required this.value, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}