import 'package:flutter/material.dart';

class MasterDetailLayout extends StatelessWidget {
  final Widget master;
  final Widget detail;

  const MasterDetailLayout({
    super.key,
    required this.master,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 5, child: master),

        Expanded(flex: 4, child: detail),
      ],
    );
  }
}
