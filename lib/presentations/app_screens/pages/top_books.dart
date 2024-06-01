import 'package:flutter/material.dart';

class TopBooksPage extends StatefulWidget {
  const TopBooksPage({super.key});

  @override
  State<TopBooksPage> createState() => _TopBooksPageState();
}

class _TopBooksPageState extends State<TopBooksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const Center(
        child: Text('Top books page'),
      ),
    );
  }
}
