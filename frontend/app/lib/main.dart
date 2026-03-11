import 'package:flutter/material.dart';
import 'package:app/themes/app_theme.dart';

// Import your 11 screen files
import 'package:app/screens/dashboard_page.dart';
import 'package:app/screens/booth_monitoring_page.dart';
import 'package:app/screens/alerts_page.dart';
import 'package:app/screens/ledger_page.dart';
import 'package:app/screens/booth_activity_page.dart';
import 'package:app/screens/voter_lookup_page.dart';
import 'package:app/screens/analytics_page.dart';
import 'package:app/screens/evm_audit_page.dart';
import 'package:app/screens/reports_page.dart';
import 'package:app/screens/public_portal_page.dart';
import 'package:app/screens/heatmap_page.dart';

void main() {
  runApp(const VotifyApp());
}

class VotifyApp extends StatelessWidget {
  const VotifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Votify: Election Monitor',
      // Using darkTheme to maintain the navy/black aesthetic
      theme: AppTheme.darkTheme, 
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController handles the index switching for all 11 pages
    return DefaultTabController(
      length: 11,
      child: Scaffold(
        backgroundColor: const Color(0xFF0C101B), // Votify primary dark background
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B101B),
          elevation: 0,
          centerTitle: false,
          title: const Row(
            children: [
              Icon(Icons.shield_outlined, color: Colors.blueAccent, size: 24),
              SizedBox(width: 10),
              Text(
                "Votify", 
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white70),
              onPressed: () {}, // Future implementation for Voter Lookup search
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white70),
              onPressed: () {}, // Future implementation for Alert Center updates
            ),
            const SizedBox(width: 8),
          ],
          // Scrollable TabBar replaces the Sidebar for mobile
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.blueAccent,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white38,
            labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Dashboard", icon: Icon(Icons.grid_view_outlined, size: 20)),
              Tab(text: "Booths", icon: Icon(Icons.location_on_outlined, size: 20)),
              Tab(text: "Alerts", icon: Icon(Icons.warning_amber_rounded, size: 20)),
              Tab(text: "Ledger", icon: Icon(Icons.book_outlined, size: 20)),
              Tab(text: "Activity", icon: Icon(Icons.sensors_outlined, size: 20)),
              Tab(text: "Voters", icon: Icon(Icons.person_search_outlined, size: 20)),
              Tab(text: "Analytics", icon: Icon(Icons.analytics_outlined, size: 20)),
              Tab(text: "EVM Audit", icon: Icon(Icons.memory_outlined, size: 20)),
              Tab(text: "Reports", icon: Icon(Icons.description_outlined, size: 20)),
              Tab(text: "Portal", icon: Icon(Icons.public_outlined, size: 20)),
              Tab(text: "Heatmap", icon: Icon(Icons.map_outlined, size: 20)),
            ],
          ),
        ),
        // TabBarView renders the selected page based on the TabBar index
        body: const TabBarView(
          // Indexed exactly as the Tabs above
          children: [
            DashboardPage(),           // 0
            BoothMonitoringPage(),     // 1
            AlertCenterPage(),         // 2
            LedgerPage(),              // 3
            VoterActivityPage(),       // 4
            VoterLookupPage(),         // 5
            AnalyticsPage(),           // 6
            EVMAuditPage(),            // 7
            ElectionReportsPage(),     // 8
            PublicPortalPage(),        // 9
            ElectionHeatmapPage(),     // 10
          ],
        ),
      ),
    );
  }
}