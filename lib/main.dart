import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new RandomWords(),
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();

  final _biggerFont = const TextStyle(
      fontSize: 18.0,
      fontStyle: FontStyle.italic,
      fontFamily: 'Roboto',
      color: Colors.green);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Startup Name Generator"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestion(),
    );
  }

  Widget _buildSuggestion() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided =
          ListTile.divideTiles(tiles: tiles, context: context).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Saved Suggestions"),
          centerTitle: true,
        ),
        body: new ListView(
          children: divided,
        ),
      );
    }));
  }
}
