import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinterest/utils/masonry_grid_view.dart';

class Search extends StatefulWidget {
  static const String id = 'explore_page';

  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController textController = TextEditingController();
  String search = '';
  bool isSubmitted = false;
  bool showClearButton = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('SEARCH PAGE IS CALLED');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(62),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 2),
              child: TextField(
                controller: textController,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    isSubmitted = false;
                    showClearButton = true;
                  });
                },
                onSubmitted: (search){
                  setState(() {
                    isSubmitted = true;
                    showClearButton = false;
                  });
                  if (kDebugMode) {
                    print('Submitted: $search \t Written: ${textController.text}');
                  }
                },
                onTap: (){
                  setState(() {
                    showClearButton = textController.text.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_sharp,
                    color: Colors.grey[600]!,
                    size: 25,
                  ),
                  suffixIcon: showClearButton && textController.text.isNotEmpty
                      ? IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.black,),
                      onPressed: (){
                        textController.clear();
                        setState(() {});
                      })
                      : IconButton(
                      icon: Icon(Icons.camera_alt_rounded, color: Colors.grey[600]!),
                      iconSize: 25,
                      splashRadius: 1,
                      onPressed: (){}
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'Search',
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
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: isSubmitted ? Post(pageIndex: 1, search: textController.text) : const SizedBox(),
            ),
          ],
        ));
  }
}
