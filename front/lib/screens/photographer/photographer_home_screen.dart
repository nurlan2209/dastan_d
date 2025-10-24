import 'package:flutter/material.dart';
import 'my_orders_screen.dart';

class PhotographerHomeScreen extends StatelessWidget {
  const PhotographerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Сразу показываем экран заказов без навигации
    return const PhotographerOrdersScreen();
  }
}
