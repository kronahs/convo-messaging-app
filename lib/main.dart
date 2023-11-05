import 'package:chat_app/screens/ProfilePage.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/auth/signup_screen.dart';
import 'package:chat_app/screens/homepage.dart';
import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/notification/notification_service.dart';
import 'package:chat_app/services/user/user_service.dart';
import 'package:chat_app/themes/AppTheme.dart';
import 'package:chat_app/themes/colorTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initNotifications();
  FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {

    if (FirebaseAuth.instance.currentUser != null) {
      // User is authenticated, update active status
      try {
        if (state == AppLifecycleState.resumed) {
          // App is in the foreground
          await UserServiceProvider().updateActiveStatus(true);
        } else {
          // App is in the background or terminated
          await UserServiceProvider().updateActiveStatus(false);
        }
      } catch (e) {
        // Handle any errors that occur during the status update process
        print('Error updating active status: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    const appTheme = AppTheme();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthServiceProvider()),
        ChangeNotifierProvider(create: (context) => UserServiceProvider()),
      ],
      child: MaterialApp(
        title: 'Convo',
        darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Color(0xff025464),
          brightness: Brightness.dark,
          fontFamily: GoogleFonts.poppins().fontFamily,
          textTheme: TextTheme(
            titleMedium:  GoogleFonts.poppins(
              textStyle: TextStyle(fontWeight: FontWeight.w500),
            ),
            titleLarge:  GoogleFonts.poppins(
              textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white),
            ),
          ),
        ),
        theme: ThemeData(
          colorSchemeSeed: Color(0xff025464),
          useMaterial3: true,
          fontFamily: GoogleFonts.poppins().fontFamily,
          textTheme: TextTheme(
            titleMedium:  GoogleFonts.poppins(
              textStyle: TextStyle(fontWeight: FontWeight.w500),
            ),
            titleLarge:  GoogleFonts.poppins(
              textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white),
            ),
            bodySmall:  GoogleFonts.poppins(
              textStyle: TextStyle( color: Theme.of(context).colorScheme.secondary),
            ),
          ), //colorScheme: lightThemeColors(context)
        ),
        themeMode: ThemeMode.system,
        home: AuthGate()
      ),
    );
  }
}


class BottomNavigation extends StatefulWidget {
  final int? selectedTabIndex;

  BottomNavigation({super.key,  this.selectedTabIndex});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
      index: _selectedTabIndex,
      children: [
        HomePage(),
        ProfilePage(),
      ],
    ),
      bottomNavigationBar: NavigationBar(
        // backgroundColor:
        onDestinationSelected: (int index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        selectedIndex: _selectedTabIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home_filled),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon:  Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
