import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numerical_techniques/Bisection.dart';
import 'package:numerical_techniques/Euler.dart';
import 'package:numerical_techniques/GaussJacobi.dart';
import 'package:numerical_techniques/GaussSiedal.dart';
import 'package:numerical_techniques/NewtonRaphson.dart';
import 'package:numerical_techniques/NumericalQuadrature.dart';
import 'package:numerical_techniques/RangeKutta.dart';
import 'package:numerical_techniques/SideDrawer.dart';
import 'package:numerical_techniques/RegulaFalsi.dart';
import 'package:numerical_techniques/Taylor.dart';
import 'package:numerical_techniques/size_config.dart';

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Numerical Techniques',
      color: Colors.black,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('NUMERICAL TECHNIQUES',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),textAlign: TextAlign.left,),
        ),
        drawer: SideDrawer(),
        body: Container(
          child: ListView(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(child: Text('For Solving Integration',style: TextStyle(decoration: TextDecoration.underline),),),
                        ListTile(
                          title: Text('Numerical Quadrature',
                          textAlign: TextAlign.left, 
                          style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>NumericalQuadrature()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    Container(child: Text('For Solving System of Linear Equations',style: TextStyle(decoration: TextDecoration.underline),),),
                    ListTile(
                      title: Text('Gauss Jacobi Method',
                        textAlign: TextAlign.left, 
                        style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),
                      ),
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>GaussJacobi()));
                      },
                    ),
                    ListTile(
                      title: Text('Gauss Siedal Method',
                        textAlign: TextAlign.left, 
                        style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),
                      ),
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>GaussSiedal()));
                      },
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    Container(child: Text('To Obtain Root of an Algebraic Equation',style: TextStyle(decoration: TextDecoration.underline),),),
                    ListTile(
                      title: Text('Bisection Method',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),),
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>Bisection()));
                      },
                    ),
                    ListTile(
                      title: Text('Regula Falsi Method',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),),
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>RegulaFalsi()));
                      },
                    ),
                    ListTile(
                      title: Text('Newton Raphson Method',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>NewtonRaphson()));
                      },
                    ),
                  ],
                ),
              ),
              Card( 
                child: Column(
                  children: <Widget>[
                    Container(child: Text('For Solving Ordinary Differential Equation',style: TextStyle(decoration: TextDecoration.underline),),),
                    ListTile(
                      title: Text('Taylor\'s Method',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>Taylor()));
                      },
                    ),
                    ListTile(
                      title: Text('Euler\'s Method',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>Euler()));
                      },
                    ),
                    ListTile(
                      title: Text('Range-Kutta Method (4th order)',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>RangeKutta()));
                      },
                    ),
                  ],
                ),
              ),
            ],
            ),
          ),
        ), 
    );
  }
}