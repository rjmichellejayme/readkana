import 'package:flutter/material.dart';
import '../models/book.dart';

const lightBeige = Color(0xFFFFF7E7);
const lightPink = Color(0xFFF4A0BA);
const cardBorderColor = Colors.white;

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final bool isGrid;
  final int indexInRow;

  const BookCard({
    Key? key,
    required this.book,
    required this.onTap,
    this.isGrid = true,
    required this.indexInRow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isGrid ? _buildGridCard(context) : _buildListCard(context),
    );
  }

  Widget _buildPlaceholderContent(BuildContext context, bool useBeigeLogo) {
    return Container(
      decoration: BoxDecoration(
        color: useBeigeLogo ? lightBeige : lightPink,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 60),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            useBeigeLogo
                ? 'assets/images/logo-pink.jpg'
                : 'assets/images/logo-beige.jpg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context) {
    final useBeigeLogo = indexInRow % 2 == 0;

    return Card(
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: cardBorderColor, width: 2.0),

      ),
      child: book.coverImage != null && book.coverImage!.isNotEmpty
          ? Image.asset(
              book.coverImage!,
              fit: BoxFit.cover,
            )
          : _buildPlaceholderContent(context, useBeigeLogo),
    );
  }

  Widget _buildListCard(BuildContext context) {
    final useBeigeLogo = 0 % 2 == 0; // Adjust logic if needed for list

    return Card(
      elevation: 2,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 120,
            child: book.coverImage != null && book.coverImage!.isNotEmpty
                ? Image.asset(
                    book.coverImage!,
                    fit: BoxFit.cover,
                  )
                : _buildPlaceholderContent(context, useBeigeLogo),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(), // Empty space for the text part
            ),
          ),
        ],
      ),
    );
  }
}