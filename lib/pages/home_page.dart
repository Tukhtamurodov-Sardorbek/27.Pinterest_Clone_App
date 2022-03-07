import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pinterest/pages/messages_page.dart';
import 'package:pinterest/pages/profile_page.dart';
import 'package:pinterest/pages/search_page.dart';
import 'package:pinterest/utils/home_page_utils.dart';
import 'package:pinterest/utils/masonry_grid_view.dart';
import 'package:pinterest/utils/profile_image_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  int _currentPageIndex = 0;
  bool showFAB = true;

  @override
  void initState() {
    super.initState();
    _currentPageIndex == 0 ? _tabController = TabController(length: 5, vsync: this) : _tabController.dispose();
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
      // Scrolling up
        case ScrollDirection.forward:
          setState(() {
            showFAB = true;
          });
          break;
      // Scrolling down
        case ScrollDirection.reverse:
          setState(() {
            showFAB = false;
          });
          break;
      // Idle - keep FAB visibility unchanged
        case ScrollDirection.idle:
          break;
      }

      if (kDebugMode) {
        print('Position: ${_scrollController.position.userScrollDirection}    BOOL: $showFAB');
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  RefreshConfiguration.copyAncestor(
      enableLoadingWhenFailed: true,
      context: context,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool isScrolled) {
            return <Widget>[
              if(_currentPageIndex == 0)
                HomePageSliverAppBar(context, isScrolled, _tabController)
              else
                const SliverAppBar(backgroundColor: Colors.white, collapsedHeight: 0, expandedHeight: 0, toolbarHeight: 0,)
            ];
          },
          body: IndexedStack(
            index: _currentPageIndex,
            children: [
              TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Scrollbar(child: Post(pageIndex: _currentPageIndex, tabIndex: 0)),
                    Scrollbar(child: Post(pageIndex: _currentPageIndex, tabIndex: 1)),
                    Scrollbar(child: Post(pageIndex: _currentPageIndex, tabIndex: 2)),
                    Scrollbar(child: Post(pageIndex: _currentPageIndex, tabIndex: 3)),
                    Scrollbar(child: Post(pageIndex: _currentPageIndex, tabIndex: 4)),
                  ]
              ),
              const Search(),
              _currentPageIndex == 2 ?Messages(pageIndex: _currentPageIndex) : const SizedBox(),
              const AccountPage()
            ],
          ),
        ),
        floatingActionButtonLocation: showFAB ? FloatingActionButtonLocation.centerFloat : FloatingActionButtonLocation.endFloat,
        floatingActionButton: showFAB ? Container(
          width: 225,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)),
            margin: const EdgeInsets.fromLTRB(50, 0, 50, 10),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: Colors.transparent,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _currentPageIndex,
              onTap: (int index) {
                if (kDebugMode) {
                  print('INDEX: $index && CurrentPage: $_currentPageIndex');
                }
                setState(() {
                  _currentPageIndex = index;
                });
                if (kDebugMode) {
                  print('INDEX: $index && CurrentPage: $_currentPageIndex');
                }
              },
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home, color: Colors.grey, size: 30),
                    activeIcon: Icon(Icons.home, color: Colors.black, size: 30),
                    label: ""
                ),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.search, color: Colors.grey, size: 30),
                    activeIcon: Icon(Icons.search, color: Colors.black, size: 30),
                    label: ""
                ),
                const BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.chat_bubble_fill, color: Colors.grey, size: 30),
                    activeIcon: Icon(CupertinoIcons.chat_bubble_fill, color: Colors.black, size: 30),
                    label: ""
                ),
                BottomNavigationBarItem(
                    icon: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                            height: 35,
                            width: 35,
                            child: UpdateProfileImage.getImage() != null
                                ? Image.file(UpdateProfileImage.getImage(), fit: BoxFit.cover)
                                : const Image(image: AssetImage('assets/local/profile_image.png'))
                        )),
                    activeIcon:  ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                            height: 35,
                            width: 35,
                            child: UpdateProfileImage.getImage() != null
                                ? Image.file(UpdateProfileImage.getImage(), fit: BoxFit.cover,)
                                : const Image(image: AssetImage('assets/local/profile_image.png'))
                        )),
                    label: ""
                ),
              ],
            )) : FloatingActionButton(
          onPressed: () {
            if (_scrollController.hasClients) {
              final position = _scrollController.position.minScrollExtent;
              _scrollController.animateTo(
                position,
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeOut,
              );
            }
            setState(() {
              showFAB = !showFAB;
            });
          },
          isExtended: true,
          tooltip: "Scroll to Top",
          backgroundColor: Colors.white,
          child: const Icon(Icons.arrow_upward, color: Colors.black,),
        ),

        // Visibility(
        //   visible: showFAB,
        //   child: Container(
        //       height: 58,
        //       decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(30)),
        //       margin: const EdgeInsets.fromLTRB(50, 0, 50, 10),
        //       child: BottomNavigationBar(
        //         type: BottomNavigationBarType.fixed,
        //         elevation: 0,
        //         backgroundColor: Colors.transparent,
        //         showSelectedLabels: false,
        //         showUnselectedLabels: false,
        //         currentIndex: _currentPageIndex,
        //         onTap: (int index) {
        //           print('INDEX: $index');
        //           setState(() {
        //             _currentPageIndex = index;
        //           });
        //         },
        //         items: const [
        //           BottomNavigationBarItem(
        //               icon: Icon(Icons.home, color: Colors.grey),
        //               activeIcon: Icon(Icons.home, color: Colors.black),
        //               label: ""
        //           ),
        //           BottomNavigationBarItem(
        //               icon: Icon(Icons.search, color: Colors.grey),
        //               activeIcon: Icon(Icons.search, color: Colors.black),
        //               label: ""
        //           ),
        //           BottomNavigationBarItem(
        //               icon: Icon(CupertinoIcons.chat_bubble_fill,
        //                   color: Colors.grey),
        //               activeIcon: Icon(CupertinoIcons.chat_bubble_fill,
        //                   color: Colors.black),
        //               label: ""
        //           ),
        //           BottomNavigationBarItem(
        //               icon: Icon(Icons.account_circle, color: Colors.grey),
        //               activeIcon:
        //               Icon(Icons.account_circle, color: Colors.black),
        //               label: ""
        //           ),
        //         ],
        //       )),
        // ),
      ),
      // headerBuilder: () => WaterDropMaterialHeader(
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      footerTriggerDistance: 30.0,
    );
  }
}