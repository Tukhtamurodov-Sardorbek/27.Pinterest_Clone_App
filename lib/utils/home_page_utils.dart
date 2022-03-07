import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Widget HomePageSliverAppBar(BuildContext context, bool isScrolled, TabController _tabController){
  const List<Tab> myTabs = [
    Tab(text: 'For you', height: 28),
    Tab(text: 'Today', height: 28),
    Tab(text: 'Following', height: 28),
    Tab(text: 'Health', height: 28),
    Tab(text: 'Recipes', height: 28),
  ];
  return SliverAppBar(
    backgroundColor: Colors.white,
    toolbarHeight: 35,
    expandedHeight: 40,
    collapsedHeight: 40,
    title: const Image(
      image: AssetImage('assets/cash/img_2.png'),
      width: 120,
      alignment: Alignment.bottomCenter,
      // fit: BoxFit.cover,
    ),
    pinned: true,
    floating: true,
    snap: true,
    forceElevated: isScrolled,
    // bottom: TabBar(
    //   tabs: const <Widget>[
    //     Tab(
    //       text: "Home",
    //       icon: Icon(Icons.home),
    //     ),
    //     Tab(
    //       text: "Example page",
    //       icon: Icon(Icons.help),
    //     ),
    //     Tab(
    //       text: "Example page",
    //       icon: Icon(Icons.help),
    //     ),
    //     Tab(
    //       text: "Home",
    //       icon: Icon(Icons.home),
    //     ),
    //     Tab(
    //       text: "Example page",
    //       icon: Icon(Icons.help),
    //     )
    //   ],
    //   controller: _tabController,
    // ),
    centerTitle: true,
    bottom: PreferredSize(
      preferredSize: MediaQuery.of(context).size.shortestSide > 600
          ? Size.fromHeight(
          MediaQuery.of(context).size.shortestSide * 0.045)
          : Size.fromHeight(
          MediaQuery.of(context).size.shortestSide * 0.072),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        unselectedLabelColor: Colors.blueGrey,
        padding: const EdgeInsets.all(0),
        labelPadding: EdgeInsets.symmetric(
            horizontal:
            MediaQuery.of(context).size.shortestSide / 15,
            vertical: 0),
        labelColor: Colors.black,
        indicator: BoxDecoration(
            borderRadius:
            BorderRadius.circular(10), // Creates border
            color: Colors.grey.shade300),
        tabs: myTabs,
      ),
    ),
  );
}

//
// class HomePageBottomSheet extends StatefulWidget {
//   final String url;
//
//   const HomePageBottomSheet({Key? key, required this.url}) : super(key: key);
//
//   @override
//   _HomePageBottomSheetState createState() => _HomePageBottomSheetState();
// }
//
// class _HomePageBottomSheetState extends State<HomePageBottomSheet> {
//   bool isDownload = false;
//   bool _show = false;
//   var snackBar;
//   double progress = 0.0;
//   bool downloadIsPressed = false;
//
//   void _showSnackBar(){
//     snackBar = SnackBar(
//       behavior: SnackBarBehavior.floating,
//       elevation: 0,
//       content: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Container(
//           height: 50,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25.0),
//               color: Colors.grey.shade800
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Text("Image downloaded!", style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.3)),),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10),
//                 child: GestureDetector(
//                     onTap: (){
//                       if (kDebugMode) {
//                         print("Image download");
//                       }
//                     },
//                     child: const Text("Show", style: TextStyle(fontSize: 15, color: Colors.blue),)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   // _save(String url) async {
//   //   var status = await Permission.storage.request();
//   //   if(status.isGranted) {
//   //     var response = await Dio().get(
//   //         url,
//   //         options: Options(
//   //             responseType: ResponseType.bytes,
//   //           followRedirects: false,
//   //           receiveTimeout: 0
//   //         ));
//   //     final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), quality: 100,
//   //         name: DateTime.now().toString());
//   //     if (kDebugMode) {
//   //       print("Hello success => $result");
//   //     }
//   //     setState(() {
//   //
//   //       _show = true;
//   //     });
//   //   }
//   // }
//
//   Future downloadImage() async{
//     const url = 'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4';
//     print('***************************************************************');
//     print('${widget.url}');
//     print('***************************************************************');
//     final request = Request('GET', Uri.parse(url));
//     final response = await Client().send(request);
//     final contentLength = response.contentLength;
//
//     final file = await getFile('file.mp4');
//     final bytes = <int>[];
//     response.stream.listen(
//           (newBytes) {
//         bytes.addAll(newBytes);
//
//         setState(() {
//           progress = bytes.length / contentLength!;
//         });
//       },
//       onDone: () async {
//         setState(() {
//           progress = 1;
//           downloadIsPressed = false;
//         });
//
//         await file.writeAsBytes(bytes);
//       },
//       onError: print,
//       cancelOnError: true,
//     );
//   }
//
//   Future<File> getFile(String filename) async {
//     final directory = await getApplicationDocumentsDirectory();
//
//     return File('${directory.path}/$filename');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.shortestSide > 600 ? MediaQuery.of(context).size.height * 0.41 : MediaQuery.of(context).size.height * 0.5,
//       color: Colors.white,
//       child: Column(
//         children: [
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: (){Navigator.pop(context);},
//               ),
//               const Text('Share to')
//             ],
//           ),
//           SizedBox(
//             height: 80,
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               scrollDirection: Axis.horizontal,
//               children: [
//                 GestureDetector(
//                   child: Column(
//                     children: const [
//                       Expanded(
//                         child: Image(
//                           image: AssetImage('assets/icons/bottom_sheet_icons/img.png'),
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Center(child: Text('Send'))
//                     ],
//                   ),
//                   onTap: (){
//                     if (kDebugMode) {
//                       print('Telegram');
//                     }
//                   },
//                 ),
//                 const SizedBox(width: 20),
//                 GestureDetector(
//                   child: Column(
//                     children: const [
//                       Expanded(
//                         child: Image(
//                           image: AssetImage('assets/icons/bottom_sheet_icons/img_1.png'),
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Center(child: Text('WhatsApp'))
//                     ],
//                   ),
//                   onTap: (){
//                     if (kDebugMode) {
//                       print('WhatsApp');
//                     }
//                   },
//                 ),
//                 const SizedBox(width: 20),
//                 GestureDetector(
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(100),
//                           child: const Image(
//                             image: AssetImage('assets/icons/bottom_sheet_icons/img_6.png'),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Center(child: const Text('Telegram'))
//                     ],
//                   ),
//                   onTap: (){
//                     if (kDebugMode) {
//                       print('WhatsApp');
//                     }
//                   },
//                 ),
//                 const SizedBox(width: 20),
//                 GestureDetector(
//                   child: Column(
//                     children: const [
//                       Expanded(
//                         child: Image(
//                           image: AssetImage('assets/icons/bottom_sheet_icons/img_2.png'),
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Center(child: Text('Messages'))
//                     ],
//                   ),
//                   onTap: (){
//                     if (kDebugMode) {
//                       print('Messages');
//                     }
//                   },
//                 ),
//                 const SizedBox(width: 20),
//                 GestureDetector(
//                   child: Column(
//                     children: const [
//                       Expanded(
//                         child: Image(
//                           image: AssetImage('assets/icons/bottom_sheet_icons/img_3.png'),
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Center(child: Text('Gmail'))
//                     ],
//                   ),
//                   onTap: (){
//                     if (kDebugMode) {
//                       print('Gmail');
//                     }
//                   },
//                 ),
//                 const SizedBox(width: 20),
//                 GestureDetector(
//                   child: Column(
//                     children: const [
//                       Expanded(
//                         child: Image(
//                           image: AssetImage('assets/icons/bottom_sheet_icons/img_4.png'),
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Center(child: Text('Copy link'))
//                     ],
//                   ),
//                   onTap: (){
//                     if (kDebugMode) {
//                       print('Copy link');
//                     }
//                   },
//                 ),
//                 const SizedBox(width: 20),
//                 GestureDetector(
//                   child: Column(
//                     children: const [
//                       Expanded(
//                         child: Image(
//                           image: AssetImage('assets/icons/bottom_sheet_icons/img_5.png'),
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Center(child: Text('More'))
//                     ],
//                   ),
//                   onTap: (){
//                     if (kDebugMode) {
//                       print('More');
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//           const Divider(),
//           ListTile(
//             title: const Text('Download image', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20)),
//             onTap:  (){
//               setState(() {
//                 downloadIsPressed = true;
//               });
//               showDownloadingIndicator.showDownloading(downloadIsPressed);
//             //   Navigator.pop(context);
//             //   _save(index);
//             //   showTopSnackBar(
//             //     context,
//             //     CustomSnackBar.info(
//             //       backgroundColor: Colors.grey.shade800,
//             //       message:
//             //       "Image downloaded!",
//             //       borderRadius: BorderRadius.circular(25.0),
//             //     ),
//             //     additionalTopPadding: 30,
//             //     displayDuration: const Duration(milliseconds: 800),
//             //     hideOutAnimationDuration: const Duration(milliseconds: 400),
//             //   );
//               downloadImage();
//             },
//           ),
//           ListTile(
//             title: const Text('Hide Pin'),
//             onTap: (){},
//           ),
//           ListTile(
//             title: const Text('Report Pin'),
//             subtitle: const Text('This goes against Pinterest\'s community guidelines'),
//             onTap: (){},
//           ),
//           const Divider(),
//           const Text('This Pin is inspired by your recent activity', style: TextStyle(color: Colors.grey)),
//         ],
//       ),
//     );
//   }
//
//   // Widget buildProgress(){
//   //   if(progress == 1){
//   //
//   //   }
//   // }
// }