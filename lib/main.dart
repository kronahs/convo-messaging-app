import 'package:chat_app/screens/ProfilePage.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/auth/signup_screen.dart';
import 'package:chat_app/screens/homepage.dart';
import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/notification/notification_service.dart';
import 'package:chat_app/services/themeProvider.dart';
import 'package:chat_app/services/user/user_service.dart';
import 'package:chat_app/themes/AppTheme.dart';
import 'package:chat_app/themes/colorTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options:  FirebaseOptions(
        apiKey: "AIzaSyCCeBDLxqrzYgAhErMhZmQufMbNAyZGefo",
        appId: "1:156814059452:web:fb7b00a8454e3e21f8adb9",
        messagingSenderId: "156814059452",
        projectId: "convo-chat-de3fa",
        storageBucket: "convo-chat-de3fa.appspot.com",
      ),
    );
  } else {
    print('sdas');
    await Firebase.initializeApp();
  }

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
        ChangeNotifierProvider(create: (context) => ThemeProvider())
      ],
      child: Consumer<ThemeProvider>(

        builder: (BuildContext context, ThemeProvider themeProvider, Widget? child) {
          var themeMode;

          if (themeProvider.themeMode == ThemeModeOptions.System) {
            themeMode = ThemeMode.system;
          } else if (themeProvider.themeMode == ThemeModeOptions.Light) {
            themeMode = ThemeMode.light;
          } else {
            themeMode = ThemeMode.dark;
          }

          return MaterialApp(
              debugShowCheckedModeBanner: false,
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
              themeMode: themeMode,
              home: AuthGate()
          );
        },

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
