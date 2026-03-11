import 'package:flutter/material.dart';

class AlertCenterPage extends StatelessWidget {
  const AlertCenterPage({super.key});

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
              "Alert Center",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Monitor and manage all system alerts and AI-detected anomalies",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // 2. Alert KPI Row
            _buildAlertKPIs(),
            const SizedBox(height: 32),

            // 3. Filter Row
            _buildFilterRow(),
            const SizedBox(height: 24),

            // 4. Detailed Alerts List
            _buildDetailedAlertList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertKPIs() {
    return Row(
      children: [
        Expanded(child: _buildSimpleKPI("ACTIVE ALERTS", "8", "10 total", Colors.amber, Icons.warning_amber_rounded)),
        const SizedBox(width: 16),
        Expanded(child: _buildSimpleKPI("CRITICAL", "2", "Require action", Colors.redAccent, Icons.error_outline)),
        const SizedBox(width: 16),
        Expanded(child: _buildSimpleKPI("AI FLAGGED", "4", "High confidence", Colors.blueAccent, Icons.psychology_outlined)),
      ],
    );
  }

  Widget _buildSimpleKPI(String title, String value, String sub, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131A2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1.1)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 28),
          )
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildFilterChip("All Severity"),
            const SizedBox(width: 12),
            _buildFilterChip("All Types"),
          ],
        ),
        const Text("10 alerts", style: TextStyle(color: Colors.white38)),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white70)),
          const Icon(Icons.arrow_drop_down, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _buildDetailedAlertList() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        DetailedAlertCard(
          title: "Ledger Tampering Suspected",
          desc: "Multiple consecutive hash chain breaks detected. Forensic audit initiated.",
          meta: "BTH-0034 / Chennai South / Integrity / AI: 96.7%",
          time: "15:25",
          severity: "Critical",
        ),
        DetailedAlertCard(
          title: "Unusual Vote Spike Detected",
          desc: "AI detected 340% vote increase in 15-min window. Pattern consistent with ballot stuffing.",
          meta: "BTH-0007 / Pune / AI Fraud Detection / AI: 94.2%",
          time: "15:22",
          severity: "Critical",
        ),
        DetailedAlertCard(
          title: "Duplicate Voter ID Attempt",
          desc: "Multiple voting attempts detected using same ID within 10-minute window.",
          meta: "BTH-0055 / Noida / AI Fraud Detection / AI: 91.8%",
          time: "15:15",
          severity: "High",
        ),
      ],
    );
  }
}

class DetailedAlertCard extends StatelessWidget {
  final String title, desc, meta, time, severity;
  const DetailedAlertCard({required this.title, required this.desc, required this.meta, required this.time, required this.severity, super.key});

  @override
  Widget build(BuildContext context) {
    Color sevColor = severity == "Critical" ? Colors.redAccent : (severity == "High" ? Colors.orangeAccent : Colors.amber);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131A2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: sevColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.security_rounded, color: sevColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: sevColor, borderRadius: BorderRadius.circular(12)),
                      child: Text(severity, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(meta, style: const TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.w500)),
                    Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}