import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_application_2/detail_page.dart';

class BookSearchScreen extends StatefulWidget {
  final List<dynamic> books;

  BookSearchScreen({required this.books});

  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  List<dynamic> filteredBooks = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredBooks = List.from(widget.books);
  }

  void filterBooks(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredBooks = widget.books.where((book) {
          String title = book['volumeInfo']['title'].toString().toLowerCase();
          return title.contains(query.toLowerCase());
        }).toList();
      } else {
        filteredBooks = List.from(widget.books);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterBooks(value);
              },
              decoration: InputDecoration(
                hintText: 'Search books...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
               return OpenContainer(
                  transitionType: ContainerTransitionType.fade,
                  transitionDuration: Duration(milliseconds: 1000), // ตั้งค่าความหน่วงในการแสดงการเปลี่ยนแปลง
                  closedElevation: 0, // ไม่มี elevation เมื่อปิด
                  closedBuilder: (context, openContainer) {
                    return ListTile(
                      title: Text(filteredBooks[index]['volumeInfo']['title'] ?? 'No Title'),
                      onTap: openContainer,
                    );
                  },
                  openBuilder: (context, _) {
                    return BookDetailScreen(book: filteredBooks[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> books;

  BookSearchDelegate({required this.books});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<dynamic> suggestionList = query.isEmpty
        ? []
        : books.where((book) {
            String title = book['volumeInfo']['title'].toString().toLowerCase();
            return title.contains(query.toLowerCase());
          }).toList();

    if (suggestionList.isEmpty) {
      return Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index]['volumeInfo']['title'] ?? 'No Title'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BookDetailScreen(book: suggestionList[index]),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> suggestionList = query.isEmpty
        ? books
        : books.where((book) {
            String title = book['volumeInfo']['title'].toString().toLowerCase();
            return title.contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index]['volumeInfo']['title'] ?? 'No Title'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BookDetailScreen(book: suggestionList[index]),
            ),
          );
        },
      ),
    );
  }
}
