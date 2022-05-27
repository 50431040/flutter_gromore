import 'package:flutter/material.dart';
import 'package:flutter_gromore_example/widgets/feed_view.dart';

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
      body: ListView.builder(
        shrinkWrap:true,
        itemBuilder: (context, index) {
          if (index % 5 == 0) {
            return const FeedView();
          }

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffcccccc), width: 1)
            ),
            alignment: Alignment.center,
            height: 200,
            child: Text(index.toString()),
          );
        },
      ),
    );
  }
}
