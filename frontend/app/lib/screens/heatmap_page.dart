import 'package:flutter/material.dart';

class ElectionHeatmapPage extends StatelessWidget {
  const ElectionHeatmapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Section
            const Text(
              "Election Heatmap",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              "All India",
              style: TextStyle(color: Colors.white38, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // 2. Legend / Intensity Bar
            _buildHeatmapLegend(),
            const SizedBox(height: 32),

            // 3. State Grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 2.2,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStateHeatCard("Maharashtra", 20872, 60, "12/15", 1),
                _buildStateHeatCard("Karnataka", 20610, 60, "13/15", 1),
                _buildStateHeatCard("Tamil Nadu", 21880, 63, "14/15", 0),
                _buildStateHeatCard("Uttar Pradesh", 22540, 64, "13/15", 1),
                _buildStateHeatCard("Gujarat", 22180, 63, "13/15", 1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF131A2D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Text("Vote Intensity:", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(width: 16),
          _buildLegendItem("Low", const Color(0xFF1C243D)),
          _buildLegendItem("25%+", const Color(0xFF2A3A5A)),
          _buildLegendItem("40%+", const Color(0xFF3B5B8C)),
          _buildLegendItem("55%+", const Color(0xFF4C7CBD)),
          _buildLegendItem("70%+", const Color(0xFF5D9DFF)),
          const Spacer(),
          const Icon(Icons.location_searching, color: Colors.white38, size: 16),
          const SizedBox(width: 8),
          const Text("Click to drill down", style: TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStateHeatCard(String state, int votes, int turnout, String booths, int riskCount) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF131A2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text("5 districts", style: TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
                child: Text("$turnout%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Turnout", style: TextStyle(color: Colors.white38, fontSize: 12)),
              Text("${votes.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} votes", 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: turnout / 100,
            backgroundColor: Colors.white10,
            color: Colors.blueAccent,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$booths booths online", style: const TextStyle(color: Colors.white38, fontSize: 12)),
              if (riskCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.red.withOpacity(0.2))),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 12),
                      const SizedBox(width: 4),
                      Text("$riskCount risk", style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}