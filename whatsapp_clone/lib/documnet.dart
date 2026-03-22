// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MusicListScreen extends StatefulWidget {
//   @override
//   _MusicListScreenState createState() => _MusicListScreenState();
// }

// class _MusicListScreenState extends State<MusicListScreen> {
//   final OnAudioQuery _audioQuery = OnAudioQuery();

//   @override
//   void initState() {
//     super.initState();
//     requestPermission();
//   }

//   // স্টোরেজ পারমিশন চাওয়ার ফাংশন
//   void requestPermission() async {
//     if (Platform.isAndroid) {
//       // অ্যান্ড্রয়েড ১৩ (SDK 33) বা তার উপরের জন্য
//       if (await Permission.audio.request().isGranted) {
//         setState(() {});
//       }
//       // অ্যান্ড্রয়েড ১২ বা তার নিচের জন্য
//       else if (await Permission.storage.request().isGranted) {
//         setState(() {});
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<SongModel>>(
//         future: _audioQuery.querySongs(
//           sortType: null,
//           orderType: OrderType.ASC_OR_SMALLER,
//           uriType: UriType.EXTERNAL,
//           ignoreCase: true,
//         ),
//         builder: (context, item) {
//           if (item.data == null)
//             return const Center(child: CircularProgressIndicator());
//           if (item.data!.isEmpty)
//             return const Center(child: Text("কোনো গান পাওয়া যায়নি"));

//           return ListView.builder(
//             itemCount: item.data!.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(item.data![index].displayNameWOExt),
//                 subtitle: Text("${item.data![index].artist}"),
//                 leading: QueryArtworkWidget(
//                   id: item.data![index].id,
//                   type: ArtworkType.AUDIO,
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
