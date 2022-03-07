import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/models/pinterest_models.dart';
import 'package:pinterest/services/http_service.dart';
import 'package:pinterest/utils/home_page_utils.dart';


class PostView extends StatefulWidget {
  Pinterest? post;
  String? search;
  PostView({Key? key, this.post, this.search}) : super(key: key);

  static const String id = '/detail_page';

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Pinterest> postsList = [];
  bool isLoading = true;
  int page = 1;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('DETAIL PAGE IS CALLED');

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


  // void _bottomSheet(BuildContext context, String url) {
  //   showModalBottomSheet(
  //       barrierColor: Colors.transparent,
  //       isScrollControlled: true,
  //       elevation: 5,
  //       context: context,
  //       builder: (context) => SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.5,
  //           child: HomePageBottomSheet(url: url)
  //       )
  //   );
  // }

  Future refresh() async {
    if (kDebugMode) {
      print('**** REFRESHING (Detail Page) ****');
    }
    if(postsList.isEmpty){
      setState(() {
        page = 1;
      });
      postsList = await Network.GET(Network.API_SEARCH_LIST, Network.paramsSearch(page: page, topic: widget.search!.isNotEmpty ? widget.search! : widget.post!.urls.regular));
    }
    else{
      setState(() {
        page += 1;
      });
      postsList.addAll(await Network.GET(Network.API_SEARCH_LIST, Network.paramsSearch(page: page, topic: widget.search!.isNotEmpty ? widget.search! : widget.post!.urls.regular)));
    }
    setState(() {isLoading = false;});
  }

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

  @override
  Widget build(BuildContext context) {
    return widget.post == null ? const SizedBox() : Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, size: 26, color: Colors.white),
          onPressed: (){Navigator.pop(context);},
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(0),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Stack(
                  children: [
                    // Image(image: NetworkImage(widget.post.urls.regular))
                    InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 3,
                      child: CachedNetworkImage(
                        imageUrl: widget.post!.urls.regular,
                        placeholder: (context, url) =>
                            AspectRatio(
                                aspectRatio: widget.post!.width / widget.post!.height,
                                child: Container(
                                  color: getColorFromHex(widget.post!.color),
                                )),
                        errorWidget: (context, url, error) =>
                        const Image(image: AssetImage('assets/cash/img_1.png')),
                        fit: BoxFit.cover,
                      ),
                    ),

                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, right: 5),
                          child: IconButton(
                            icon: const Icon(Icons.more_horiz, size: 36, color: Colors.white),
                            onPressed: (){},
                          ),
                        )
                    )
                  ],
                ),
              ),
              ListTile(
                tileColor: Colors.white,
                leading: SizedBox(
                  height: 38,
                  width: 38,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl:
                      widget.post!.user.profileImage.small,
                      placeholder: (context, url) => const Image(
                          image: AssetImage('assets/cash/img.png')),
                      errorWidget: (context, url, error) => const Image(
                          image: AssetImage('assets/cash/img_1.png')),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(widget.post!.user.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18),),
                subtitle: Text('${widget.post!.user.totalPhotos} followers', style: const TextStyle(color: Colors.grey, fontSize: 16),),
                trailing: MaterialButton(
                  height: 36,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Text('Follow', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16.5),),
                  color: Colors.grey.shade500,
                  onPressed: () {},
                ),
              ),
              widget.post!.description == 'null'
                  ? widget.post!.altDescription == null
                  ? const SizedBox() : Flexible(child: Container(color: Colors.white, alignment: Alignment.center, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Text(widget.post!.altDescription, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),),)
                  : Flexible(child: Container(color: Colors.white, alignment: Alignment.center, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Text(widget.post!.description ?? '', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),),),

              Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: ListTile(
                  leading: IconButton(
                    icon: const Icon(CupertinoIcons.chat_bubble_fill, color: Colors.black, size: 26),
                    onPressed: (){},
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: 40,
                        child: const Text('View', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16.5)),
                        color: Colors.grey.shade400,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: 40,
                        child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16.5)),
                        color: Colors.deepOrange.shade500,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.share, size: 26, color: Colors.grey),
                    onPressed: (){},
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Container(
            height: 170,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                const Text('Share your feedback', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
                const SizedBox(height: 20),
                ListTile(
                  tileColor: Colors.white,
                  leading: SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: const Image(image: AssetImage('assets/local/profile_image.png'))
                    ),
                  ),
                  title: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        hintText: 'Add a comment'
                    ),
                  ),
                ),
              ],
            ),

          ),
          const SizedBox(height: 3),
          Container(
            height: 55,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(height: 5),
                Center(child: Text('More like this', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),),
                SizedBox(height: 20),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                  child: MasonryGridView.count(
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
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
                isLoading ?
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(color: Colors.black),
                    ),
                  ),
                ) : const SizedBox.shrink(),
              ],
            ),
          )
        ],
      ),
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
                      AspectRatio(
                          aspectRatio: postsList[index].width / postsList[index].height,
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
                        imageUrl:
                        postsList[index].user.profileImage.small,
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
                        // _bottomSheet(context, widget.post!.urls.regular);
                      }),
                ],
              )
            ],
          )),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PostView(post: postsList[index], search: widget.search)));
      },
    );
  }
}
