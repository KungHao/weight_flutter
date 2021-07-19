import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:weight_flutter/album.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: MyCountChangeNotifier())
        ],
        child: MaterialApp(
          title: 'James Weight APP',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'My Weight'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textFieldController = TextEditingController();
  String _valueText = "";

  _showToast(String _msg) {
    Fluttertoast.showToast(
        msg: _msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        webBgColor: '#a0a0a0',
        webPosition: 'center',
        fontSize: 16.0);
  }

  _showInputDialog() {
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Please Input an Album Name"),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  _valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Input Here"),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop("");
                  });
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop(_valueText);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //透過 Provider.of 來獲取資料
    final counter = Provider.of<MyCountChangeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("目前計數值: ${counter.count}"),
            ElevatedButton(
              child: Text("跳到B頁"),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumScreen(albumName: (counter.count).toString()))
                );
                setState(() {
                  if(result!=null){
                    print(result);
                  }
                });
              },
              // onPressed: () => Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) => BPage()),
              // ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () async {},
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('B頁'),
      ),
      body: Center(
        // 透過 Consumer 來接收更改對應資料
        child: Consumer<MyCountChangeNotifier>(builder: (context, counter, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '目前計數值:',
              ),
              Text(
                '${counter.count}',
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("返回首頁")
                  )
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 使用 Provider.of，並且將 listen 設定為 false(若沒設定，預設為 true)，
          // 則不會再次調用 Widget 重新構建（ build ）畫面 ，更省效能。
          Provider.of<MyCountChangeNotifier>(context, listen: false)
              .increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyCountChangeNotifier with ChangeNotifier {
  // 設定一個整數私有變數 _count的欄位，初值為零
  int _count = 0;

  //可以透過 Consumer 來獲得當下 count 值
  int get count => _count;

  //當點擊右下角＋ 浮動按鈕，會呼叫此方法
  //此方法會將 _count 累加 1，並叫 notifyListeners
  increment() {
    _count++;
    notifyListeners();
  }
}
