import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gromore_example/widgets/feed_view.dart';

class FeedDemo extends StatefulWidget {
  const FeedDemo({Key? key}) : super(key: key);

  @override
  State<FeedDemo> createState() => _FeedDemoState();
}

class _FeedDemoState extends State<FeedDemo> {
  List<String> viewIds = [];

  @override
  void initState() {
    super.initState();
  }

  handleBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) => Material(
              child: SafeArea(
                top: false,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                          child: Text('确认'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      ElevatedButton(
                          child: Text('取消'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("feed_demo"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index % 4 == 0) {
                return const FeedView();
              }

              return Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffcccccc), width: 1)),
                alignment: Alignment.center,
                height: 200,
                child: Text(index.toString()),
              );
            },
          )),
          GestureDetector(
            onTap: handleBottomSheet,
            child: Container(
              color: Colors.blue,
              height: 50,
              child: const Center(
                child: Text("唤起bottomSheet"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
