import 'package:flutter/material.dart';

class VoterActivityPage extends StatelessWidget {
  const VoterActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header with Restricted Access Badge
            _buildHeader(),
            const SizedBox(height: 32),

            // 2. Activity Summary Cards (2x2 Grid)
            _buildSummaryGrid(),
            const SizedBox(height: 32),

            // 3. Search and Filters
            _buildFilterSection(),
            const SizedBox(height: 24),

            // 4. Activity Log Table
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF131A2D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildTableHeader(),
                  const Divider(color: Colors.white10, height: 1),
                  _buildActivityList(),
                  _buildPagination(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Booth Voter Activity",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        const Text(
          "Secure voter activity log with geolocation verification",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: (0.1 * 255).toDouble()),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.amber.withValues(alpha: (0.3 * 255).toDouble())),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, color: Colors.amber, size: 14),
              SizedBox(width: 8),
              Text("Restricted Access — Authorized Officials Only",
                  style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.5,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard("TOTAL ENTRIES", "119", "Across 8 booths", Icons.people_outline, Colors.blue),
        _buildStatCard("FLAGGED ENTRIES", "13", "10.9% of total", Icons.report_problem_outlined, Colors.red),
        _buildStatCard("OUTSIDE GEOFENCE", "6", "Location violations", Icons.location_off_outlined, Colors.orange),
        _buildStatCard("DUPLICATE ATTEMPTS", "4", "Same voter ID re-entries", Icons.copy_all_outlined, Colors.redAccent),
      ],
    );
  }

  Widget _buildStatCard(String title, String val, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.1)),
                const SizedBox(height: 4),
                Text(val, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: (0.1 * 255).toDouble()), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 24),
          )
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search voter ID, entry ID...",
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF1C243D),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildSmallDropdown("All Booths"),
        const SizedBox(width: 16),
        _buildSmallDropdown("All Entries"),
      ],
    );
  }

  Widget _buildSmallDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFF1C243D), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const Icon(Icons.arrow_drop_down, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(child: Text("Time", style: TextStyle(color: Colors.white38, fontSize: 12))),
          Expanded(child: Text("Voter ID", style: TextStyle(color: Colors.white38, fontSize: 12))),
          Expanded(flex: 2, child: Text("Booth", style: TextStyle(color: Colors.white38, fontSize: 12))),
          Expanded(child: Text("Location", style: TextStyle(color: Colors.white38, fontSize: 12))),
          Expanded(child: Text("Flags", style: TextStyle(color: Colors.white38, fontSize: 12))),
          SizedBox(width: 40, child: Text("Action", style: TextStyle(color: Colors.white38, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
      itemBuilder: (context, index) {
        return const ActivityRow(
          time: "15:30:00",
          voterId: "****4826",
          booth: "BTH-0007 / Pune Booth 1",
          isInside: true,
          isClean: true,
        );
      },
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(onPressed: () {}, child: const Text("Previous", style: TextStyle(color: Colors.white38))),
          const SizedBox(width: 16),
          const CircleAvatar(radius: 14, backgroundColor: Colors.blue, child: Text("1", style: TextStyle(color: Colors.white, fontSize: 12))),
          const SizedBox(width: 8),
          const Text("2  3  4  5", style: TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(width: 16),
          TextButton(onPressed: () {}, child: const Text("Next", style: TextStyle(color: Colors.white38))),
        ],
      ),
    );
  }
}

class ActivityRow extends StatelessWidget {
  final String time, voterId, booth;
  final bool isInside, isClean;

  const ActivityRow({super.key, required this.time, required this.voterId, required this.booth, required this.isInside, required this.isClean});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time, style: const TextStyle(color: Colors.white, fontSize: 13)),
              const Text("15 Feb 2026", style: TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          )),
          Expanded(child: Text(voterId, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(booth, style: const TextStyle(color: Colors.white70, fontSize: 13))),
          Expanded(child: _buildStatusChip(isInside ? "Inside" : "Outside", isInside ? Colors.green : Colors.orange, Icons.location_on)),
          Expanded(child: _buildStatusChip(isClean ? "Clean" : "Flagged", isClean ? Colors.green : Colors.red, Icons.check_circle_outline)),
          const SizedBox(width: 40, child: Icon(Icons.visibility_outlined, color: Colors.white38, size: 20)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: (0.1 * 255).toDouble()),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: (0.2 * 255).toDouble()))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}