import 'package:flutter/material.dart';

class EVMAuditPage extends StatelessWidget {
  const EVMAuditPage({super.key});

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
              "EVM Audit Trail",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Hardware diagnostics, seal integrity verification, and real-time EVM health monitoring",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // 2. Hardware Summary KPIs
            _buildHardwareSummary(),
            const SizedBox(height: 32),

            // 3. Search and Status Filters
            _buildFilterRow(),
            const SizedBox(height: 24),

            // 4. EVM Audit Table
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF131A2D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildTableHeader(),
                  const Divider(color: Colors.white10, height: 1),
                  _buildEVMList(),
                  _buildPagination(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHardwareSummary() {
    return Row(
      children: [
        Expanded(child: _buildAuditKPI("OPERATIONAL", "71/75", "95% healthy", Icons.check_circle_outline, Colors.green)),
        const SizedBox(width: 16),
        Expanded(child: _buildAuditKPI("WARNINGS", "1", "Need attention", Icons.warning_amber_rounded, Colors.orange)),
        const SizedBox(width: 16),
        Expanded(child: _buildAuditKPI("FAULTY/REPLACED", "3", "Critical devices", Icons.error_outline, Colors.red)),
        const SizedBox(width: 16),
        Expanded(child: _buildAuditKPI("AVG BATTERY", "69%", "Across all EVMs", Icons.battery_charging_full, Colors.blue)),
      ],
    );
  }

  Widget _buildAuditKPI(String title, String val, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF131A2D), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search by EVM ID, serial number, booth...",
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF1C243D),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildSmallFilter("All Status"),
        const SizedBox(width: 12),
        _buildSmallFilter("All States"),
      ],
    );
  }

  Widget _buildSmallFilter(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          Expanded(child: Text("EVM ID", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(child: Text("Serial No.", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(flex: 2, child: Text("Booth", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(child: Text("Model", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(child: Text("Status", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(flex: 2, child: Text("Battery", style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(child: Text("Temp", style: TextStyle(color: Colors.white38, fontSize: 11))),
          SizedBox(width: 60, child: Text("Seal", style: TextStyle(color: Colors.white38, fontSize: 11))),
          SizedBox(width: 60, child: Text("VVPAT", style: TextStyle(color: Colors.white38, fontSize: 11))),
        ],
      ),
    );
  }

  Widget _buildEVMList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
      itemBuilder: (context, index) {
        bool isFaulty = index == 8; // Match the "EVM-0009" faulty look from image
        return EVMRow(
          id: "EVM-000${index + 1}",
          serial: "SN2938${10 + index}",
          booth: "Mumbai North Booth ${index + 1}",
          model: index % 2 == 0 ? "BEL M3" : "ECIL Mark II",
          status: isFaulty ? "Faulty" : "Operational",
          battery: isFaulty ? 0.16 : (0.45 + (index * 0.05)),
          temp: isFaulty ? "34°C" : "${28 + index}°C",
          isSealOk: !isFaulty,
          isVvpatOk: !isFaulty,
        );
      },
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Page 1 of 7", style: TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(width: 16),
          _buildPageBtn("Previous", false),
          _buildPageNumber("1", true),
          _buildPageNumber("2", false),
          _buildPageNumber("3", false),
          _buildPageBtn("Next", true),
        ],
      ),
    );
  }

  Widget _buildPageBtn(String txt, bool active) => TextButton(onPressed: () {}, child: Text(txt, style: TextStyle(color: active ? Colors.white : Colors.white38)));
  Widget _buildPageNumber(String n, bool active) => Container(margin: const EdgeInsets.symmetric(horizontal: 4), child: CircleAvatar(radius: 14, backgroundColor: active ? Colors.blue : Colors.transparent, child: Text(n, style: const TextStyle(color: Colors.white, fontSize: 12))));
}

class EVMRow extends StatelessWidget {
  final String id, serial, booth, model, status, temp;
  final double battery;
  final bool isSealOk, isVvpatOk;

  const EVMRow({super.key, required this.id, required this.serial, required this.booth, required this.model, required this.status, required this.battery, required this.temp, required this.isSealOk, required this.isVvpatOk});

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == "Operational" ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(child: Text(id, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(child: Text(serial, style: const TextStyle(color: Colors.white38, fontSize: 12))),
          Expanded(flex: 2, child: Text(booth, style: const TextStyle(color: Colors.white, fontSize: 13))),
          Expanded(child: Text(model, style: const TextStyle(color: Colors.white38, fontSize: 12))),
          Expanded(child: _buildStatusPill(status, statusColor)),
          Expanded(flex: 2, child: _buildBatteryIndicator(battery)),
          Expanded(child: Text(temp, style: TextStyle(color: double.parse(temp.split('°')[0]) > 40 ? Colors.red : Colors.white, fontSize: 12))),
          SizedBox(width: 60, child: Icon(isSealOk ? Icons.check_circle_outline : Icons.cancel_outlined, color: isSealOk ? Colors.green : Colors.red, size: 18)),
          SizedBox(width: 60, child: Icon(isVvpatOk ? Icons.check_circle_outline : Icons.cancel_outlined, color: isVvpatOk ? Colors.green : Colors.red, size: 18)),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String txt, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.3))),
      child: Center(child: Text(txt, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold))),
    );
  }

  Widget _buildBatteryIndicator(double val) {
    Color color = val < 0.2 ? Colors.red : (val < 0.5 ? Colors.orange : Colors.blue);
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(value: val, color: color, backgroundColor: Colors.white10, minHeight: 4, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text("${(val * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }
}