import 'package:flutter/material.dart';
import 'package:weather_app/helpers/dio.dart';
import 'package:weather_app/pages/home.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List location = [];

  TextEditingController searchController = TextEditingController();

  void searchLocation(String key) {
    getLocation(key).then((result) {
      setState(() {
        location = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: searchController,
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              filled: true,
              fillColor: Colors.white70,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.text = '';
                },
              ),
              hintText: 'Search'),
          onFieldSubmitted: (value) {
            searchLocation(value);
          },
        ),
      ),
      body: location.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: location.length,
              itemBuilder: (context, i) {
                return SizedBox(
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return HomePage(
                              lat: location[i]['lat'],
                              lon: location[i]['lon'],
                            );
                          },
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.flag),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(location[i]['name']),
                          ),
                        ),
                        const Icon(Icons.star)
                      ],
                    ),
                  ),
                );
              },
            )
          : Container(),
    );
  }
}
