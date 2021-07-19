import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumScreen extends StatelessWidget {

  final String albumName;

  // 接收的參數由建構子接收
  AlbumScreen({required this.albumName});



  @override
  Widget build(BuildContext context) {
    int _count = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(albumName),
        centerTitle: true
        ),
      body: Center(
        return Column (
              mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '目前計數值:',
              ),
              Text('$_count'),
              ElevatedButton(
                child: Text('Return data to index screen.'),
                onPressed: () {
                  Navigator.pop(context, 'Sec Screen');
                },
              ),
            ],
          )
      )
    );
  }
}