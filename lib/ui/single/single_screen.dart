import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '/models/model.dart';
import '/ui/single/widgets/animation_translate.dart';
import '/ui/single/widgets/flip_widget.dart';
import '/ui/single/widgets/player_widget.dart';
import '/theme/theme.dart';
import '../../extensions/theme_x.dart';

class SingleScreen extends StatefulWidget {
  final Album album;
  final double height;
  const SingleScreen({Key? key, required this.album, required this.height})
      : super(key: key);

  @override
  SingleScreenState createState() => SingleScreenState();
}

class SingleScreenState extends State<SingleScreen> {
  bool finish = false;
  late ScrollController _scrollController;
  double offset = 0;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        finish = true;
      });
    });
    //_scrollController = ScrollController(initialScrollOffset: 400);
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          offset = _scrollController.offset;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = widget.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: SizedBox(
            height: kToolbarHeight - 20, child: Image.asset('assets/logo.png')),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
              tag: 'frame${widget.album.id}',
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {},
                  child: Container(
                    width: width,
                    height: widget.height,
                    decoration: const BoxDecoration(
                      color: Color(0xfffefefe),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              )),
          ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: height * .03),
              Hero(
                tag: 'image${widget.album.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Center(
                    child: SizedBox(
                      width: height * .40,
                      height: height * .40,
                      child: Material(
                        color: Colors.transparent,
                        child: FlipWidget(
                          albumImage: widget.album.albumImage,
                          size: height * .40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              finish
                  ? AnimationTranslate(
                      child: PlayerWidget(album: widget.album, height: height))
                  : Container(),
              finish
                  ? AnimationTranslate(
                      child: Column(
                        children: [
                          AutoSizeText(
                            'TRACK LIST',
                            maxLines: 1,
                            style: context.headline6,
                            textAlign: TextAlign.center,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 36,
                            color: MusicPlayerTheme.darkColor,
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
