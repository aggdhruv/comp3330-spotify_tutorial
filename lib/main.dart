import 'package:flutter/material.dart';
import 'package:spotifytutorial/spotifyservice.dart';
import 'package:spotifytutorial/song.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify API Tutorial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Spotify API Tutorial'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey= GlobalKey<FormState>();
  String songSearch = '';
  dynamic track;

  SpotifyService spotify = SpotifyService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form (
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter a track name",
                    style: TextStyle(fontSize: 24,),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        validator: (val) =>  val!.isEmpty ? 'Search for track' : null,
                        onChanged: (val) {
                          setState(() => songSearch = val);
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Track Search",
                            contentPadding: EdgeInsets.symmetric(horizontal: 10)
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        track = await spotify.fetchSong(songSearch);
                        // print(track.link);
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TrackDisplay(track: track)),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        padding: const EdgeInsets.all(15),

                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Center(child: Text("Search")),
                      ),
                    ),
                  ),
                ]
              )
            )
          )
        )
      )
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TrackDisplay extends StatelessWidget {
  final Song track;
  TrackDisplay({required this.track});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Display'),
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea (
        child: Center(
          child: SingleChildScrollView(
            child: InkWell(
                onTap: () async {
                  if( await canLaunchUrl(Uri.parse(track.link))) {
                    await launchUrl(
                      Uri.parse(track.link),
                    );
                  }
                },
              child: Column (
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    track.image_url,
                    height: 150,
                    width: 150,
                  ),
                  SizedBox(height: 20),
                  Text(
                    track.name,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                      track.artist,
                      style: TextStyle(fontSize: 15),
                  )
                ]
              )
            )
          )
        )
      )

    );
  }
}

