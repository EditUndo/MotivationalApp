class Quote {

  String _quote;
  String _author;
  int _id;
  int _saved;

  Quote(this._quote, this._author, this._saved, [this._id]);

  String get quote => _quote;
  String get author => _author;
  int get saved => _saved;
  int get id => _id;

  set quote(String newQuote) {
    if (newQuote.length <= 255) {
      this._quote = newQuote;
    }
  }

  set author(String newAuthor) {
    if (newAuthor.length <= 255) {
      this._author = newAuthor;
    }
  }

  set saved(int isSaved) {
    this._saved = isSaved;
  }

  // Convert a Quote object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		map['quote'] = _quote;
		map['author'] = _author;
    map['saved'] = _saved;

		return map;
	}

	// Extract a Quote object from a Map object
	Quote.fromMapObject(Map<String, dynamic> map) {
		this._quote = map['quote'];
		this._author = map['author'];
    this._saved = map['saved'];
    this._id = map['id'];
	}

}