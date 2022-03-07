import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinterest/utils/profile_image_util.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  static const String id = '/profile_page';
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController textController = TextEditingController();
  String name = "sardonic777";
  String email = "@sardortukhtamurodov31";
  int followers = 2002;
  int followings = 31;
  var imagePicker;

  List defaultImage = [
    'https://i2.wp.com/wallpapercave.com/wp/wp2338602.jpg',
    'https://images-na.ssl-images-amazon.com/images/I/71dt6sFILWL._AC_SL1500_.jpg',
    'https://i.pinimg.com/736x/87/d1/5b/87d15ba8075d11c9289d4a735a4e75be.jpg',
    'https://i.pinimg.com/474x/6b/a4/22/6ba4227ae9d731f5f6417ebc419ecaf4--tumblr-pages-barcelona.jpg',
    'https://fcwallpaper.com/wp-content/uploads/2018/07/Wallpapers-HD-Messi.jpg',
    'https://i.pinimg.com/736x/7c/1a/35/7c1a355096eab3a1a7db6075d56fbcb6.jpg',
    'https://i.ytimg.com/vi/kC8feQtA9DQ/maxresdefault.jpg',
    'https://avatars.mds.yandex.net/get-zen_doc/1926321/pub_5d75bf4b9515ee00ae918dbd_5d75c3483d008800ad99f0dc/scale_1200',
  ];

  Future <void> refresh() async {
    setState(() {
      defaultImage = [
        'https://i2.wp.com/wallpapercave.com/wp/wp2338602.jpg',
        'https://images-na.ssl-images-amazon.com/images/I/71dt6sFILWL._AC_SL1500_.jpg',
        'https://i.pinimg.com/736x/87/d1/5b/87d15ba8075d11c9289d4a735a4e75be.jpg',
        'https://i.pinimg.com/474x/6b/a4/22/6ba4227ae9d731f5f6417ebc419ecaf4--tumblr-pages-barcelona.jpg',
        'https://fcwallpaper.com/wp-content/uploads/2018/07/Wallpapers-HD-Messi.jpg',
        'https://i.pinimg.com/736x/7c/1a/35/7c1a355096eab3a1a7db6075d56fbcb6.jpg',
        'https://i.ytimg.com/vi/kC8feQtA9DQ/maxresdefault.jpg',
        'https://avatars.mds.yandex.net/get-zen_doc/1926321/pub_5d75bf4b9515ee00ae918dbd_5d75c3483d008800ad99f0dc/scale_1200',
      ];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.black,),
                      onPressed: (){},
                    ),
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.ellipsisH, color: Colors.black, size: 18,),
                      onPressed: (){},
                    ),
                  ],
                ),
                // profile image
                GestureDetector(
                  onTap: () async {
                    var source = ImageSource.gallery;
                    XFile image = await imagePicker.pickImage(
                        source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                    setState(() {
                      UpdateProfileImage.setImage(File(image.path));
                    });
                  },

                  child: SizedBox(
                      width: 200,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:  UpdateProfileImage.getImage() != null
                            ? Image.file(
                          UpdateProfileImage.getImage(),
                          fit: BoxFit.cover,
                        )
                            : const Image(
                          image: AssetImage('assets/local/profile_image.png'),
                          fit: BoxFit.cover,
                        ),
                      )
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 35, color: Colors.black),)),
                const SizedBox(
                  height: 12,
                ),
                Center(child: Text(email, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),)),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text(followers.toString(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black))),
                      const SizedBox(
                        width: 5,
                      ),
                      const Center(child: Text("followers", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black))),
                      const SizedBox(
                        width: 5,
                      ),
                      const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 1,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Center(child: Text(followings.toString(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black),)),
                      const SizedBox(
                        width: 5,
                      ),
                      const Center(child: Text("followings", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black),)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // text field
                SizedBox(
                  height: 38,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            controller: textController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {},
                            onSubmitted: (search){},
                            onTap: (){},
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.search_sharp,
                                color: Colors.black54,
                              ),

                              filled: true,
                              fillColor: Colors.grey.shade200,
                              hintText: 'Search your Pins',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16
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
                      ),
                      IconButton(
                          icon: const Icon(Icons.add, size: 28, color: Colors.black,),
                          onPressed: (){},
                      ),
                      const SizedBox(width: 20)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemCount: defaultImage.length,
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemBuilder: (context, index){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                imageUrl: defaultImage[index],
                                placeholder: (context, url) =>
                                const Image(image: AssetImage('assets/cash/img.png')),
                                errorWidget: (context, url, error) =>
                                const Image(image: AssetImage('assets/cash/img_1.png')),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Align(
                                  child: GestureDetector(
                                    onTap: (){},
                                    child: const Icon(FontAwesomeIcons.ellipsisH, color: Colors.black, size: 17,),
                                  ),
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                              width: MediaQuery.of(context).size.width/2,
                              height: 20,
                            ),
                          ],
                        );
                      }
                  ),
                ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
