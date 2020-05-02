import 'package:flutter/material.dart';
import 'file_management.dart';

void main() => runApp(MotivationApp());

class MotivationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivation',
      theme: ThemeData(
        primaryColor: Colors.green,
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
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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

    return ListTile(
      title: Text(_quoteToWrite),
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
    );
  }

  Widget _buildButton() {
    return Container(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.black12)),
        child: Text('Press For Quotes'),
        onPressed: _updateQuote,
        textColor: Colors.white,
        color: Colors.blueGrey,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getRandomQuote().then((String text) {
      setState(() {
        _quoteToWrite = text;
      });
    });
  }

  void _updateQuote() {
    _getRandomQuote().then((String text) {
      setState(() {
        _quoteToWrite = text;
      });
    });
  }

  Future<String> _getRandomQuote() {
    return FileManagement.readRandomFileLine('assets/data/quotes.txt');
  }


  void _pushSaved() {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context){
              final Iterable<ListTile> tiles = _savedQuotes.map(
                (String quote) {
                  return ListTile(
                    title: Text(
                      quote,
                      style:_biggerFont,
                    ),
                  );
                },
              );
              final divided =ListTile.divideTiles(context: context, tiles: tiles,).toList();

              return Scaffold(appBar: AppBar( title: Text('Saved Quotes'),), body: ListView(children: divided),);
            },        ),);

  }
}
