import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/providers.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);

    final currentIndex = uiProvider.selectedMenuOpt;

    return BottomNavigationBar(

      onTap: (value) => uiProvider.selectedMenuOpt = value,

      currentIndex: currentIndex,
      
      elevation:0 ,

      items: const <BottomNavigationBarItem> [
      BottomNavigationBarItem(
        icon: Icon(Icons.map), 
        label: 'Mapa',
        
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.compass_calibration), 
        label: 'Direcciones'
      ),
    ]);
  }
}