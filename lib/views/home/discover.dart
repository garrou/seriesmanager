import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:seriesmanager/views/home/home.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
      (Route<dynamic> route) => false);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IntroductionScreen(
          key: _introKey,
          pages: <PageViewModel>[
            PageViewModel(
              title: 'Series Manager',
              body: """
Une application permettant de gérer vos séries.
Ajoutez vos séries, les saisons vues et c'est tout, nous nous chargeons du reste !
                 """,
              image: Padding(
                child: SvgPicture.asset('assets/login.svg'),
                padding: const EdgeInsets.all(10.0),
              ),
            ),
            PageViewModel(
              title: 'Visualiser vos données',
              body: """
De nombreux graphiques sont disponibles pour visualiser votre activité.
                 """,
              image: Padding(
                child: SvgPicture.asset('assets/charts.svg'),
                padding: const EdgeInsets.all(10.0),
              ),
            ),
          ],
          showSkipButton: true,
          skip: Text(
            'Passer',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          next: Icon(
            Icons.arrow_forward_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          done: Text(
            'Compris',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          curve: Curves.easeIn,
          dotsDecorator: DotsDecorator(
            size: const Size(10.0, 10.0),
            color: Colors.grey,
            activeColor: Theme.of(context).primaryColor,
            activeSize: const Size(10.0, 10.0),
            activeShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          onDone: () => _onIntroEnd(context),
          onSkip: () => _onIntroEnd(context),
        ),
      );
}
