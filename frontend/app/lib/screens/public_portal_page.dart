import 'package:flutter/material.dart';

class PublicPortalPage extends StatelessWidget {
  const PublicPortalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
        child: Column(
          children: [
            // 1. Hero Header
            _buildHeroHeader(),
            const SizedBox(height: 48),

            // 2. High-Level KPI Row (Centered)
            _buildPublicKPIs(),
            const SizedBox(height: 48),

            // 3. Candidate Results Section
            _buildCandidateResults(),
            const SizedBox(height: 48),

            // 4. State-wise Turnout Grid
            _buildStateTurnoutGrid(),
            const SizedBox(height: 48),

            // 5. Data Integrity Checker (Search Box)
            _buildIntegrityChecker(),
            const SizedBox(height: 48),
            
            const Text(
              "Votify Public Transparency Portal — All data is verified through tamper-proof ledger technology",
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user_outlined, color: Colors.green, size: 14),
              SizedBox(width: 8),
              Text("Data Verified", style: TextStyle(color: Colors.green, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Election Results 2026",
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 12),
        const SizedBox(
          width: 600,
          child: Text(
            "Transparent, tamper-proof election data accessible to every citizen. All records are cryptographically verified.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPublicKPIs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCenteredKPI("TOTAL VOTES", "3,651,210", Icons.how_to_vote_outlined),
        const SizedBox(width: 24),
        _buildCenteredKPI("ACTIVE BOOTHS", "65 / 75", Icons.location_on_outlined),
        const SizedBox(width: 24),
        _buildCenteredKPI("TURNOUT", "2098%", Icons.trending_up),
      ],
    );
  }

  Widget _buildCenteredKPI(String label, String val, IconData icon) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 32),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
              Text(val, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCandidateResults() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Candidate Results", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildPublicCandidateRow("Arvind Sharma", "National Democratic Alliance", 0.342, "1,248,760", Colors.blue, isLeading: true),
          _buildPublicCandidateRow("Priya Mehta", "United Progressive Front", 0.302, "1,102,340", Colors.green, isLeading: false),
          _buildPublicCandidateRow("Rajesh Kumar", "People's Reform Party", 0.198, "724,560", Colors.orange, isLeading: false),
        ],
      ),
    );
  }

  Widget _buildPublicCandidateRow(String name, String party, double pct, String votes, Color color, {required bool isLeading}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: color),
              const SizedBox(width: 12),
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(party, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              if (isLeading) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                  child: const Text("Leading", style: TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ],
              const Spacer(),
              Text(votes, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(" (${(pct * 100).toStringAsFixed(1)}%)", style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: pct, color: color, backgroundColor: Colors.white10, minHeight: 6, borderRadius: BorderRadius.circular(10)),
        ],
      ),
    );
  }

  Widget _buildStateTurnoutGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("State-wise Turnout", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 3,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStateCard("Maharashtra", 0.60, "12/15", "20,872"),
            _buildStateCard("Karnataka", 0.60, "13/15", "20,610"),
            _buildStateCard("Tamil Nadu", 0.63, "14/15", "21,880"),
            _buildStateCard("Uttar Pradesh", 0.64, "13/15", "22,540"),
          ],
        ),
      ],
    );
  }

  Widget _buildStateCard(String state, double turnout, String booths, String votes) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(state, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("$booths booths", style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          const Spacer(),
          LinearProgressIndicator(value: turnout, color: Colors.blueAccent, backgroundColor: Colors.white10, minHeight: 6),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$votes votes", style: const TextStyle(color: Colors.white38, fontSize: 12)),
              Text("${(turnout * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrityChecker() {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.security, color: Colors.blueAccent, size: 20),
              SizedBox(width: 12),
              Text("Data Integrity Checker", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Verify any record by entering its Record ID or Hash", style: TextStyle(color: Colors.white38)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter Record ID (e.g. REC-00001) or Hash...",
                    hintStyle: const TextStyle(color: Colors.white24),
                    prefixIcon: const Icon(Icons.search, color: Colors.white24),
                    filled: true,
                    fillColor: const Color(0xFF0B101B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white10)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20)),
                child: const Text("Verify"),
              )
            ],
          )
        ],
      ),
    );
  }
}