import 'package:flutter/material.dart';

class CoachProfileScreen extends StatefulWidget {
  static String id = 'coach_profile_screen';

  @override
  _CoachProfileScreenState createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Perfil del entrenador'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: new Stack(
          children: <Widget>[
            ClipPath(
              child: Container(color: Theme.of(context).primaryColor.withOpacity(0.8)),
              clipper: getClipper(),
            ),
            Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)])),
                    SizedBox(height: 90.0),
                    Text(
                      'Tom Cruise',
                      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      'Subscribe guys',
                      style: TextStyle(fontSize: 17.0, fontStyle: FontStyle.italic, fontFamily: 'Montserrat'),
                    ),
                  ],
                ))
          ],
        ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
