import 'package:flutter/material.dart';

class VoterLookupPage extends StatelessWidget {
  const VoterLookupPage({super.key});

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
              "Voter Lookup",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Search and view complete voter registration details and voting status",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // 2. Summary KPI Grid (4 Cards)
            _buildVoterSummary(),
            const SizedBox(height: 32),

            // 3. Advanced Filter Bar
            _buildAdvancedFilters(),
            const SizedBox(height: 24),

            // 4. Voter Results Table
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF131A2D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildTableHeader(),
                  const Divider(color: Colors.white10, height: 1),
                  _buildVoterList(),
                  _buildPagination(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoterSummary() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.8,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard("REGISTERED VOTERS", "1,500", "In system", Icons.people_alt_outlined, Colors.blue),
        _buildStatCard("VOTES CAST", "924", "62% turnout", Icons.check_circle_outline, Colors.green),
        _buildStatCard("PENDING VOTERS", "576", "Yet to vote", Icons.access_time, Colors.orange),
        _buildStatCard("BOOTHS COVERED", "75", "Across all states", Icons.location_on_outlined, Colors.indigo),
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
                Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(val, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Icon(icon, color: color.withValues(alpha: (0.8 * 255).toDouble()), size: 28),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search by name, voter ID, EPIC number...",
                  prefixIcon: const Icon(Icons.search, color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF1C243D),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildDropdown("All States"),
            const SizedBox(width: 12),
            _buildDropdown("All Voters"),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildDropdown("All Booths"),
          ],
        )
      ],
    );
  }

  Widget _buildDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFF1C243D), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
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
          SizedBox(width: 30, child: Text("Sr.", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(flex: 2, child: Text("Name", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(flex: 2, child: Text("Voter ID", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(flex: 2, child: Text("State", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(flex: 2, child: Text("Assigned Booth", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(child: Text("Status", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(child: Text("Vote Time", style: TextStyle(color: Colors.white38, fontSize: 11))),
        ],
      ),
    );
  }

  Widget _buildVoterList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
      itemBuilder: (context, index) {
        return const VoterRow(
          srNo: "1",
          name: "Priya Sharma",
          details: "Female, 21 yrs",
          voterId: "MAH9827319",
          state: "Maharashtra",
          region: "Mumbai North",
          boothId: "BTH-0001",
          boothName: "Mumbai North Booth 1",
          time: "15:20",
        );
      },
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: () {}, child: const Text("Previous", style: TextStyle(color: Colors.white38))),
          const Text("Page 1 of 100", style: TextStyle(color: Colors.white38, fontSize: 12)),
          TextButton(onPressed: () {}, child: const Text("Next", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}

class VoterRow extends StatelessWidget {
  final String srNo, name, details, voterId, state, region, boothId, boothName, time;

  const VoterRow({super.key, required this.srNo, required this.name, required this.details, required this.voterId, required this.state, required this.region, required this.boothId, required this.boothName, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text(srNo, style: const TextStyle(color: Colors.white38))),
          Expanded(flex: 2, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(details, style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          )),
          Expanded(flex: 2, child: Text(voterId, style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace'))),
          Expanded(flex: 2, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state, style: const TextStyle(color: Colors.white, fontSize: 12)),
              Text(region, style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          )),
          Expanded(flex: 2, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(boothId, style: const TextStyle(color: Colors.white, fontSize: 12)),
              Text(boothName, style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          )),
          Expanded(child: _buildVotedChip()),
          Expanded(child: Text(time, style: const TextStyle(color: Colors.white70, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildVotedChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: (0.1 * 255).toDouble()),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: (0.3 * 255).toDouble())),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 10, color: Colors.green),
          SizedBox(width: 4),
          Text("Voted", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}