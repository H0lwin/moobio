import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final ValueChanged<int> onTap;

  const BottomNavBar({super.key, required this.onTap});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.sports_gymnastics), label: 'Train'),
        BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Club'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onTap(index);
      },
    );
  }
}
