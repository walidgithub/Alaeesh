import 'package:flutter/material.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Directionality(
          textDirection: TextDirection.rtl, child: bodyContent(context)),
    ));
  }

  Widget bodyContent(BuildContext context) {
    return Column(
      children: [

      ],
    );
  }
}
