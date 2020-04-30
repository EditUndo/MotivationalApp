import 'package:flutter/material.dart';
import 'package:motivation_app/home_buttons.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildQuote(),
          NewQuoteButton(),
          NewQuoteButton(),
        ],
      ),
    );
  }

  Widget _buildQuote() {
    //add favorite button
    final quoteToWrite = _getRandomQuote();

    bool alreadySaved = _savedQuotes.contains(quoteToWrite);

    return ListTile(
      title: Text(quoteToWrite),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedQuotes.remove(quoteToWrite);
          } else {
            _savedQuotes.add(quoteToWrite);
          }
        });
      },
    );
  }

  String _getRandomQuote() {
    return FileManagement.readRandomFileLine('assets/quotes.txt');
    //return 'Eat Booty';
  }

/*
  void _pushSaved(){
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context){
              final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
                  return ListTile(
                    title: Text(
                      pair.asPascalCase,
                      style:_biggerFont,
                    ),
                  );
                },
              );
              final divided =ListTile.divideTiles(context: context, tiles: tiles,).toList();

              return Scaffold(appBar: AppBar( title: Text('Saved Suggestions'),), body: ListView(children: divided),);
            },        ),);

  }*/
}
