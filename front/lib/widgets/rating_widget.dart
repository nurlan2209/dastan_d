import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final int rating;
  final Function(int)? onRatingChanged;

  RatingWidget({required this.rating, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: onRatingChanged != null
              ? () => onRatingChanged!(index + 1)
              : null,
        );
      }),
    );
  }
}
