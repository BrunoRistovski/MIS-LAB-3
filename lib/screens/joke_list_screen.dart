import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../models/joke_model.dart';
import 'FavoritesScreen.dart';

class JokeListScreen extends StatefulWidget {
  final String type;

  JokeListScreen({required this.type});

  @override
  _JokeListScreenState createState() => _JokeListScreenState();
}

class _JokeListScreenState extends State<JokeListScreen> {
  final List<Joke> _favoriteJokes = [];

  void _toggleFavorite(Joke joke) {
    setState(() {
      joke.isFavorite = !joke.isFavorite;
      if (joke.isFavorite) {
        _favoriteJokes.add(joke);
      } else {
        _favoriteJokes.remove(joke);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes: ${widget.type}'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(favoriteJokes: _favoriteJokes),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Joke>>(
        future: ApiService.getJokesByType(widget.type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No jokes found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final joke = snapshot.data![index];
                return ListTile(
                  title: Text(joke.setup),
                  subtitle: Text(joke.punchline),
                  trailing: IconButton(
                    icon: Icon(
                      joke.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: joke.isFavorite ? Colors.red : null,
                    ),
                    onPressed: () => _toggleFavorite(joke),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
