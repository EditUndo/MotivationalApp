class Quote {

  String _quote;
  String _author;
  String _cloudId;

  Quote(this._quote, this._author, this._cloudId);

  String get quote => _quote;
  String get author => _author;
  String get cloudId => _cloudId;

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

  set cloudId(String newID) {
    if (newID.length <= 255) {
      this._cloudId = newID;
    }
  }

  // Convert a Quote object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		map['quote'] = _quote;
		map['author'] = _author;
    map['cloud_id'] = _cloudId;

		return map;
	}

	// Extract a Quote object from a Map object
	Quote.fromMapObject(Map<String, dynamic> map) {
		this._quote = map['quote'];
		this._author = map['author'];
    this._cloudId = map['cloud_id'];
	}

}