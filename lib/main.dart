import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: GmailLikeHeader());
  }
}

class GmailLikeHeader extends StatefulWidget {
  const GmailLikeHeader({super.key});

  @override
  GmailLikeHeaderState createState() => GmailLikeHeaderState();
}

class GmailLikeHeaderState extends State<GmailLikeHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  double _lastOffset = 0;
  bool _isAppBarVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _handleScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      double offset = notification.metrics.pixels;

      if (offset <= 0 || offset >= notification.metrics.maxScrollExtent) return;

      if ((offset - _lastOffset).abs() < 5) return;

      if (offset > _lastOffset && _isAppBarVisible) {
        _controller.forward();
        _isAppBarVisible = false;
      }

      if (offset < _lastOffset && !_isAppBarVisible) {
        _controller.reverse();
        _isAppBarVisible = true;
      }

      _lastOffset = offset;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _handleScroll(notification);
              return true;
            },
            child: Stack(
              children: [
                ListView.builder(
                  padding: EdgeInsets.only(top: kToolbarHeight * 1),
                  itemCount: 50,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text("Item ${index + 1}"));
                  },
                ),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      height: kToolbarHeight * 1,
                      color: Colors.blue,
                      child: AppBar(
                        title: Text("Gmail-like Header"),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
