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
  final _smallerFont = const TextStyle(fontSize: 18.0, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation'),
      ),
      backgroundColor: Colors.blueGrey[600],
      body: Container(
        alignment: Alignment.topCenter,
        child: _buildQuote(),
      ),
      floatingActionButton: _buildButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Settings'),
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
            ),
            ListTile(
              title: Text('Notification Settings'),
            ),
            ListTile(
              title: Text('Saved Quotes'),
              onTap: _pushSaved,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuote() {
    //add favorite button
    bool alreadySaved = _savedQuotes.contains(_quoteToWrite);

    return Center(
      child: Container(
        height: 200.0,
        color: Colors.transparent,
        padding: EdgeInsets.all(10.0),
        child: new Container(
          decoration: new BoxDecoration(
              color: Colors.grey[400],
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey[800],
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 1.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal, move right 10
                    10.0, // vertical, move down 10
                  ),
                )
              ],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueGrey[100],
                  Colors.blueGrey[400],
                ], // whitish to gray
                tileMode:
                    TileMode.clamp, // repeats the gradient over the canvas
              ),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
              )),
          child: ListTile(
            title: new Center(
              child: new Text(
                _quoteToWrite,
                style: _biggerFont,
              ),
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
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      padding: EdgeInsets.only(bottom: 50.0),
      alignment: Alignment.bottomCenter,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.black12)),
        child: Text('Press For Quotes'),
        onPressed: _updateQuote,
        textColor: Colors.black,
        color: Colors.grey[400],
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

  Widget _buildSavedItem(BuildContext context, int index) {
    return Center(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(10.0),
        child: new Container(
          decoration: new BoxDecoration(
              color: Colors.grey[400],
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey[800],
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 1.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal, move right 10
                    10.0, // vertical, move down 10
                  ),
                )
              ],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueGrey[100],
                  Colors.blueGrey[400],
                ], // whitish to gray
                tileMode:
                    TileMode.clamp, // repeats the gradient over the canvas
              ),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
              )),
          child: ListTile(
            title: new Center(
              child: new Text(
                _savedQuotes.elementAt(index),
                style: _biggerFont,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Quotes'),
            ),
            backgroundColor: Colors.blueGrey[600],
            body: ListView.separated(
              itemCount: _savedQuotes.length,
              itemBuilder: (BuildContext context, int index) => _buildSavedItem(context, index),
              separatorBuilder: (context, index) => Divider(
                //color: Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
