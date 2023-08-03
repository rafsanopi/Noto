import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const NoteCard(
      {super.key,
      required this.title,
      required this.description,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Set a fixed height initially, it will be adjusted later
      child: SizedBox(
        height: 200, // Set an initial height
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Calculate the height based on the content
            // Get the available width
            double availableWidth = constraints.maxWidth;

            // Calculate the height needed for title and description texts
            final titleTextStyle = Theme.of(context).textTheme.titleLarge;
            final descriptionTextStyle = Theme.of(context).textTheme.bodyMedium;
            final titleTextHeight =
                measureTextHeight(title, titleTextStyle!, availableWidth);
            final descriptionTextHeight = measureTextHeight(
                description, descriptionTextStyle!, availableWidth);

            // Calculate the height for the image (if available)
            double imageHeight = imageUrl.isNotEmpty ? 150 : 0;

            // Calculate the total height required for the card
            double totalHeight =
                titleTextHeight + descriptionTextHeight + imageHeight;

            // Adjust the height of the card based on the calculated height
            return SizedBox(
              height: totalHeight,
              child: Column(
                children: [
                  // Your note card content goes here
                  Text(title, style: titleTextStyle),
                  Text(description, style: descriptionTextStyle),
                  if (imageUrl.isNotEmpty)
                    Image.network(imageUrl, height: imageHeight),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to calculate the height of text based on the available width
  double measureTextHeight(String text, TextStyle style, double width) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
        text: textSpan, maxLines: 100, textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: width);
    return textPainter.height;
  }
}
