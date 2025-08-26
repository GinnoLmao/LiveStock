import 'package:flutter/material.dart';

class ConnectDevice extends StatelessWidget {
  const ConnectDevice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xFFBA31E4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "Connect Device",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
