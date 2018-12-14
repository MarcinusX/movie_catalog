import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_catalog/models.dart';
import 'package:movie_catalog/reviews_slider.dart';

void main() => runApp(MyApp());

final String authority = 'api.themoviedb.org';
final String discoverPath = '3/discover/movie';
final String key = '42aa0017f58528179d15a0ec047d7a26';
final String imagePath = 'https://image.tmdb.org/t/p/w500';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Movie> movies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          Movie movie = movies[index];
          return MovieListItem(
            movie: movie,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    Uri uri = new Uri.https(authority, discoverPath, {
      'sort_by': 'popularity.desc',
      'api_key': key,
    });
    http.Response res = await http.get(uri);
    List results = json.decode(res.body)['results'];
    print(results);
    setState(() {
      movies = results.map((res) => new Movie.fromJson(res)).toList();
    });
  }
}

class MovieListItem extends StatelessWidget {
  final Movie movie;

  const MovieListItem({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => MovieDetailsPage(movie: movie))),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              "$imagePath${movie.posterPath}",
              width: 120,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movie.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    RateView(
                      rating: movie.voteAverage,
                    ),
                    Text(
                      movie.overview,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RateView extends StatelessWidget {
  final double rating;

  const RateView({Key key, this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(rating.round(), (i) {
      return Icon(
        Icons.star,
        color: Colors.yellow,
        size: 22,
      );
    });
    stars.add(Text("$rating"));
    return Row(
      children: stars,
    );
  }
}

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({Key key, this.movie}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie details"),
      ),
      body: _buildBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
  }

  Widget _buildBody() {
    if (movieDetails == null) {
      return Center(child: CircularProgressIndicator());
    }
    return MovieDetailsBody(details: movieDetails);
  }

  Future<void> _getDetails() async {
    Uri uri = new Uri.https(authority, '3/movie/${widget.movie.id}', {
      'api_key': key,
      'append_to_response': 'credits,reviews',
    });
    http.Response res = await http.get(uri);
    MovieDetails details = MovieDetails.fromJson(json.decode(res.body));
    setState(() {
      movieDetails = details;
    });
  }
}

class MovieDetailsBody extends StatelessWidget {
  final MovieDetails details;

  const MovieDetailsBody({Key key, this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Image.network("$imagePath${details.backdropPath}"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              details.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RateView(
              rating: details.voteAverage,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              details.overview,
            ),
          ),
          Text(
            "Actors:",
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: details.castMembers.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                CastMember actor = details.castMembers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: <Widget>[
                        Image.network("$imagePath${actor.profilePath}"),
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          bottom: 0.0,
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.black, Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Text(
                              actor.name,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            "Reviews:",
            style: Theme.of(context).textTheme.title,
          ),
          ReviewsSlider(details.reviews),
        ],
      ),
    );
  }
}

class ReviewsSliderState extends State<ReviewsSlider> {
  PageController _controller = PageController();
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (t) {
      if (_controller.hasClients) {
        _controller.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.linear);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reviews.isEmpty) {
      return Text("No reviews");
    }
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemBuilder: (context, index) {
          Review review = widget.reviews[index % widget.reviews.length];
          return Text(review.content);
        },
        controller: _controller,
      ),
    );
  }
}
