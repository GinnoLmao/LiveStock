import 'package:flutter/material.dart';
// import 'package:livestock/pages/scanning_page.dart';

// void main() => runApp(const HomePage());

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180), // Increased from 130 to 180
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
                    // When you have a profile image, use this instead:
                    // backgroundImage: AssetImage('assets/profile_pic.jpg'),
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
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 20,
            ), // CHANGE PADDING IF NEEDED
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

          SizedBox(height: 35),

          // Cow / Baka
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          // home
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          // connect
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Connect',
          ), // Change logo to bluetooth
          // scan
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Scan'),
        ],
      ),
    );
  }
}
