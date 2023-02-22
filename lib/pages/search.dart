import 'package:flutter/material.dart';
import 'package:weather_app/helpers/dio.dart';
import 'package:weather_app/pages/home.dart';
import 'package:geolocator/geolocator.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    final messenger = ScaffoldMessenger.of(context);

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        messenger.showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      messenger.showSnackBar(const SnackBar(
          content:
              Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return HomePage(
              lat: position.latitude,
              lon: position.longitude,
            );
          },
        ),
      );
      // setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  List countries = [];
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
  void initState() {
    super.initState();
    getCountries().then((result) {
      setState(() {
        countries = result;
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
        body: Column(
          children: [
            // Text('LAT: ${_currentPosition?.latitude ?? ""}'),
            // Text('LNG: ${_currentPosition?.longitude ?? ""}'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const Divider(),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    onPressed: _getCurrentPosition,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Icons.my_location),
                        ),
                        Expanded(
                          child: Text(
                            "Find my location",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
            location.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: location.length,
                      itemBuilder: (context, i) {
                        return SizedBox(
                          height: 45,
                          child: TextButton(
                            style: TextButton.styleFrom(foregroundColor: Colors.black),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pushReplacement(
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
                                Image.network(
                                  "https://openweathermap.org/images/flags/${location[i]['country'].toLowerCase()}.png",
                                  width: 30,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      "${location[i]['name']}, ${countries.firstWhere((e) => e['alpha2Code'] == location[i]['country'])['name']}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.star_outline)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ));
  }
}
