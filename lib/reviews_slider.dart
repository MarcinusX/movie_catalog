import 'package:flutter/material.dart';
import 'package:movie_catalog/models.dart';
import 'main.dart';

class ReviewsSlider extends StatefulWidget {
  final List<Review> reviews;

  const ReviewsSlider(this.reviews, {Key key}) : super(key: key);

  @override
  ReviewsSliderState createState() => ReviewsSliderState();
}
