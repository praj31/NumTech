import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numerical_techniques/DrawerAbout.dart';
import 'package:numerical_techniques/size_config.dart';

class SideDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
    ]);
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('NUMERICAL\nTECHNIQUES',
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal*6,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
          ),
          ListTile(
            
            leading: Icon(Icons.dashboard, color: Colors.purple,),
            title: Text('Dashboard'),
            onTap: (){
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.purple,),
            title: Text('Help'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.account_circle, color: Colors.purple,),
            title: Text('About'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>DrawerAbout()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.purple,),
            title: Text('Exit'),
            onTap: ()=> exit(0),
          ),
        ] 
      ),
    );
  }
}