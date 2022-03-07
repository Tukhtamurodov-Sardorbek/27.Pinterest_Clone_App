import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pinterest/pages/detail_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinterest/services/http_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pinterest/models/pinterest_models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Post extends StatefulWidget {
  int pageIndex;
  int tabIndex;
  String search;

  Post({Key? key, required this.pageIndex, this.tabIndex = 0, this.search = ''})
      : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  List<Pinterest> postsList = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  final Dio dio = Dio();
  int page = 1;
  bool downloadIsPressed = false;
  double progress = 0.0;

  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "ff" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return Colors.grey;
  }

  void _bottomSheet(BuildContext context, String url) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (context) => widget.pageIndex == 0
          ? _bottomSheetView(url)
          : const SizedBox(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh();
  }

  Future refresh() async {
    if (kDebugMode) {
      print(
          '**** REFRESHING **** PAGE: ${widget.pageIndex}   TAB: ${widget.tabIndex}   page: $page');
    }
    List<Pinterest> list = widget.pageIndex == 0 && widget.tabIndex == 0
        // ?  await Network.GET(Network.API_LIST, Network.paramsGET())
        ? await Network.GET(Network.API_SEARCH_LIST,
            Network.paramsSearch(page: page, topic: 'All'))
        : widget.pageIndex == 0 && widget.tabIndex == 1
            ? await Network.GET(Network.API_LIST,
                Network.paramsGET(page: page, sortBy: 'latest'))
            : widget.pageIndex == 0 && widget.tabIndex == 2
                ? await Network.GET(
                    Network.API_LIST, Network.paramsGET(page: page))
                : widget.pageIndex == 0 && widget.tabIndex == 3
                    ? await Network.GET(Network.API_SEARCH_LIST,
                        Network.paramsSearch(page: page, topic: 'health'))
                    : widget.pageIndex == 0 && widget.tabIndex == 4
                        ? await Network.GET(Network.API_SEARCH_LIST,
                            Network.paramsSearch(page: page, topic: 'recipes'))
                        : widget.pageIndex == 1
                            ? await Network.GET(
                                Network.API_SEARCH_LIST,
                                Network.paramsSearch(
                                    page: page, topic: widget.search))
                            : [];
    if (mounted) {
      setState(() {
        page += 1;
        postsList = list;
        _refreshController.refreshCompleted();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            child: MasonryGridView.count(
              padding: const EdgeInsets.all(0),
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: postsList.length,
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              itemBuilder: (context, index) {
                return _gridView(index);
              },
            ),
          ),
          downloadIsPressed
              ? Center(
                child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 20),
                  height: 100,
                  width: 100,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              valueColor: const AlwaysStoppedAnimation(Colors.green),
                              strokeWidth: 10,
                              backgroundColor: Colors.white,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: progress == 1
                                        ? const Icon(
                                      Icons.done,
                                      color: CupertinoColors.systemGreen,
                                      size: 40
                                    )
                                        : Center(child: Lottie.asset(
                                      'assets/lottie/loading_animation.json',
                                      fit: BoxFit.cover,
                                        )),
                                  ),
                                  Text(
                                      '${(progress * 100).toStringAsFixed(1)}%',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18
                                      )
                                  ),
                                  const SizedBox(height: 10)
                                ]
                              ),
                            )
                          ],
                        ),
                      ),
                  )
              : const SizedBox(),

          //       Visibility(
          //         visible: ,
          //         child:
          //
          //
          // // Container(
          // // // color: Colors.transparent,
          // // alignment: Alignment.topCenter,
          // // margin: const EdgeInsets.only(top: 20),
          // // child: SizedBox(
          // // height: 150,
          // // width: 150,
          // // child: Stack(
          // // fit: StackFit.expand,
          // // children: [
          // // CircularProgressIndicator(
          // // value: progress,
          // // valueColor: const AlwaysStoppedAnimation(Colors.green),
          // // strokeWidth: 10,
          // // backgroundColor: Colors.white,
          // // ),
          // // // Center(
          // // //   child: buildProgress(),
          // // // )
          // // ],
          // // ),
          // // ),
          // // ),
          //       ),
        ],
      ),
      header: const ClassicHeader(),
      onRefresh: refresh,
      onLoading: () async {
        if (kDebugMode) {
          print('**** LOADING ****');
        }
        page += 1;
        List<Pinterest> list = widget.pageIndex == 0 && widget.tabIndex == 0
            ? await Network.GET(Network.API_SEARCH_LIST,
                Network.paramsSearch(page: page, topic: 'All'))
            : widget.pageIndex == 0 && widget.tabIndex == 1
                ? await Network.GET(Network.API_LIST,
                    Network.paramsGET(page: page, sortBy: 'latest'))
                : widget.pageIndex == 0 && widget.tabIndex == 2
                    ? await Network.GET(
                        Network.API_LIST, Network.paramsGET(page: page))
                    : widget.pageIndex == 0 && widget.tabIndex == 3
                        ? await Network.GET(Network.API_SEARCH_LIST,
                            Network.paramsSearch(page: page, topic: 'health'))
                        : widget.pageIndex == 0 && widget.tabIndex == 4
                            ? await Network.GET(
                                Network.API_SEARCH_LIST,
                                Network.paramsSearch(
                                    page: page, topic: 'recipes'))
                            : widget.pageIndex == 1
                                ? await Network.GET(
                                    Network.API_SEARCH_LIST,
                                    Network.paramsSearch(
                                        page: page, topic: widget.search))
                                : [];

        postsList.addAll(list);
        if (mounted) {
          setState(() {
            _refreshController.loadComplete();
          });
        }
      },
    );
  }

  Widget _gridView(int index) {
    return GestureDetector(
      child: Card(
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: postsList[index].urls.regular,
                    placeholder: (context, url) =>
                        // const Image(image: AssetImage('assets/cash/img.png')),
                        AspectRatio(
                            aspectRatio: postsList[index].width /
                                postsList[index].height,
                            child: Container(
                              color: getColorFromHex(postsList[index].color),
                            )),
                    errorWidget: (context, url, error) =>
                        const Image(image: AssetImage('assets/cash/img_1.png')),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: postsList[index].user.profileImage.small,
                        placeholder: (context, url) => const Image(
                            image: AssetImage('assets/cash/img.png')),
                        errorWidget: (context, url, error) => const Image(
                            image: AssetImage('assets/cash/img_1.png')),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Text(postsList[index].user.username,
                          overflow: TextOverflow.ellipsis)),
                  IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        _bottomSheet(context, postsList[index].urls.regular);
                      }),
                ],
              )
            ],
          )),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext contex) => PostView(
                post: postsList[index],
                search: widget.pageIndex == 0 && widget.tabIndex == 0
                    ? 'All'
                    : widget.pageIndex == 0 && widget.tabIndex == 3
                        ? 'health'
                        : widget.pageIndex == 0 && widget.tabIndex == 4
                            ? 'recipes'
                            : widget.pageIndex == 1
                                ? widget.search
                                : '')));
      },
      onLongPress: () {},
    );
  }

  Widget _bottomSheetView(String url){

    // Future<File> getFile(String filename) async {
    //   final directory = await getApplicationDocumentsDirectory();
    //   if (kDebugMode) {
    //     print('###############');
    //     print(directory);
    //     print('###############');
    //   }
    //   return File('${directory.path}/$filename');
    // }
    // Future downloadImage() async{
    //   const url = 'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4';
    //   // if (kDebugMode) {
    //   //   print('***************************************************************');
    //   //   print(url);
    //   //   print('***************************************************************');
    //   // }
    //   final request = Request('GET', Uri.parse(url));
    //   final response = await Client().send(request);
    //   final contentLength = response.contentLength;
    //
    //   final file = await getFile('file.mp4');
    //   final bytes = <int>[];
    //   response.stream.listen(
    //         (newBytes) {
    //       bytes.addAll(newBytes);
    //
    //       setState(() {
    //         progress = bytes.length / contentLength!;
    //       });
    //     },
    //     onDone: () async {
    //       setState(() {
    //         progress = 1.0;
    //       });
    //       Timer(const Duration(milliseconds: 1500),(){
    //         setState(() {
    //           downloadIsPressed = false;
    //           progress = 0.0;
    //         });
    //       });
    //
    //       await file.writeAsBytes(bytes);
    //     },
    //     onError: print,
    //     cancelOnError: true,
    //   );
    // }

    Future<bool> _requestPermission(Permission permission) async{
      if(await permission.isGranted){
        return true;
      } else{
        var result = await permission.request();
        if(result == PermissionStatus.granted){
          return true;
        } else{
          return false;
        }
      }
    }

    Future<bool> saveFile(String url, String name) async{
      Directory? directory;
      try{
        if(Platform.isAndroid){
          if(await _requestPermission(Permission.storage)){
            directory = await getExternalStorageDirectory();
            if (kDebugMode) {
              print(directory?.path);
            }
            // to create our own folder in /storage/emulated/0/
            String newPath = '';
            List<String>? folders = directory?.path.split('/');
            for(int i = 1; i < folders!.length; i++){
              if(folders[i] != 'Android'){
                newPath += '/${folders[i]}';
              } else {
                break;
              }
            }
            newPath += '/Download';
            directory = Directory(newPath);
            if (kDebugMode) {
              print(directory.path);
            }
          }else{
            return false;
          }
        }else if(Platform.isIOS){
          if(await _requestPermission(Permission.photos)){
            directory = await getTemporaryDirectory();
          } else {
            return false;
          }
        }
        if(directory != null && !await directory.exists()){
          await directory.create(recursive: true);
        }
        if(directory != null && await directory.exists()){
          File saveFile = File(directory.path + '/$name');
          await dio.download(url, saveFile.path, onReceiveProgress: (downloaded, totalSize){
            setState(() {
              progress = downloaded / totalSize;
            });
          });
          if(Platform.isIOS){
            await ImageGallerySaver.saveFile(saveFile.path, isReturnPathOfIOS: true);
          }
          return true;
        }
      } catch(e){
        print(e);
      }
      return false;
    }

    downloadImage() async{
      // setState(() {
      //   isLoading = true;
      // });

      bool isDownloaded = await saveFile(url, 'img_${DateTime.now()}.jpg');
      if(isDownloaded){
        print('The image is downloaded!');
        setState(() {
          progress = 1.0;
        });
        Timer(const Duration(milliseconds: 1500),(){
          setState(() {
            downloadIsPressed = false;
            progress = 0.0;
          });
        });
      } else {
        print('The image is not downloaded!');
      }

      // setState(() {
      //   isLoading = true;
      // });
    }


    return Container(
      height: MediaQuery.of(context).size.shortestSide > 600 ? MediaQuery.of(context).size.height * 0.41 : MediaQuery.of(context).size.height * 0.5,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: (){Navigator.pop(context);},
              ),
              const Text('Share to')
            ],
          ),
          SizedBox(
            height: 80,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  child: Column(
                    children: const [
                      Expanded(
                        child: Image(
                          image: AssetImage('assets/icons/bottom_sheet_icons/img.png'),
                        ),
                      ),
                      SizedBox(height: 6),
                      Center(child: Text('Send'))
                    ],
                  ),
                  onTap: (){
                    if (kDebugMode) {
                      print('Telegram');
                    }
                  },
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  child: Column(
                    children: const [
                      Expanded(
                        child: Image(
                          image: AssetImage('assets/icons/bottom_sheet_icons/img_1.png'),
                        ),
                      ),
                      SizedBox(height: 6),
                      Center(child: Text('WhatsApp'))
                    ],
                  ),
                  onTap: (){
                    if (kDebugMode) {
                      print('WhatsApp');
                    }
                  },
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const Image(
                            image: AssetImage('assets/icons/bottom_sheet_icons/img_6.png'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(child: const Text('Telegram'))
                    ],
                  ),
                  onTap: (){
                    if (kDebugMode) {
                      print('WhatsApp');
                    }
                  },
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  child: Column(
                    children: const [
                      Expanded(
                        child: Image(
                          image: AssetImage('assets/icons/bottom_sheet_icons/img_2.png'),
                        ),
                      ),
                      SizedBox(height: 6),
                      Center(child: Text('Messages'))
                    ],
                  ),
                  onTap: (){
                    if (kDebugMode) {
                      print('Messages');
                    }
                  },
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  child: Column(
                    children: const [
                      Expanded(
                        child: Image(
                          image: AssetImage('assets/icons/bottom_sheet_icons/img_3.png'),
                        ),
                      ),
                      SizedBox(height: 6),
                      Center(child: Text('Gmail'))
                    ],
                  ),
                  onTap: (){
                    if (kDebugMode) {
                      print('Gmail');
                    }
                  },
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  child: Column(
                    children: const [
                      Expanded(
                        child: Image(
                          image: AssetImage('assets/icons/bottom_sheet_icons/img_4.png'),
                        ),
                      ),
                      SizedBox(height: 6),
                      Center(child: Text('Copy link'))
                    ],
                  ),
                  onTap: (){
                    if (kDebugMode) {
                      print('Copy link');
                    }
                  },
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  child: Column(
                    children: const [
                      Expanded(
                        child: Image(
                          image: AssetImage('assets/icons/bottom_sheet_icons/img_5.png'),
                        ),
                      ),
                      SizedBox(height: 6),
                      Center(child: Text('More'))
                    ],
                  ),
                  onTap: (){
                    if (kDebugMode) {
                      print('More');
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Download image', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20)),
            onTap:  (){
              setState(() {
                downloadIsPressed = true;
              });

              //   Navigator.pop(context);
              //   _save(index);
              //   showTopSnackBar(
              //     context,
              //     CustomSnackBar.info(
              //       backgroundColor: Colors.grey.shade800,
              //       message:
              //       "Image downloaded!",
              //       borderRadius: BorderRadius.circular(25.0),
              //     ),
              //     additionalTopPadding: 30,
              //     displayDuration: const Duration(milliseconds: 800),
              //     hideOutAnimationDuration: const Duration(milliseconds: 400),
              //   );
              downloadImage();

              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Hide Pin'),
            onTap: (){},
          ),
          ListTile(
            title: const Text('Report Pin'),
            subtitle: const Text('This goes against Pinterest\'s community guidelines'),
            onTap: (){},
          ),
          const Divider(),
          const Text('This Pin is inspired by your recent activity', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}