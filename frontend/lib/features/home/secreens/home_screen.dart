import 'package:flutter/material.dart';
import 'package:frontend/features/home/widgets/home_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}


class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: _redirectToGame,
                child: const Text('iniciar partida')
            ),
            const SizedBox(height: 25,),
            ElevatedButton(
                onPressed: _redirectToEdit,
                child: const Text('edição')
            ),
          ],
        ),
      ),
    );
  }

  void _redirectToGame() {}
  
  void _redirectToEdit() {}
}