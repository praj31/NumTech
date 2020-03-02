import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:numerical_techniques/size_config.dart';
import 'package:math_expressions/math_expressions.dart';

class NumericalQuadrature extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _NumericalQuadrature();
  }
}

class _NumericalQuadrature extends State<NumericalQuadrature>{
  String eqns;
  bool _function=true;
  String func=""; String func1="";
  bool startBracket=false;
  int bracket=0;
  int precision=2;
  final _controlFunc= TextEditingController();
  final _controlLB= TextEditingController();
  final _controlUB= TextEditingController();
  final _controlSS= TextEditingController();
  final _controlY= TextEditingController();
  final _precision= TextEditingController();
  List<double> Y=new List<double>();
  Column _displayer;
  Column _functionAnswer;
  Column _discreteAnswer;
  String _trapezoid;
  String _simp13;
  String _simp38;
  @override
  Widget build(BuildContext context){
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
    ]);
    toDisplay();
    return MaterialApp(
      title: 'Numerical Techniques',
      color: Colors.black,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(icon:Icon(Icons.arrow_back), onPressed:() => Navigator.pop(context,true),),
          title: Text('Numerical Quadrature'),
        ),
        body: ListView(
          children: <Widget>[
            Column(
          children:<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text('Discrete Values'),
                Switch(
                  value: _function,
                  onChanged: (bool newValue){
                    _function=newValue;
                    toDisplay();
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  dragStartBehavior: DragStartBehavior.start,
                  activeColor: Colors.greenAccent,
                  activeTrackColor: Colors.green,
                  inactiveThumbColor: Colors.greenAccent,
                  inactiveTrackColor: Colors.green,
                ),
                Text('Function'),
              ],
            ),
            Container(
              child: _displayer,
            ),
          ],
        ),],
      ),
    ),);
  }
  void toDisplay(){
    setState(() {
      if(_function){
        _displayer=new Column(
          children: <Widget>[
            RaisedButton(
              elevation: 4,
              padding: EdgeInsets.all(12),
              color: Colors.purpleAccent,
              onPressed: (){_showKeyboard(context);},
              child: Text('Click here to enter the function',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4,color: Colors.white),),
            ),
            Container(
              height: SizeConfig.blockSizeVertical*5,
              alignment: Alignment.center,
              child: Text('Entered Function: $func',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*5),),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Lower limit:'),
                Container(
                  width: SizeConfig.blockSizeHorizontal*10,
                  height: SizeConfig.blockSizeVertical*2.5,
                  child: TextField(
                    decoration: InputDecoration( contentPadding: EdgeInsets.only(bottom: 6)),
                    controller: _controlLB,
                  ),
                ),
                Text('Upper limit:'),
                Container(
                  width: SizeConfig.blockSizeHorizontal*10,
                  height: SizeConfig.blockSizeVertical*2.5,
                  child: TextField(
                    decoration: InputDecoration( contentPadding: EdgeInsets.only(bottom: 6)),
                    controller: _controlUB,
                  ),
                ),
                Text('Step size:'),
                Container(
                  width: SizeConfig.blockSizeHorizontal*10,
                  height: SizeConfig.blockSizeVertical*2.5,
                  child: TextField(
                    decoration: InputDecoration( contentPadding: EdgeInsets.only(bottom: 6)),
                    controller: _controlSS,
                  ),
                ),
              ],
            ),
            Divider(),
            Text('Enter precision:'),
            TextField(
              controller: _precision,
              decoration: InputDecoration(hintText: '(2 by default)',contentPadding: EdgeInsets.fromLTRB(5, 10, 0, 0),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  elevation: 10.0,
                  color: Colors.deepPurpleAccent,
                  child: Text('Calculate', 
                    style: TextStyle(color: Colors.white)
                  ),
                  onPressed: (){ calculate('F'); },
                ),
                RaisedButton(
                  elevation: 10.0,
                  color: Colors.red,
                  child: Text('Reset', 
                    style: TextStyle(color: Colors.white)
                  ),
                  onPressed: (){ resetField(); },
                ),
              ],
            ),
            Container(
              child: _functionAnswer,
            ),
          ],
        );
      }
      else{
        _displayer=new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Enter comma separated values for Y:',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4),),
            TextField(
              autofocus: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(5, 10, 0, 0),
              ),
              controller: _controlY,
            ),
            Text('\nEnter step size:',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4),),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(5, 10, 0, 0),
              ),
              controller: _controlSS,
            ),
            Text('\nEnter precision:',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4),),
            TextField(
              controller: _precision,
              decoration: InputDecoration(hintText: '(2 by default)',contentPadding: EdgeInsets.fromLTRB(5, 10, 0, 0),),
              
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  elevation: 10.0,
                  color: Colors.deepPurpleAccent,
                  child: Text('Calculate', 
                    style: TextStyle(color: Colors.white)
                  ),
                  onPressed: (){ calculate('D'); },
                ),
                RaisedButton(
                  elevation: 10.0,
                  color: Colors.red,
                  child: Text('Reset', 
                    style: TextStyle(color: Colors.white)
                  ),
                  onPressed: (){ resetField(); },
                ),
              ],
            ),
            Container(
              child: _discreteAnswer,
            ),
          ],
        );
      }
    });
  }
  void calculate(String ch){
    reset();
    precision=(_precision.text.length==0)?2:num.parse(_precision.text);
    double h=(_controlSS.text.contains('/'))? double.parse(_controlSS.text.substring(0,_controlSS.text.indexOf('/')))/double.parse(_controlSS.text.substring(_controlSS.text.indexOf('/')+1)):double.parse(_controlSS.text);
    h=double.parse(h.toStringAsFixed(precision));
    print(h);
    if(ch=='D'){
      List<String> yVal=_controlY.text.split(',');
      yVal.forEach((f)=>Y.add(double.parse(f))); 
    }
    else if(ch=='F'){
      double eval=0;
      double lb=num.parse(double.parse(_controlLB.text).toStringAsFixed(precision));
      double ub=num.parse(double.parse(_controlUB.text).toStringAsFixed(precision));
      //print(lb);
      //print(ub);
      //print(h);
      int rot=((ub-lb)/h).round();
      print(rot);
      Variable x=new Variable('x');
      Parser p=new Parser();
      Expression ex=p.parse(func);
      ContextModel cm=new ContextModel();
      for(int i=0;i<=rot;i++){
        cm.bindVariable(x, new Number(lb+(i*h)));
        eval=ex.evaluate(EvaluationType.REAL,cm);
        Y.add(double.parse(eval.toStringAsFixed(precision)));
      }
      print(Y);
    }
    double trapezoid = Y[0]+Y[Y.length-1];
    for(int i=1;i<Y.length-1;i++) trapezoid+=(2*Y[i]); 
    trapezoid*=(h/2);
    _trapezoid=trapezoid.toStringAsFixed(precision);
    if((Y.length-1) % 2 == 0){
      double simp13 = Y[0]+Y[Y.length-1];
      for(int i=1;i<Y.length-1;i+=2) simp13+=(4*Y[i]);
      for(int i=2;i<Y.length-1;i+=2) simp13+=(2*Y[i]);
      simp13*=(h/3);
      _simp13=simp13.toStringAsFixed(precision);
    }else _simp13='NA';
    if((Y.length-1) % 3 == 0){
      double simp38 = Y[0]+Y[Y.length-1];
      for(int i=3;i<Y.length-1;i+=3) simp38+=(2*Y[i]);
      for(int i=1;i<Y.length-1;i++) if(i%3!=0) simp38+=(3*Y[i]);
      simp38*=((3*h)/8);
      _simp38=simp38.toStringAsFixed(precision);
    }else _simp38='NA';
    if(ch=='D') discreteAnswer();
    else functionAnswer();
  }
  void resetField(){
    _controlFunc.clear(); Y.clear();
    _controlLB.clear(); _controlSS.clear(); 
    _controlY.clear(); func=""; _controlUB.clear();
    startBracket=false; bracket=0; _precision.clear();
    setState(() {
      _discreteAnswer=null;
      _functionAnswer=null;
    });
  }
  void functionAnswer(){
    setState(() {
      _functionAnswer=new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('\n\nBy Trapezoidal Rule: $_trapezoid',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4),),
          Text('By Simpson\'s 1/3 Rule: $_simp13',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4),),
          Text('By Simpson\'s 3/8 Rule: $_simp38',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4),),
        ],
      );
    });
  }
  void discreteAnswer(){
    setState(() {
      _discreteAnswer=new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('\n\nBy Trapezoidal Rule: $_trapezoid',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4),),
          Text('By Simpson\'s 1/3 Rule: $_simp13',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4),),
          Text('By Simpson\'s 3/8 Rule: $_simp38',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4),),
        ],
      );
    });
  }
  void reset(){
    Y.clear();
    _trapezoid=null;
    _simp13=null;
    _simp38=null;
  }

  void _showKeyboard(context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Enter f(x):',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('|x|'),
                  onPressed: (){
                    setState(() { func+='abs('; startBracket=true; bracket++;});
                  },
                ),
                RaisedButton(
                  child: Text('exp'),
                  onPressed: (){
                    setState(() { func+='e^('; startBracket=true; bracket++; });
                  },
                ),
                RaisedButton(
                  child: Text('sqrt'),
                  onPressed: (){
                    setState(() { func+='sqrt('; startBracket=true; bracket++; });
                  },
                ),
                RaisedButton(
                  child: Text('C',style: TextStyle(color: Colors.red),),
                  onPressed: (){
                    setState(() { func=func.substring(0,func.length-1); });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('sin'),
                  onPressed: (){
                    setState(() { func+='sin('; startBracket=true; bracket++;});
                  },
                ),
                RaisedButton(
                  child: Text('cos'),
                  onPressed: (){
                    setState(() { func+='cos('; startBracket=true; bracket++;});
                  },
                ),
                RaisedButton(
                  child: Text('tan'),
                  onPressed: (){
                    setState(() { func+='tan('; startBracket=true; bracket++;});
                  },
                ),
                RaisedButton(
                  child: Text('x',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4 ,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontFamily: 'Serif'),),
                  onPressed: (){
                    setState(() { func+='x'; });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('arcsin'),
                  onPressed: (){
                    setState(() { func+='arcsin('; startBracket=true; bracket++;});
                  },
                ),
                RaisedButton(
                  child: Text('arccos'),
                  onPressed: (){
                    setState(() { func+='arccos('; startBracket=true; bracket++;});
                  },
                ),
                RaisedButton(
                  child: Text('arctan'),
                  onPressed: (){
                    setState(() { func+='arctan('; startBracket=true; bracket++;});
                  },
                ),
                RaisedButton(
                  child: Text('/'),
                  onPressed: (){
                    setState(() { func+='/'; });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('ln'),
                  onPressed: (){
                    setState(() { func+='ln('; startBracket=true; bracket++;});
                  },
                ),
                RaisedButton(
                  child: Text('log'),
                  onPressed: (){
                    setState(() { func+='log(10,'; startBracket=true; bracket++;});
                  },
                ),
                RaisedButton(
                  child: Text('^'),
                  onPressed: (){
                    setState(() { func+='^('; startBracket=true; bracket++;});
                  },
                ),
                RaisedButton(
                  child: Text('*'),
                  onPressed: (){
                    setState(() { func+='*'; });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('1'),
                  onPressed: (){
                    setState(() { func+='1'; });
                  },
                ),
                RaisedButton(
                  child: Text('2'),
                  onPressed: (){
                    setState(() { func+='2'; });
                  },
                ),
                RaisedButton(
                  child: Text('3'),
                  onPressed: (){
                    setState(() { func+='3'; });
                  },
                ),
                RaisedButton(
                  child: Text('-'),
                  onPressed: (){
                    setState(() { func+='-'; });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('4'),
                  onPressed: (){
                    setState(() { func+='4'; });
                  },
                ),
                RaisedButton(
                  child: Text('5'),
                  onPressed: (){
                    setState(() { func+='5'; });
                  },
                ),
                RaisedButton(
                  child: Text('6'),
                  onPressed: (){
                    setState(() { func+='6'; });
                  },
                ),
                RaisedButton(
                  child: Text('+'),
                  onPressed: (){
                    setState(() { func+='+'; });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('7'),
                  onPressed: (){
                    setState(() { func+='7'; });
                  },
                ),
                RaisedButton(
                  child: Text('8'),
                  onPressed: (){
                    setState(() { func+='8'; });
                  },
                ),
                RaisedButton(
                  child: Text('9'),
                  onPressed: (){
                    setState(() { func+='9'; });
                  },
                ),
                RaisedButton(
                  child: Text('( )'),
                  onPressed: (){
                    setState(() { 
                      //print(startBracket);
                      if(startBracket==false){
                        func+='('; ++bracket; //print(bracket);
                        startBracket=true;
                      }
                      else{
                        func+=')'; --bracket; //print(bracket);
                      }
                      if(bracket==0) startBracket=false;
                      //print(startBracket);
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text(','),
                  onPressed: (){
                    setState(() { func+=','; });
                  },
                ),
                RaisedButton(
                  child: Text('0'),
                  onPressed: (){
                    setState(() { func+='0'; });
                  },
                ),
                RaisedButton(
                  child: Text('.'),
                  onPressed: (){
                    setState(() { func+='.'; });
                  },
                ),
                RaisedButton(
                  color: Colors.greenAccent,
                  child: Text('DONE',style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    setState(() { Navigator.pop(bc); });
                  },
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}