import 'package:flutter/material.dart';
import 'package:numerical_techniques/SideDrawer.dart';
import 'package:numerical_techniques/size_config.dart';
import 'package:flutter/services.dart';

class DrawerAbout extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        appBar: AppBar(
          title: Text('About'),
          backgroundColor: Colors.purple,
        ),
        drawer: SideDrawer(),
        body: Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('Numerical Techniques', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),),
              ),
              ListTile(
                title: Text('This app is designed for evaluation of mathematical problems pertaining to integration, system of linear equations, obtaining root of an algebraic equation and for solving first order ordinary differential equation using numerical techniques.'),
              ),
              ListTile(
                title: Text('The following methods are included:\n- Numerical Quadrature\n- Gauss Jacobi Method\n- Gauss Siedal Method\n- Bisection Method\n- Newton Raphson Method\n- Regula Falsi Method\n- Euler\'s Method\n- Range Kutta Method(4-th order)'),
              ),
              ListTile(
                title: Text('App Version: 1.0.0\nAuthor: Pratikraj Rajput'),
              ),
            ],
          ),
        ),
     // ),
    );
  }
}