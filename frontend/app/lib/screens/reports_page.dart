import 'package:flutter/material.dart';

class ElectionReportsPage extends StatelessWidget {
  const ElectionReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Header with Export Button
            _buildHeader(),
            const SizedBox(height: 24),

            // 2. Report Type Selector
            _buildReportSelector(),
            const SizedBox(height: 24),

            // 3. Official Summary Banner
            _buildOfficialBanner(),
            const SizedBox(height: 24),

            // 4. Summary KPI Row (Matches Dashboard style)
            _buildSummaryRow(),
            const SizedBox(height: 24),

            // 5. Candidate-wise Results (Progress Bar List)
            _buildResultsCard(),
            const SizedBox(height: 24),

            // 6. Hourly Voting Pattern (Vertical Bar Chart)
            _buildHourlyPatternCard(),
            const SizedBox(height: 24),

            // 7. Bottom Health & Integrity Grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildHealthCard("EVM Fleet Health")),
                const SizedBox(width: 24),
                Expanded(child: _buildIntegrityCard("Data Integrity Summary")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Election Reports", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("Generate comprehensive election summaries with exportable data", style: TextStyle(color: Colors.white70)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.file_upload_outlined, size: 18),
          label: const Text("Export Report"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
        )
      ],
    );
  }

  Widget _buildReportSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(8)),
      child: DropdownButton<String>(
        value: "Full Summary Report",
        dropdownColor: const Color(0xFF131A2D),
        underline: const SizedBox(),
        items: ["Full Summary Report"].map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(color: Colors.white)));
        }).toList(),
        onChanged: (_) {},
      ),
    );
  }

  Widget _buildOfficialBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined, color: Colors.blueAccent),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Election Day Summary Report", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("Generated for Election Day 2026 • Feb 16, 2026, 10:00 UTC", style: TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent), borderRadius: BorderRadius.circular(20)),
            child: const Row(children: [Icon(Icons.verified_user, size: 12, color: Colors.blueAccent), SizedBox(width: 4), Text("Official", style: TextStyle(color: Colors.blueAccent, fontSize: 12))]),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Row(
      children: [
        _buildReportKPI("Total Votes Cast", "3,651,210", "20.98% turnout", Icons.check_box_outlined, Colors.green),
        const SizedBox(width: 16),
        _buildReportKPI("Booth Status", "65 online", "3 offline of 75", Icons.location_on_outlined, Colors.amber),
        const SizedBox(width: 16),
        _buildReportKPI("Active Alerts", "8", "2 critical", Icons.warning_amber_rounded, Colors.redAccent),
        const SizedBox(width: 16),
        _buildReportKPI("Voter Participation", "924", "of 1,500 registered", Icons.people_outline, Colors.teal),
      ],
    );
  }

  Widget _buildReportKPI(String title, String val, String sub, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.1))),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Candidate-wise Results", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildCandidateBar("Arvind Sharma", "NDA", 0.342, "1,248,760", Colors.blue, "1"),
          _buildCandidateBar("Priya Mehta", "UPF", 0.302, "1,102,340", Colors.teal, "2"),
          _buildCandidateBar("Rajesh Kumar", "PRP", 0.198, "724,560", Colors.orange, "3"),
        ],
      ),
    );
  }

  Widget _buildCandidateBar(String name, String party, double pct, String votes, Color color, String rank) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: color, child: Text(rank, style: const TextStyle(color: Colors.white, fontSize: 12))),
              const SizedBox(width: 12),
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(party, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              const Spacer(),
              Text(votes, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(" (${(pct * 100).toStringAsFixed(1)}%)", style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: pct, color: color, backgroundColor: Colors.white10, minHeight: 8, borderRadius: BorderRadius.circular(4)),
        ],
      ),
    );
  }

  Widget _buildHourlyPatternCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hourly Voting Pattern", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildVerticalBar("07:00", 0.1, "43K"),
                _buildVerticalBar("11:00", 0.9, "418K", active: true),
                _buildVerticalBar("18:00", 0.4, "178K"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBar(String time, double heightPct, String count, {bool active = false}) {
    return Column(
      children: [
        Text(time, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            width: 20,
            decoration: BoxDecoration(
              color: active ? Colors.blueAccent : Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(heightFactor: heightPct, child: Container(decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(4)))),
          ),
        ),
        const SizedBox(height: 8),
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHealthCard(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildRow("Operational EVMs", "71/75", Icons.check_circle_outline, Colors.green),
          _buildRow("Faulty/Replaced", "3", Icons.cancel_outlined, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildIntegrityCard(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildRow("Ledger Records", "40", Icons.check_circle_outline, Colors.green),
          _buildRow("Hash Integrity", "Breaks Found", Icons.warning_amber_rounded, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String val, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Row(children: [Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const SizedBox(width: 8), Icon(icon, color: color, size: 16)]),
        ],
      ),
    );
  }
}