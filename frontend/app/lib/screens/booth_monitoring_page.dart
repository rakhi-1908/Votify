import 'package:flutter/material.dart';

class BoothMonitoringPage extends StatelessWidget {
  const BoothMonitoringPage({super.key});

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
              "Booth Monitoring",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Monitor all polling booths across regions in real-time",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // 2. Search and Filter Bar
            _buildFilterBar(),
            const SizedBox(height: 24),

            // 3. The Data Table Container
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF131A2D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildTableHeader(),
                  const Divider(color: Colors.white10, height: 1),
                  _buildBoothList(),
                  _buildPagination(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search booth ID, name, region...",
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF1C243D),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildDropdown("All Status"),
        const SizedBox(width: 16),
        _buildDropdown("All Risk"),
      ],
    );
  }

  Widget _buildDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C243D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(child: Text("Booth ID", style: TextStyle(color: Colors.white38, fontSize: 12))),
          Expanded(flex: 2, child: Text("Name", style: TextStyle(color: Colors.white38, fontSize: 12))),
          Expanded(flex: 2, child: Text("Region", style: TextStyle(color: Colors.white38, fontSize: 12))),
          Expanded(child: Text("Status", style: TextStyle(color: Colors.white38, fontSize: 12))),
          Expanded(child: Text("Votes", style: TextStyle(color: Colors.white38, fontSize: 12))),
          Expanded(child: Text("Risk", style: TextStyle(color: Colors.white38, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildBoothList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Example count
      separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
      itemBuilder: (context, index) {
        return const BoothRow(
          id: "BTH-0001",
          name: "Mumbai North Booth 1",
          region: "Mumbai North",
          state: "Maharashtra",
          status: "Online",
          votes: "1,842",
          risk: "Low Risk",
        );
      },
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: () {}, child: const Text("Previous", style: TextStyle(color: Colors.white54))),
          Row(
            children: [1, 2, 3].map((i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: i == 1 ? Colors.blue : Colors.transparent,
                child: Text("$i", style: TextStyle(color: i == 1 ? Colors.white : Colors.white54)),
              ),
            )).toList(),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Next")),
        ],
      ),
    );
  }
}

class BoothRow extends StatelessWidget {
  final String id, name, region, state, status, votes, risk;
  const BoothRow({required this.id, required this.name, required this.region, required this.state, required this.status, required this.votes, required this.risk, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Expanded(child: Text(id, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(name, style: const TextStyle(color: Colors.white))),
          Expanded(flex: 2, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(region, style: const TextStyle(color: Colors.white)),
              Text(state, style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          )),
          Expanded(child: _buildStatusChip(status)),
          Expanded(child: Text(votes, style: const TextStyle(color: Colors.white))),
          Expanded(child: _buildRiskChip(risk)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = status == "Online" ? Colors.green : (status == "Delayed" ? Colors.orange : Colors.red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: color),
          const SizedBox(width: 4),
          Text(status, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildRiskChip(String risk) {
    Color color = risk == "Low Risk" ? Colors.teal : (risk == "Medium Risk" ? Colors.orange : Colors.red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(risk, style: TextStyle(color: color, fontSize: 11), textAlign: TextAlign.center),
    );
  }
}