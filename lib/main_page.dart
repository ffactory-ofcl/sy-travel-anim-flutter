import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:sy_travel_anim/styles.dart';

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0.0;
  double _page = 0.0;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      print("page: ${pageController.page}");
      _offset = pageController.offset;
      _page = pageController.page;
      notifyListeners();
    });
  }

  double get offset => _offset;
  double get page => _page;
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  final _fakeInfo = FakeInfo();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageOffsetNotifier>(
      create: (_) {
        return PageOffsetNotifier(_pageController);
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              PageView(
                controller: _pageController,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  LeopardPage(),
                  VulturePage(),
                ],
              ),
              AppBar(),
              LeopardImage(),
              VultureImage(),
              ShareButton(),
              PageIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class LeopardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          left: -0.85 * notifier.offset,
          width: MediaQuery.of(context).size.width * 1.6,
          child: child,
        );
      },
      child: IgnorePointer(
        child: Image.asset('assets/leopard.png'),
      ),
    );
  }
}

class VultureImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          left:
              1.2 * MediaQuery.of(context).size.width - 0.85 * notifier?.offset,
          child: child,
        );
      },
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 90.0),
          child: Image.asset(
            'assets/vulture.png',
            height: MediaQuery.of(context).size.height / 3,
          ),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 24, left: 32, right: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'SY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Stack(
              children: [
                Icon(Icons.maximize),
                Transform.translate(
                  offset: Offset(0, 8),
                  child: Icon(Icons.maximize),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LeopardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QuickerElement(
            0,
            speed: 0.45,
            child: Column(
              children: [
                SizedBox(height: 128),
                Transform.translate(
                  offset: Offset(-48, 0),
                  child: RotatedNumber(),
                ),
              ],
            ),
          ),

          // Expanded(child: Container()),
          // SizedBox(height: 32),
          Expanded(
            child: Container(
              // constraints: BoxConstraints.expand(),
              // constraints: BoxConstraints.loose(
              //     Size.fromHeight(0.1 * MediaQuery.of(context).size.height)),
              // height: 500,
              // color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 32, right: 32),
                child: BottomInfo(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickerElement extends StatelessWidget {
  final int _index;
  final double _speed;
  final Widget _child;

  QuickerElement(this._index, {@required Widget child, double speed = 0.25})
      : this._child = child,
        this._speed = speed;

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double pageWidth = MediaQuery.of(context).size.width;
        return Transform.translate(
          offset: Offset(-_speed * (notifier.offset - _index * pageWidth), 0),
          child: child,
        );
      },
      child: _child,
    );
  }
}

class FakeInfo {
  final AnimalInfo leopard = AnimalInfo('Leopard', 'The leopard is very cool.');
  final AnimalInfo vulture = AnimalInfo('Vulture', 'The vulture is very cool.');
}

class AnimalInfo {
  final String name;
  final String description;

  AnimalInfo(this.name, this.description);
}

class RotatedNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 128),
      padding: EdgeInsets.only(),
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FittedBox(
          fit: BoxFit.contain,
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              '72',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum Page {
  One,
  Two,
}

class PageIndicator extends StatelessWidget {
  static const double dotSize = 6;

  PageIndicator();

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(builder: (context, notifier, child) {
      int alpha1 = ((1 - notifier.page).clamp(0, 1) * 255).toInt();
      // print("alpha1: $alpha1");
      int alpha2 = ((2 - notifier.page).clamp(0, 1) * 255).toInt();
      // print("alpha2: $alpha2");
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: dotSize,
          margin: const EdgeInsets.only(bottom: 32.0 + 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: white.withAlpha(alpha1),
                ),
                width: dotSize,
              ),
              SizedBox(width: dotSize),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: white.withAlpha(alpha2),
                ),
                width: dotSize,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class BottomInfo extends StatelessWidget {
  // final AnimalInfo _animalInfo;

  // BottomInfo(this._animalInfo);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: max(1 - 2 * notifier.page, 0),
          child: Transform.translate(
            offset: Offset(-0.3 * notifier.offset, 0),
            child: child,
          ),
        );
      },
      child: Container(
        // alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TravelDescLabel(),
            SizedBox(height: 18),
            LeopardDescription(),
          ],
        ),
      ),
    );
  }
}

class TravelDescLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Travel description',
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white70,
      ),
    );
  }
}

class LeopardDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'The leopard is distinguished by its well-camouflaged fur, opportunistic ' +
          'hunting behaviour, broad diet, and strength.',
      style: TextStyle(
        fontSize: 13,
        color: Colors.white38,
        height: 1.8,
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 32,
      bottom: 32,
      child: Icon(Icons.share, color: Colors.white70),
    );
  }
}

class VulturePage extends StatelessWidget {
  // final FakeInfo _fakeInfo;

  // VulturePage(this._fakeInfo);

  @override
  Widget build(BuildContext context) {
    return Container();
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48),
        child: Image.asset('assets/vulture.png',
            height: MediaQuery.of(context).size.height / 3),
      ),
    );
  }
}
