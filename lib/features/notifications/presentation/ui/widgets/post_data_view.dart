import 'package:flutter/material.dart';

import '../../../../../core/router/arguments.dart';

class PostDataView extends StatefulWidget {
  PostDataArguments arguments;
  PostDataView({super.key, required this.arguments});

  @override
  State<PostDataView> createState() => _PostDataViewState();
}

class _PostDataViewState extends State<PostDataView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
