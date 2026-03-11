import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart'; // Required for actual implementation

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header
            const Text(
              "Live Election Analytics",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Deep statistical analysis, voter velocity tracking, and predictive outcome models",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // 2. Performance Summary Grid
            _buildPerformanceSummary(),
            const SizedBox(height: 24),

            // 3. Vote Velocity Over Time (Line Chart Card)
            _buildChartCard("Vote Velocity Over Time", "Real-time voter throughput per minute", 250),
            const SizedBox(height: 24),

            // 4. Candidate Race Tracker (Multi-line Chart Card)
            _buildChartCard("Candidate Race Tracker", "Vote share percentage over time", 250),
            const SizedBox(height: 24),

            // 5. Victory Probability (Horizontal Progress Bars)
            _buildVictoryProbabilityCard(),
            const SizedBox(height: 24),

            // 6. State Turnout vs Previous Election (Grouped Bar Chart)
            _buildChartCard("State Turnout vs Previous Election", "Comparative analysis across key regions", 280),
            const SizedBox(height: 24),

            // 7. Radar and Momentum Row
            Row(
              children: [
                Expanded(child: _buildChartCard("State Health Radar", "Voter density and infrastructure", 300)),
                const SizedBox(width: 24),
                Expanded(child: _buildChartCard("Vote Acceleration", "Change in velocity between hours", 300)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSummary() {
    return Row(
      children: [
        Expanded(child: _buildMetricMiniCard("Current Velocity", "2,978", "votes/min", Icons.bolt, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricMiniCard("Peak Velocity", "6,978", "at 11:30", Icons.speed, Colors.teal)),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricMiniCard("Average Velocity", "4,613", "votes/min", Icons.analytics_outlined, Colors.amber)),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricMiniCard("Projected Winner", "Arvind Sharma", "92.4% probability", Icons.emoji_events_outlined, Colors.indigo)),
      ],
    );
  }

  Widget _buildMetricMiniCard(String title, String val, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10)),
              Text(val, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, String subtitle, double height) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 24),
          Container(
            height: height,
            width: double.infinity,
            color: Colors.white.withOpacity(0.02), // Placeholder for fl_chart widget
            child: const Center(child: Text("Chart Visualization Area", style: TextStyle(color: Colors.white10))),
          ),
        ],
      ),
    );
  }

  Widget _buildVictoryProbabilityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Victory Probability", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const Text("Based on current trends and historical data", style: TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 24),
          _buildProbabilityRow("Arvind Sharma", 0.724, Colors.blue, "Leader"),
          _buildProbabilityRow("Priya Mehta", 0.218, Colors.green, ""),
          _buildProbabilityRow("Rajesh Kumar", 0.046, Colors.orange, ""),
          _buildProbabilityRow("Sunita Desai", 0.012, Colors.pink, ""),
        ],
      ),
    );
  }

  Widget _buildProbabilityRow(String name, double val, Color color, String badge) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 3, backgroundColor: color),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 13)),
              const Spacer(),
              Text("${(val * 100).toStringAsFixed(1)}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              if (badge.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                  child: Text(badge, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ]
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: val,
            backgroundColor: Colors.white.withOpacity(0.05),
            color: color,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}