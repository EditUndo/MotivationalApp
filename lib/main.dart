import 'dart:math';

import 'package:flutter/material.dart';
import 'file_management.dart';

void main() => runApp(MotivationApp());

class MotivationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivation',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final _savedQuotes = Set<String>();
  String _quoteToWrite = "";
  final _biggerFont = const TextStyle(fontSize: 20.0);
  final _smallerFont = const TextStyle(fontSize: 18.0);
  Color _bgColor = Colors.lightBlue[600];
  Color _buttonColor = Colors.deepOrange[300];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      backgroundColor: _bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildQuote(),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildQuote() {
    //add favorite button
    bool alreadySaved = _savedQuotes.contains(_quoteToWrite);

    return Container(
      height: 200.0,
      child: ListTile(
        title: Text(
          _quoteToWrite,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _savedQuotes.remove(_quoteToWrite);
            } else {
              _savedQuotes.add(_quoteToWrite);
            }
          });
        },
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
      alignment: Alignment.bottomCenter,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.black12)),
        child: Text('Press For Quotes'),
        onPressed: _updateQuote,
        textColor: Colors.black,
        color: _buttonColor,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getRandomQuote().then((String text) {
      setState(() {
        _quoteToWrite = text;
        Random random = Random();
        switch (random.nextInt(4)) {
          case 1: {
            _bgColor = Colors.lightGreen[600]; _buttonColor = Colors.red[300];
          }
          break;

          case 2: {
            _bgColor = Colors.orange[400]; _buttonColor = Colors.blue[300];
          }
          break;

          case 3: {
            _bgColor = Colors.red[400]; _buttonColor = Colors.pink[300];
          }
          break;

          case 0:
          default: {
            _bgColor = Colors.lightBlue[600]; _buttonColor = Colors.deepOrange[300];
          }
          break;

        }
      });
    });
  }

  void _updateQuote() {
    _getRandomQuote().then((String text) {
      setState(() {
        _quoteToWrite = text;
        Random random = Random();
        switch (random.nextInt(4)) {
          case 1: {
            _bgColor = Colors.lightGreen[600]; _buttonColor = Colors.red[300];
          }
          break;

          case 2: {
            _bgColor = Colors.orange[400]; _buttonColor = Colors.blue[300];
          }
          break;

          case 3: {
            _bgColor = Colors.red[400]; _buttonColor = Colors.pink[300];
          }
          break;

          case 0:
          default: {
            _bgColor = Colors.lightBlue[600]; _buttonColor = Colors.deepOrange[300];
          }
          break;

        }
      });
    });
  }

  Future<String> _getRandomQuote() {
    return FileManagement.readRandomFileLine('assets/data/quotes.txt');
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedQuotes.map(
            (String quote) {
              return ListTile(
                title: Text(
                  quote,
                  style: _smallerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Quotes'),
            ),
            backgroundColor: _bgColor,
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}
