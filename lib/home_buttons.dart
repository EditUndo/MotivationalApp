import 'package:flutter/material.dart';

class NewQuoteButton extends StatelessWidget {
  
  NewQuoteButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.black12)),
        child: Text('Press For Quotes'),
        onPressed: null,
        textColor: Colors.white,
        color: Colors.blueGrey,
      ),
    );
  }
}
