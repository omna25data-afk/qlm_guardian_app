import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guardian_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:guardian_app/features/admin/presentation/widgets/admin_dashboard_tab.dart';
import 'package:guardian_app/features/admin/presentation/screens/admin_guardians_management_screen.dart';
import 'package:guardian_app/features/admin/presentation/widgets/records_tab.dart';
import 'package:guardian_app/features/admin/presentation/widgets/reports_tab.dart';
import 'package:guardian_app/features/admin/presentation/widgets/tools_tab.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardTab(),
    const AdminGuardiansManagementScreen(),
    const RecordsTab(),
    const ReportsTab(),
    const ToolsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF006400),
        automaticallyImplyLeading: false, 
        centerTitle: false, // Ensure title stays at start (Right in RTL)
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً، ${user?.name ?? "الرئيس"}',
                style: GoogleFonts.tajawal(
                  textStyle: textTheme.titleLarge?.copyWith( // Increased size
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    height: 1.2
                  )
                ),
              ),
              Text(
                'رئيس قلم التوثيق', // Role subtitle
                style: GoogleFonts.tajawal(
                  textStyle: textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontSize: 12
                  )
                ),
              ),
            ],
          ),
        ),
        actions: [
           IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white, size: 28), // Bigger Icon
            onPressed: () {},
          ),
          // Avatar & Menu
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: PopupMenuButton<String>(
              offset: const Offset(0, 50),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  backgroundImage: user?.avatarUrl != null 
                      ? NetworkImage(user!.avatarUrl!) 
                      : const AssetImage('assets/images/placeholder_avatar.png') as ImageProvider,
                  radius: 20, // Bigger Avatar
                ),
              ),
              onSelected: (value) {
                if (value == 'logout') {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
              itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.grey[700]), 
                        const SizedBox(width: 8), 
                        Text('الملف الشخصي', style: GoogleFonts.tajawal(fontSize: 16))
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings, color: Colors.grey[700]), 
                        const SizedBox(width: 8), 
                        Text('الإعدادات', style: GoogleFonts.tajawal(fontSize: 16))
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'dark_mode',
                    child: Row(
                      children: [
                        Icon(Icons.nightlight_round, color: Colors.grey[700]), 
                        const SizedBox(width: 8), 
                        Text('الوضع الليلي', style: GoogleFonts.tajawal(fontSize: 16))
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        const Icon(Icons.logout, color: Colors.red), 
                        const SizedBox(width: 8), 
                        Text('تسجيل الخروج', style: GoogleFonts.tajawal(color: Colors.red, fontSize: 16))
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea( // Protects against system nav bar
          child: SizedBox(
            height: 70, 
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.dashboard, size: 28), label: 'الرئيسية'),
                BottomNavigationBarItem(icon: Icon(Icons.group, size: 28), label: 'الأمناء'),
                BottomNavigationBarItem(icon: Icon(Icons.source, size: 28), label: 'السجلات'),
                BottomNavigationBarItem(icon: Icon(Icons.analytics, size: 28), label: 'التقارير'),
                BottomNavigationBarItem(icon: Icon(Icons.build, size: 28), label: 'الأدوات'),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xFF006400),
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent, 
              elevation: 0, 
              onTap: _onItemTapped,
              selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 10),
            ),
          ),
        ),
        ),
    );
  }
}
