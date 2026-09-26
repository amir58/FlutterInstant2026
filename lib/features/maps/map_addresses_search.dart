import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MapAddressesSearchScreen extends StatefulWidget {
  const MapAddressesSearchScreen({super.key});

  @override
  State<MapAddressesSearchScreen> createState() =>
      _MapAddressesSearchScreenState();
}

class _MapAddressesSearchScreenState
    extends State<MapAddressesSearchScreen> {
  List places = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) {
                searchPlacesNew(
                  value,
                  'AIzaSyBemMy0BuPhhFEdXy5uLMCD-QCaeTOQBpU',
                );
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];

                  return GestureDetector(
                    onTap: () {
                      debugPrint(place.toString());
                      Navigator.pop(context, place);
                    },
                    child: Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(place['formattedAddress']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> searchPlacesNew(
    String textQuery,
    String apiKey,
  ) async {
    // 1. Define the correct "Places (New)" endpoint
    final Uri url = Uri.parse(
      'https://places.googleapis.com/v1/places:searchText',
    );

    // 2. Set the payload
    final Map<String, dynamic> body = {
      'textQuery': textQuery, // e.g., "Coffee in Seattle"
      'languageCode': context.locale.languageCode,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          // Crucial: You MUST specify the exact fields you want returned.
          'X-Goog-FieldMask':
              'places.id,places.displayName,places.formattedAddress,places.location',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        places = data['places'] ?? [];
        setState(() {});

        // for (var place in places) {
        //   print('Name: ${place['displayName']['text']}');
        //   print('Address: ${place['formattedAddress']}');
        //   print(
        //     'Lat/Lng: ${place['location']['latitude']}, ${place['location']['longitude']}',
        //   );
        // }
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
}
