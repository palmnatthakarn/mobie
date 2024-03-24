import 'package:flutter/material.dart';
import 'package:flutter_application_2/search/book_seacrh.dart';
import 'detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyBookApp());
}

class MyBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Book App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<dynamic> books = [];
  List<dynamic> filteredBooks = [];
  bool isLoading = false;
  String errorMessage = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  void filterBooks(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredBooks = books.where((book) {
          String title = book['volumeInfo']['title'].toString().toLowerCase();
          return title.contains(query.toLowerCase());
        }).toList();
      } else {
        filteredBooks = List.from(books);
      }
    });
  }

  Future<void> fetchBooks() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
          Uri.parse('https://www.googleapis.com/books/v1/volumes?q=flutter'));
      if (response.statusCode == 200) {
        setState(() {
          books = json.decode(response.body)['items'];
          filteredBooks = List.from(books);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load books';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void navigateToBookDetails(dynamic book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailScreen(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => BookSearchScreen(books: books),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => navigateToBookDetails(filteredBooks[index]),
                      child: Card(
                        elevation: 3,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: filteredBooks[index]['volumeInfo']
                                            ['imageLinks'] !=
                                        null
                                    ? NetworkImage(
                                        filteredBooks[index]['volumeInfo']
                                            ['imageLinks']['thumbnail'],
                                      )
                                    : AssetImage(
                                            'assets/images/default_book_cover.png')
                                        as ImageProvider,
                              ),
                            ),
                          ),
                          title: Text(
                            filteredBooks[index]['volumeInfo']['title'] ??
                                'No Title',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text(
                            filteredBooks[index]['volumeInfo']['authors'] !=
                                    null
                                ? filteredBooks[index]['volumeInfo']['authors']
                                    .join(', ')
                                : 'Unknown Author',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
