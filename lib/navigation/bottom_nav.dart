import 'package:flutter/material.dart';
import 'package:livestock_prototype/pages/scanning_page1.dart';
import 'package:livestock_prototype/pages/scanning_page1fail.dart';
import 'package:livestock_prototype/pages_connect/connection_page.dart';
import 'package:livestock_prototype/pages/scanning_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages => [
    HomePageContent(onTabSelected: _onItemTapped),
    ConnectionPageContent(),
    ScanningPage1(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          // Back button - only show on Connect (index 1) and Scan (index 2) tabs
          if (_selectedIndex != 0)
            Positioned(
              top: 50, // Adjust position as needed
              left: 25,
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0; // Go back to Home
                      });
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          // home
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          // connect
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Connect',
          ),

          // scan
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Scan'),
        ],
      ),
    );
  }
}

// Custom widget for HomePage content without bottom navigation
class HomePageContent extends StatelessWidget {
  final Function(int)? onTabSelected;
  const HomePageContent({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1ACF68),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Hello, Kanor!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Monday, 1 September 2025",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose An Animal",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Select the type of animal you want to scan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),

          // Pig / Baboy
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () {
                onTabSelected?.call(1);
              },
              borderRadius: BorderRadius.circular(20),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 170,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        // ICON
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Color(0xFFE9F5E9),
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Center(
                            child: Text('🐖', style: TextStyle(fontSize: 35)),
                          ),
                        ),

                        // Space between icon and text
                        SizedBox(width: 15),

                        // ==== PIG / BABOY ====
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Pig / Baboy",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Swine Scanning",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 80),

                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Icon(Icons.keyboard_arrow_right),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Cow / Baka
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () {
                onTabSelected?.call(1);
              },
              borderRadius: BorderRadius.circular(20),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 170,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        // ICON
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Color(0xFFE9F5E9),
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Center(
                            child: Text('🐄', style: TextStyle(fontSize: 35)),
                          ),
                        ),

                        // Space between icon and text
                        SizedBox(width: 15),

                        // ==== COW / BAKA ====
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Cow / Baka",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Cattle Scanning",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 80),

                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Icon(Icons.keyboard_arrow_right),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for ConnectionPage content without MaterialApp
class ConnectionPageContent extends StatelessWidget {
  const ConnectionPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectionPage();
  }
}

// Custom widget for ScanningPage content without MaterialApp
class ScanningPageContent extends StatelessWidget {
  const ScanningPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ScanningPage();
  }
}
