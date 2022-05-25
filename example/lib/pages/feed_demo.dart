import 'package:flutter/material.dart';
import 'package:flutter_gromore/view/flutter_gromore_feed_view.dart';

class FeedDemo extends StatefulWidget {
  const FeedDemo({Key? key}) : super(key: key);

  @override
  State<FeedDemo> createState() => _FeedDemoState();
}

class _FeedDemoState extends State<FeedDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("feed_demo"),
      ),
      body: const SizedBox(
        height: 100,
        child: FlutterGromoreFeedView(),
      ),
    );
  }
}
