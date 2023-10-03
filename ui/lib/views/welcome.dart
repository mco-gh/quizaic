import 'package:flutter/material.dart';
import 'package:quizaic/const.dart';

List items = [
  {
    "header": "Quizaic = AI Powered Infinite Trivia",
    "description":
        '''Quizaic combines the power of generative AI and Google Cloud services to support creating and playing trivia quizzes and online surveys. Swipe right to learn more about this project.''',
    "image": "assets/images/logo3.png"
  },
  {
    "header": "The Vision",
    "description":
        '''Quizaic is, first and foremost, a learning tool. It was made to demonstrate a modern, cloud based, AI-powered app. In the near future we plan to open source all the code and produce a series of tutorials to help you build your own version of Quizaic or a similar app of your own design. Stay tuned for more details!''',
    "image": "assets/images/vision.jpg"
  },
  {
    "header": "Disclaimer",
    "description": '''
Quizaic is not an official Google project. It's still under construction and is likely to change frequently over the coming months. We'll share occasional notes about what's changing and why on this welcome page.

Please don't use Quizaic for anything important. But do let us know (via quizaic@google.com) if find any problems or have any suggestions.
.''',
    "image": "assets/images/disclaimer.jpg"
  }
];

class WelcomePage extends StatefulWidget {
  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  List<Widget> slides = items
      .map((item) => Container(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: verticalSpaceHeight * 3),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.contain,
                  width: 520.0,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: verticalSpaceHeight),
                        Text(item['header'],
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                height: 2.0)),
                        Text(
                          item['description'],
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              letterSpacing: 1.2,
                              fontSize: 18.0,
                              height: 1.3),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: verticalSpaceHeight),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )))
      .toList();

  List<Widget> indicator() => List<Widget>.generate(
      slides.length,
      (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: currentPage.round() == index
                    ? Color(0XFF256075)
                    : Color(0XFF256075).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));

  double currentPage = 0.0;
  final _pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page as double;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageViewController,
            itemCount: slides.length,
            itemBuilder: (BuildContext context, int index) {
              return slides[index];
            },
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(top: 70.0),
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicator(),
                ),
              )
              //  ),
              )
          // )
        ],
      ),
    );
  }
}
