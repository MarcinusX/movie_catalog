class Movie {
  final String title;
  final String posterPath;
  final String overview;
  final String releaseDate;
  final int id;
  final String originalTitle;
  final String backdropPath;
  final double popularity;
  final int voteCount;
  final bool video;
  final double voteAverage;

  Movie.fromJson(Map<String, dynamic> json)
      : this.title = json['title'],
        this.posterPath = json['poster_path'],
        this.overview = json['overview'],
        this.releaseDate = json['release_date'],
        this.id = json['id'],
        this.originalTitle = json['original_title'],
        this.backdropPath = json['backdrop_path'],
        this.popularity = json['popularity'],
        this.voteCount = json['vote_count'],
        this.video = json['video'],
        this.voteAverage = json['vote_average'].toDouble();
}

class MovieDetails {
  final String title;
  final String posterPath;
  final String overview;
  final String releaseDate;
  final int id;
  final String originalTitle;
  final String backdropPath;
  final double popularity;
  final int voteCount;
  final bool video;
  final double voteAverage;
  final List<String> genres;
  final List<CastMember> castMembers;
  final List<Review> reviews;

  MovieDetails.fromJson(Map<String, dynamic> json)
      : this.title = json['title'],
        this.posterPath = json['poster_path'],
        this.overview = json['overview'],
        this.releaseDate = json['release_date'],
        this.id = json['id'],
        this.originalTitle = json['original_title'],
        this.backdropPath = json['backdrop_path'],
        this.popularity = json['popularity'],
        this.voteCount = json['vote_count'],
        this.video = json['video'],
        this.voteAverage = json['vote_average']?.toDouble(),
        this.genres = (json['genres'] as List)
            .map<String>((genre) => genre['name'])
            .toList(),
        this.castMembers = (json['credits']['cast'] as List)
            .map<CastMember>(
                (jsonCastMember) => CastMember.fromJson(jsonCastMember))
            .toList(),
        this.reviews = (json['reviews']['results'] as List)
            .map<Review>((rev) => Review.fromJson(rev))
            .toList();
}

class Review {
  final String id;
  final String author;
  final String content;
  final String url;

  Review.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.author = json['author'],
        this.content = json['content'],
        this.url = json['url'];
}

class CastMember {
  final String name;
  final String profilePath;

  CastMember.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.profilePath = json['profile_path'];
}
