import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinterest/models/pinterest_models.dart';
import 'package:pinterest/services/http_service.dart';
import 'package:pinterest/utils/home_page_utils.dart';

import 'detail_page.dart';

class Messages extends StatefulWidget {
  int pageIndex;
  Messages({required this.pageIndex});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> with SingleTickerProviderStateMixin{
  late TabController _tabController = TabController(length: 2,  vsync: this);
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  List<List<Pinterest>> postsList = [[], [], [], [], [], [], [], []];
  Map<String, String> topics = {
    'Your tape is replenished with new pines' : 'dream',
    'Wallpaper, Aircraft and other ideas you\'ve been looking for' : 'aerial',
    'We think you may like these ideas' : 'stunning',
    'Trending searches' : 'Aesthetic Phone Wallpaper',
    'Trending searches2' : 'Good Morning For Stories',
    'Trending searches3' : 'Funny Wallpapers',
    'Here are some idea boards you might like' : 'creative',
    'Your tape is replenished with new pines ' : 'awesome images'
  };
  bool isLoading = true;
  int page = 1;
  late bool isInitialized = widget.pageIndex == 2;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2,  vsync: this);
    if (kDebugMode) {
      print('MESSAGE PAGE IS CALLED');
      print('MESSAGES PAGE => INDEX: ${widget.pageIndex} => BOOL: $isInitialized');
    }
    for(int i = 0; i<postsList.length; i++){
      if(postsList[i].isEmpty){
        setState(() {isInitialized = false;});
        refresh();
        break;
      } else{
        setState(() {isInitialized = true;});
      }
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        refresh();
      } else{
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }

  Future refresh() async {
    if (kDebugMode) {
      print('**** REFRESHING (Detail Page) ****');
    }
    for(int i = 0; i< 8; i++){
      if(postsList[i].isEmpty){
        postsList[i] = await Network.GET(Network.API_SEARCH_LIST, Network.paramsSearch(page: page, per_page: 5, topic: topics.values.toList()[i]));
      }
      else{
        postsList[i].addAll(await Network.GET(Network.API_SEARCH_LIST, Network.paramsSearch(page: page, per_page: 5, topic: topics.values.toList()[i])));
      }
    }

    setState(() {isLoading = false;});
    for(int i = 0; i<postsList.length; i++){
      if(postsList[i].isEmpty){
        setState(() {isInitialized = false;});
        break;
      } else{
        setState(() {isInitialized = true;});
      }
    }
  }

  // void _bottomSheet(BuildContext ctx) {
  //   showModalBottomSheet(
  //       barrierColor: Colors.transparent,
  //       isScrollControlled: true,
  //       elevation: 5,
  //       context: ctx,
  //       builder: (ctx) => SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.5,
  //           child: const HomePageBottomSheet()
  //       )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 15,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(35),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15, right:  MediaQuery.of(context).size.width * 0.1),
              child:Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child:
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Updates', height: 30),
                        Tab(text: 'Messages', height: 30)
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      indicator: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10), // Creates border
                          color: Colors.black
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    icon: const Image(image: AssetImage('assets/icons/other_materials/img.png'), width: 23),
                    onPressed: (){},
                  )
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              isInitialized ? Scrollbar(
                  child: Updates()
              ) : const Center(child: CircularProgressIndicator(color: Colors.black)),
              Scrollbar(
                  child: Messages()
              ),
            ]
        )
    );
  }

  Widget Updates(){
    return ListView(
      children: [
        pin1(0, context, topics,  postsList),
        pin1(1, context, topics,  postsList),
        pin2(2, context, topics,  postsList),
        pin3(context, topics,  postsList),
        pin1(6, context, topics,  postsList),
        pin1(7, context, topics,  postsList),
      ],
    );
  }

  Widget Messages(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text('Share ideas with your friends', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search_sharp,
                          color: Colors.grey[600]!,
                          size: 25,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: 'Search by name or email',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                            fontSize: 18
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: MaterialButton(
                color: Colors.black,
                height: 60,
                minWidth: 60,
                shape: const CircleBorder(),
                child: const Icon(Icons.edit_sharp, color: Colors.white, size: 40),
                onPressed: (){},
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget pin1(int number, BuildContext context, Map<String, String> topics, List<List<Pinterest>> postsList){
  return Container(
    height: 335,
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(topics.keys.toList()[number], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: LoadImage(postsList[number][0], topics.values.toList()[number], context, [true, true, false, false], 284),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: LoadImage(postsList[number][1], topics.values.toList()[number], context, [false, false, false, false], 284),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: LoadImage(postsList[number][2], topics.values.toList()[number], context, [false, false, true, true], 284),
            )
          ],
        ),
      ],
    ),
  );
}

Widget pin2(int number, BuildContext context, Map<String, String> topics, List<List<Pinterest>> postsList){
  return Container(
    height: 185,
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(topics.keys.toList()[number], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            SizedBox(
              height: 153,
              child: LoadImage(postsList[number][0], topics.values.toList()[number], context, [true, true, false, false], 295),
            ),
            const SizedBox(width: 2),
            Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1
                    ),
                    children: [
                      LoadImage(postsList[number][1], topics.values.toList()[number], context, [false, false, false, false], 90),
                      LoadImage(postsList[number][2], topics.values.toList()[number], context, [false,false, true, false], 90),
                      LoadImage(postsList[number][3], topics.values.toList()[number], context, [false, false, false, false], 90),
                      LoadImage(postsList[number][4], topics.values.toList()[number], context, [false,false, false, true], 90),
                    ],
                  ),
                )
            ),
          ],
        ),
      ],
    ),
  );
}

Widget pin3(BuildContext context, Map<String, String> topics, List<List<Pinterest>> postsList){
  return Container(
    height: MediaQuery.of(context).size.shortestSide <= 460 ? 260 : 325,
    // color: CupertinoColors.systemBlue,
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(topics.keys.toList()[3], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
        ),
        Expanded(
          child: SizedBox(
            height: 260,
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childAspectRatio: 4/2
              ),
              children: [
                LoadImage(postsList[3][1], topics.values.toList()[3], context, [true, false, false, false],0),
                LoadImage(postsList[4][0], topics.values.toList()[4], context, [false,false, true, false], 0),
                LoadImage(postsList[5][3], topics.values.toList()[5], context, [false, true, false, true], 0),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget list(){
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
  return ListTile(
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      // child: CachedNetworkImage(
      //   fit: BoxFit.cover,
      //   imageUrl: post.urls.regular,
      //   placeholder: (context, url) =>
      //       AspectRatio(
      //           aspectRatio: post.width / post.height,
      //           child: Container(
      //             color: getColorFromHex(post.color),
      //           )
      //       ),
      //   errorWidget: (context, url, error) => const Image(image: AssetImage('assets/cash/img_1.png')),
      // ),
    ),

  );
}

Widget LoadImage(Pinterest post, String topic, BuildContext context, List<bool> borders, double _height){
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

  return GestureDetector(
    child: ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: borders[0] ? const Radius.circular(20) : Radius.zero,
        bottomLeft: borders[1] ? const Radius.circular(20) : Radius.zero,
        topRight: borders[2] ? const Radius.circular(20) : Radius.zero,
        bottomRight: borders[3] ? const Radius.circular(20) : Radius.zero,
      ),
      child: CachedNetworkImage(
        height: _height,
        fit: BoxFit.cover,
        imageUrl: post.urls.regular,
        placeholder: (context, url) =>
            AspectRatio(
                aspectRatio: post.width / post.height,
                child: Container(
                  color: getColorFromHex(post.color),
                )
            ),
        errorWidget: (context, url, error) => const Image(image: AssetImage('assets/cash/img_1.png')),
      ),
    ),
    onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext contex) =>
          PostView(post: post, search: topic)));
    },
  );
}