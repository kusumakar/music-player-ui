import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/models/model.dart';
import '/theme/theme.dart';
import '/extensions/theme_x.dart';
import '/ui/single/single_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  FeedScreenState createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen> {
  double dragStart = 0;
  double dragChange = 0;
  int currentIndex = 0;
  double pageOffset = 0;
  PageController pageController = PageController(viewportFraction: .7);
  late double scale = 0;
  @override
  void initState() {
    pageController.addListener(() {
      scale = pageController.page!;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = context.height;
    final ratio = MediaQuery.of(context).devicePixelRatio;
    final offset = lerpDouble(1, 10, (dragChange / 100))!;
    return Scaffold(
      backgroundColor: MusicPlayerTheme.grayColor,
      appBar: AppBar(
        title: SizedBox(
            height: kToolbarHeight - 20, child: Image.asset('assets/logo.png')),
        automaticallyImplyLeading: false,
        leading: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.ellipsis_vertical,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.profile_circled,
              size: 26,
            ),
          ),
        ],
      ),
      body: PageView.builder(
        onPageChanged: (value) {
          setState(() => currentIndex = value);
        },
        physics: const BouncingScrollPhysics(),
        controller: pageController,
        itemCount: Album.albums.length,
        itemBuilder: (context, index) {
          final isSelected = currentIndex == index;
          final album = Album.albums[index];
          return GestureDetector(
            onVerticalDragStart: (details) {
              dragStart = details.globalPosition.dy;
            },
            onVerticalDragUpdate: (details) {
              dragChange = ((details.globalPosition.dy - dragStart) * 1.2).clamp(0, 100);
              final firePage = ((details.globalPosition.dy - dragStart) * .7).clamp(0, 100);
              setState(() {});
              if (firePage == 100) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    fullscreenDialog: true,
                    transitionDuration: const Duration(milliseconds: 600),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return SingleScreen(
                        album: album,
                        height: height,
                      );
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              }
            },
            onVerticalDragEnd: (details) {
              setState(() {
                dragChange = 0;
                dragStart = 0;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(
                  left: isSelected ? 10 - offset : 10 - offset,
                  right: isSelected ? 10 - offset : 10 - offset,
                  top: isSelected ? (5 + dragChange) : 5 + offset,
                  bottom: isSelected
                      ? ((height * .08 * ratio) - dragChange)
                      : (height * .1 * ratio) - offset,
                ),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: isSelected ? 10 : 1,
                      )
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: const Color(0xfffefefe)),
                child: Stack(children: [
                  Hero(
                    tag: 'frame${album.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: width,
                        height: height,
                        decoration: const BoxDecoration(
                          color: Color(0xfffefefe),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                          // height: context.height,
                          width: context.width * 0.35,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Transform.scale(
                              scale: 1 + (scale - index).abs(),
                              child: Hero(
                                tag: 'image${album.id}',
                                child: Image.asset(
                                  'assets/album/${album.albumImage}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Hero(
                        tag: 'singer${album.id}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            album.singer,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Hero(
                        tag: 'albumName${album.albumName}',
                        child: Material(
                          color: Colors.transparent,
                          child: AutoSizeText(
                            album.albumName,
                            maxLines: 1,
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Icon(CupertinoIcons.music_note_2),
                      const SizedBox(height: 18),
                      AutoSizeText(
                        'DRAG TO LISTEN',
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54),
                      ),
                      const Icon(CupertinoIcons.chevron_down),
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        height: isSelected ? 30 : 0,
                        child: Image.asset(
                          'assets/3of5.png',
                          width: 300,
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
