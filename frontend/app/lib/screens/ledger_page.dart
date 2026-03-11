import 'package:flutter/material.dart';

class LedgerPage extends StatelessWidget {
  const LedgerPage({super.key});

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
              "Tamper-Proof Ledger",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Blockchain-backed immutable record of every vote for total integrity",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // 2. Summary Stats Row
            _buildLedgerStats(),
            const SizedBox(height: 32),

            // 3. Search Bar
            _buildSearchBar(),
            const SizedBox(height: 24),

            // 4. Immutable Blocks List
            _buildBlockList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLedgerStats() {
    return Row(
      children: [
        Expanded(child: _buildMiniStat("TOTAL RECORDS", "40", "In the chain", Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _buildMiniStat("VERIFIED", "38", "95% integrity rate", Colors.green)),
        const SizedBox(width: 16),
        Expanded(child: _buildMiniStat("UNVERIFIED", "2", "Flagged for audit", Colors.red)),
      ],
    );
  }

  Widget _buildMiniStat(String title, String value, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(desc, style: TextStyle(color: color.withOpacity(0.8), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Search by Block ID, Hash, or Booth...",
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: const Icon(Icons.search, color: Colors.white24),
        filled: true,
        fillColor: const Color(0xFF131A2D),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildBlockList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        // Mock data: making one block look "Tampered" for visual variety
        bool isTampered = index == 8; 
        return LedgerBlock(
          blockId: "Block #${532 - index}",
          hash: "a8230b4200c8b201a030c2d...8b0305",
          prevHash: "b120c4200c8b201a030c2d...1a4321",
          data: "BTH-0034 | Vote Recorded",
          status: isTampered ? "Tampered" : "Verified",
          timestamp: "Feb 14, 15:25:01",
        );
      },
    );
  }
}

class LedgerBlock extends StatelessWidget {
  final String blockId, hash, prevHash, data, status, timestamp;
  const LedgerBlock({super.key, required this.blockId, required this.hash, required this.prevHash, required this.data, required this.status, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    bool verified = status == "Verified";
    Color statusColor = verified ? Colors.green : Colors.red;

    return IntrinsicHeight(
      child: Row(
        children: [
          // Vertical Connector Line
          Column(
            children: [
              Container(width: 2, height: 20, color: Colors.white10),
              Icon(Icons.link, size: 16, color: statusColor.withOpacity(0.5)),
              Expanded(child: Container(width: 2, color: Colors.white10)),
            ],
          ),
          const SizedBox(width: 20),
          // Block Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF131A2D),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(blockId, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                      _buildStatusPill(status, statusColor),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildHashRow("HASH", hash),
                  const SizedBox(height: 8),
                  _buildHashRow("PREV", prevHash),
                  const Divider(color: Colors.white10, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      Text(timestamp, style: const TextStyle(color: Colors.white24, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHashRow(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 40, child: Text(label, style: const TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold))),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'monospace'),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusPill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(border: Border.all(color: color.withOpacity(0.5)), borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}