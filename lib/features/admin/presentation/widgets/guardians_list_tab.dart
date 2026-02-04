import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guardian_app/features/admin/data/models/admin_guardian_model.dart';
import 'package:guardian_app/providers/admin_guardians_provider.dart';
import 'package:guardian_app/features/admin/presentation/screens/add_edit_guardian_screen.dart';
import 'package:guardian_app/features/admin/presentation/screens/guardian_details_screen.dart';
import 'package:guardian_app/widgets/custom_dropdown_menu.dart';

class GuardiansListTab extends StatefulWidget {
  const GuardiansListTab({super.key});

  @override
  State<GuardiansListTab> createState() => _GuardiansListTabState();
}

class _GuardiansListTabState extends State<GuardiansListTab> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  
  // State
  String _sortOption = 'date_desc'; // date_desc, date_asc, name_asc, name_desc
  String _selectedStatus = 'all'; // Replaces TabController index

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData(refresh: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<AdminGuardiansProvider>(context, listen: false);
      if (!provider.isLoading && provider.hasMore) {
        _fetchData(refresh: false);
      }
    }
  }

  void _fetchData({bool refresh = false}) {
    Provider.of<AdminGuardiansProvider>(context, listen: false)
        .fetchGuardians(refresh: refresh, status: _selectedStatus, search: _searchController.text);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      Provider.of<AdminGuardiansProvider>(context, listen: false)
          .setSearchQuery(query);
      _fetchData(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _navigateToEdit(AdminGuardian? guardian) async {
     final result = await Navigator.push(
       context,
       MaterialPageRoute(builder: (_) => AddEditGuardianScreen(guardian: guardian)),
     );
     
     if (result == true) {
       _fetchData(refresh: true);
     }
  }

  void _navigateToDetails(AdminGuardian guardian) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GuardianDetailsScreen(guardian: guardian)),
    );
  }

  void _showSortSheet() {
    CustomBottomSheet.show(
      context: context,
      title: 'فرز القائمة',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر طريقة الفرز',
            style: GoogleFonts.tajawal(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 16),
          _buildSortOptionCard('الأحدث إضافة', 'date_desc', Icons.calendar_today),
          _buildSortOptionCard('الأقدم إضافة', 'date_asc', Icons.history),
          _buildSortOptionCard('الاسم (أ-ي)', 'name_asc', Icons.sort_by_alpha),
          _buildSortOptionCard('الاسم (ي-أ)', 'name_desc', Icons.sort_by_alpha),
        ],
      ),
    );
  }

  Widget _buildSortOptionCard(String label, String value, IconData icon) {
    final isSelected = _sortOption == value;
    final primaryColor = const Color(0xFF006400);
    
    return GestureDetector(
      onTap: () {
        setState(() => _sortOption = value);
        Navigator.pop(context);
        _fetchData(refresh: true);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.08) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isSelected ? primaryColor : Colors.grey[600], size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.tajawal(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? primaryColor : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    String tempStatus = _selectedStatus;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF006400).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.filter_list, color: Color(0xFF006400), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'تصفية النتائج',
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حالة العمل',
                      style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFilterOptionRow('الكل', 'all', tempStatus, (val) {
                      setSheetState(() => tempStatus = val);
                    }),
                    _buildFilterOptionRow('على رأس العمل', 'active', tempStatus, (val) {
                      setSheetState(() => tempStatus = val);
                    }),
                    _buildFilterOptionRow('متوقف عن العمل', 'stopped', tempStatus, (val) {
                      setSheetState(() => tempStatus = val);
                    }),
                  ],
                ),
              ),
              // Apply Button
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _selectedStatus = tempStatus);
                      Navigator.pop(context);
                      _fetchData(refresh: true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006400),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'تطبيق التصفية',
                      style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOptionRow(String label, String value, String currentValue, Function(String) onSelect) {
    final isSelected = currentValue == value;
    final primaryColor = const Color(0xFF006400);
    
    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.08) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? primaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.tajawal(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? primaryColor : Colors.black87,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEdit(null),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Top Search & Toolbar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'بحث فوري (الاسم، الرقم...)',
                        hintStyle: TextStyle(fontFamily: 'Tajawal', color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildIconButton(Icons.filter_list, _selectedStatus != 'all' ? Colors.orange : Colors.grey, _showFilterSheet), // Advanced Filter
                const SizedBox(width: 8),
                _buildIconButton(Icons.sort, Colors.blue, _showSortSheet), // Sort
              ],
            ),
          ),

          // Removed TabBar Container

          // List Content
          Expanded(
            child: Consumer<AdminGuardiansProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.guardians.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.guardians.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  controller: _scrollController, // Added Controller
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.guardians.length + (provider.hasMore ? 1 : 0),
                  separatorBuilder: (c, i) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == provider.guardians.length) {
                      return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
                    }
                    return _buildGuardianCard(provider.guardians[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 45, minHeight: 45),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'لا يوجد أمناء مطابقين للبحث',
            style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildGuardianCard(AdminGuardian guardian) {
    bool isActive = guardian.employmentStatus == 'على رأس العمل';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Cleaner white background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Top Section: Avatar, Name, Status Chart
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 50, // Chart size
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2), 
                          width: 3
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: guardian.photoUrl != null ? NetworkImage(guardian.photoUrl!) : null,
                      child: guardian.photoUrl == null ? Icon(Icons.person, color: Colors.grey[400]) : null,
                    ),
                    Positioned(
                       right: 0, 
                       bottom: 0,
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         decoration: BoxDecoration(color: isActive ? Colors.green : Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                       )
                    )
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(guardian.shortName, style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        // Removed '#م' prefix as requested
                        child: Text(guardian.serialNumber, style: const TextStyle(fontFamily: 'Tajawal', color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

                // Smart Circles
                _buildSmartCircle(
                    title: 'الهوية', 
                    color: guardian.identityStatusColor,
                    remainingDays: guardian.identityRemainingDays
                ),
                const SizedBox(width: 8),
                _buildSmartCircle(
                    title: 'الترخيص', 
                    color: guardian.licenseStatusColor,
                    remainingDays: guardian.licenseRemainingDays
                ),
                const SizedBox(width: 8),
                _buildSmartCircle(
                    title: 'البطاقة', 
                    color: guardian.cardStatusColor,
                    remainingDays: guardian.cardRemainingDays
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, indent: 16, endIndent: 16),
          
          // Bottom Section: Details Grid & Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildInfoRow('حالة العمل', guardian.employmentStatus ?? '-', isActive ? Colors.green : Colors.red),
                const SizedBox(height: 6),
                _buildInfoRow('رقم الترخيص', guardian.licenseNumber ?? '-', Colors.black87),
                const SizedBox(height: 6),
                 _buildInfoRow('تاريخ الترخيص', guardian.licenseExpiryDate ?? '-', Colors.black54),
                 const SizedBox(height: 6),
                 _buildInfoRow('البطاقة الشخصية', guardian.expiryDate ?? '-', Colors.black54),
                
                const SizedBox(height: 12),
                Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                      // Edit Button
                      InkWell(
                        onTap: () => _navigateToEdit(guardian),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                             color: Colors.blue.withValues(alpha: 0.05),
                             borderRadius: BorderRadius.circular(6)
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.edit, size: 14, color: Colors.blue),
                              SizedBox(width: 4),
                              Text('تعديل', style: TextStyle(fontFamily: 'Tajawal', color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // View Button
                      InkWell(
                        onTap: () => _navigateToDetails(guardian),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                             color: Colors.green.withValues(alpha: 0.05),
                             borderRadius: BorderRadius.circular(6)
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.visibility, size: 14, color: Colors.green),
                              SizedBox(width: 4),
                              Text('عرض', style: TextStyle(fontFamily: 'Tajawal', color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                   ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
     return Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Text(label, style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey[600], fontSize: 12)),
         Text(value, style: TextStyle(fontFamily: 'Tajawal', color: valueColor, fontSize: 12, fontWeight: FontWeight.bold)),
       ],
     );
  }

  Widget _buildSmartCircle({required String title, required Color color, int? remainingDays}) {
     return Column(
       children: [
         Container(
           width: 36,
           height: 36,
           alignment: Alignment.center,
           decoration: BoxDecoration(
             shape: BoxShape.circle,
             color: color.withValues(alpha: 0.1),
             border: Border.all(color: color, width: 2),
           ),
           child: remainingDays != null
               ? Text(
                   '$remainingDays',
                   style: TextStyle(
                     color: color, 
                     fontWeight: FontWeight.bold, 
                     fontSize: remainingDays.abs() > 99 ? 10 : 12,
                     fontFamily: 'Tajawal'
                   ),
                 )
               : Icon(
                   color == Colors.green ? Icons.check : (color == Colors.orange ? Icons.priority_high : Icons.close),
                   color: color,
                   size: 20,
                 ),
         ),
         const SizedBox(height: 4),
         Text(title, style: const TextStyle(fontSize: 10, fontFamily: 'Tajawal', color: Colors.grey)),
       ],
     );
  }
}
