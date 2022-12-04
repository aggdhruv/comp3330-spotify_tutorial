import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spotifytutorial/song.dart';

class SpotifyService {
  Future spotifyAccess() async {
    String clientID = 'ec5b4910ad2a419e8ee9961ac32844c6';
    String clientSecret = 'ce144e2007fe4b69ad5d59db3206e66d';
    String auth_url = 'https://accounts.spotify.com/api/token';

    dynamic response = await http.post(
      Uri.parse(auth_url),
      body: <String, String> {
        'grant_type': 'client_credentials',
        'client_id': clientID,
        'client_secret': clientSecret,
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      dynamic result = json.decode(response.body);
      final token = result['access_token'];
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      print(headers);
      return headers;
    }
    return null;
  }

  Future<Song> fetchSong(String content) async {
    Map<String, String> headers = await spotifyAccess();
    String base_url = 'https://api.spotify.com/v1/';
    String search_url = base_url + 'search?query='+content+"&type=track&limit=1&market=HK";
    dynamic data = await http.get(
      Uri.parse(search_url),
      headers: headers,
    );
    data = json.decode(data.body);
    dynamic song_data = data['tracks']['items'][0];
    // print(song_data);
    Song newSong = Song.fromJSON(song_data);
    return newSong;
  }
}