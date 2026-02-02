import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:guardian_app/core/config/app_config.dart';
import 'package:guardian_app/core/constants/api_constants.dart';
import 'package:guardian_app/providers/auth_provider.dart';
import 'package:guardian_app/providers/dashboard_provider.dart';
import 'package:guardian_app/providers/record_book_provider.dart';
import 'package:guardian_app/providers/registry_entry_provider.dart';
import 'package:guardian_app/features/auth/data/repositories/auth_repository.dart';
import 'package:guardian_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:guardian_app/features/records/data/repositories/records_repository.dart';
import 'package:guardian_app/features/registry/data/repositories/registry_repository.dart';
import 'package:guardian_app/screens/login_screen.dart';
import 'package:guardian_app/features/admin/data/repositories/admin_dashboard_repository.dart';
import 'package:guardian_app/providers/admin_dashboard_provider.dart';
import 'package:guardian_app/features/admin/data/repositories/admin_guardian_repository.dart';
import 'package:guardian_app/providers/admin_guardians_provider.dart';

import 'package:guardian_app/providers/admin_renewals_provider.dart';
import 'package:guardian_app/features/admin/data/repositories/admin_areas_repository.dart';
import 'package:guardian_app/providers/admin_areas_provider.dart';
import 'package:guardian_app/features/admin/data/repositories/admin_assignments_repository.dart';
import 'package:guardian_app/providers/admin_assignments_provider.dart';
import 'package:provider/provider.dart';

void mainCommon(AppConfig config) {
  // Initialize API Constants with the environment-specific URL
  ApiConstants.init(config.apiBaseUrl);

  // Create repositories
  final authRepository = AuthRepository();
  final dashboardRepository =
      DashboardRepository(authRepository: authRepository);
  final recordsRepository = RecordsRepository(authRepository: authRepository);
  final registryRepository = RegistryRepository(authRepository: authRepository);
  final adminDashboardRepository = AdminDashboardRepository(authRepository);

  runApp(MyApp(
    config: config,
    authRepository: authRepository,
    dashboardRepository: dashboardRepository,
    recordsRepository: recordsRepository,
    registryRepository: registryRepository,
    adminDashboardRepository: adminDashboardRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AppConfig config;
  final AuthRepository authRepository;
  final DashboardRepository dashboardRepository;
  final RecordsRepository recordsRepository;
  final RegistryRepository registryRepository;
  final AdminDashboardRepository adminDashboardRepository;

  const MyApp({
    super.key,
    required this.config,
    required this.authRepository,
    required this.dashboardRepository,
    required this.recordsRepository,
    required this.registryRepository,
    required this.adminDashboardRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppConfig>.value(value: config),
        Provider<AuthRepository>.value(value: authRepository),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(dashboardRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => RecordBookProvider(recordsRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => RegistryEntryProvider(registryRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminDashboardProvider(adminDashboardRepository),
        ),
        Provider<AdminGuardianRepository>(
          create: (_) => AdminGuardianRepository(authRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => AdminGuardiansProvider(
            Provider.of<AdminGuardianRepository>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AdminRenewalsProvider(
            Provider.of<AdminGuardianRepository>(context, listen: false),
          ),
        ),

        Provider<AdminAreasRepository>(
          create: (_) => AdminAreasRepository(baseUrl: config.apiBaseUrl),
        ),
        ChangeNotifierProvider(
          create: (context) => AdminAreasProvider(
            Provider.of<AdminAreasRepository>(context, listen: false),
          ),
        ),
        Provider<AdminAssignmentsRepository>(
          create: (_) => AdminAssignmentsRepository(baseUrl: config.apiBaseUrl),
        ),
        ChangeNotifierProvider(
          create: (context) => AdminAssignmentsProvider(
            Provider.of<AdminAssignmentsRepository>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        title: config.appName, // Use dynamic App Name
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'SA'),
        ],
        locale: const Locale('ar', 'SA'),
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Tajawal',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF006400),
            primary: const Color(0xFF006400),
            secondary: const Color(0xFF004d00),
            surface: Colors.white,
            error: const Color(0xFFBA1A1A),
          ),
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF006400),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(fontFamily: 'Tajawal', fontSize: 20, fontWeight: FontWeight.bold),
          ),

          // cardTheme: CardTheme(
          //   elevation: 2,
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //   color: Colors.white,
          //   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          // ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF006400), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            labelStyle: TextStyle(color: Colors.grey.shade700, fontFamily: 'Tajawal'),
            hintStyle: TextStyle(color: Colors.grey.shade400, fontFamily: 'Tajawal'),
            prefixIconColor: Colors.grey.shade600,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006400),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              textStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'Tajawal', fontSize: 24, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontFamily: 'Tajawal', fontSize: 20, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.w600),
            bodyLarge: TextStyle(fontFamily: 'Tajawal', fontSize: 16),
            bodyMedium: TextStyle(fontFamily: 'Tajawal', fontSize: 14),
            labelLarge: TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold),
          ).apply(fontFamily: 'Tajawal', bodyColor: Colors.black87, displayColor: Colors.black87),
        ),
        // Add a Banner for Dev Mode
        builder: (context, child) {
          child = Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );

          if (config.isDev) {
            return Banner(
              message: 'تجريـــب',
              location: BannerLocation.topStart,
              color: Colors.red,
              child: child,
            );
          }
          return child;
        },
        home: const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
