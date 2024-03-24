import 'package:flutter/material.dart';


class BookDetailScreen extends StatelessWidget {
  final dynamic book;

  BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: book['volumeInfo']['imageLinks'] != null
                        ? NetworkImage(
                            book['volumeInfo']['imageLinks']['thumbnail'],
                          )
                        : AssetImage('assets/images/default_book_cover.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Title: ${book['volumeInfo']['title'] ?? 'No Title'}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 8),
              Text(
                'Authors: ${book['volumeInfo']['authors'] != null ? book['volumeInfo']['authors'].join(', ') : 'Unknown Author'}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${book['volumeInfo']['description'] ?? 'No Description'}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
