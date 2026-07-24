import 'package:flutter/material.dart';

class PGYSForm extends StatelessWidget {
  final List<Widget> children;

  const PGYSForm({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
