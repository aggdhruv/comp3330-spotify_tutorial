class Song {
  String name;
  String artist;
  String image_url;
  String link;

  Song({ required this.name, required this.artist, required this.image_url, required this.link});

  factory Song.fromJSON(Map<String, dynamic> json) {
    return Song(
      name: json['name'],
      link: json['external_urls']['spotify'],
      artist: json['artists'][0]['name'],
      image_url: json['album']['images'][0]['url'],
    );
  }
}