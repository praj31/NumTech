import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numerical_techniques/size_config.dart';
import 'package:math_expressions/math_expressions.dart';

class Euler extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Euler();
  }
}

class _Euler extends State<Euler>{
  bool startBracket=false;
  int bracket=0;
  String func="";
  //String answer="";
  final _precision= TextEditingController();
  final _controlx0= TextEditingController();
  final _controly0= TextEditingController();
  final _controlxn= TextEditingController();
  final _controlSS= TextEditingController();
  int precision=3;
  Column _functionAnswer;
  List<double> answers=new List<double>();
  List<String> yVal=new List<String>();
  @override
  Widget build(BuildContext context){
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
          automaticallyImplyLeading: true,
          leading: IconButton(icon:Icon(Icons.arrow_back), onPressed:() => Navigator.pop(context,true),),
          title: Text('Euler\'s Method'),
        ),
        body: ListView(
          children: <Widget>[
            Column(
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
                    Text('x0:'),
                    Container(
                      width: SizeConfig.blockSizeHorizontal*10,
                      height: SizeConfig.blockSizeVertical*2.5,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration( contentPadding: EdgeInsets.only(bottom: 6)),
                        controller: _controlx0,
                      ),
                    ),
                    Text('y0:'),
                    Container(
                      width: SizeConfig.blockSizeHorizontal*10,
                      height: SizeConfig.blockSizeVertical*2.5,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration( contentPadding: EdgeInsets.only(bottom: 6)),
                        controller: _controly0,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('xN:'),
                    Container(
                      width: SizeConfig.blockSizeHorizontal*10,
                      height: SizeConfig.blockSizeVertical*2.5,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration( contentPadding: EdgeInsets.only(bottom: 6)),
                        controller: _controlxn,
                      ),
                    ),
                    Text('Step size:'),
                    Container(
                      width: SizeConfig.blockSizeHorizontal*10,
                      height: SizeConfig.blockSizeVertical*2.5,
                      child: TextField(
                        textAlign: TextAlign.center,
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
                  decoration: InputDecoration(hintText: '(3 by default)',contentPadding: EdgeInsets.fromLTRB(5, 10, 0, 0),),
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
                      onPressed: (){ calculate(); },
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
            ),
          ],
        ),
      ),
    );
  }
  void calculate(){
    reset();
    //xVal.add('x'); fx.add('f(x)'); intvl.add('f \'(x)');
    precision=(_precision.text.length==0)?3:num.parse(_precision.text);
    double x0=num.parse(double.parse(_controlx0.text).toStringAsFixed(precision));
    double xn=num.parse(double.parse(_controlxn.text).toStringAsFixed(precision));
    double y0=num.parse(double.parse(_controly0.text).toStringAsFixed(precision));
    double h=(_controlSS.text.contains('/'))? double.parse(_controlSS.text.substring(0,_controlSS.text.indexOf('/')))/double.parse(_controlSS.text.substring(_controlSS.text.indexOf('/')+1)):double.parse(_controlSS.text);
    h=double.parse(h.toStringAsFixed(precision));
    print(x0);print(y0);print(h);
    double eval=0;
    Variable x=new Variable('x');
    Variable y=new Variable('y');
    Parser p=new Parser();
    Expression ex=p.parse(func);
    ContextModel cm=new ContextModel();
    ex=ex.simplify();
    int rot = ((xn-x0)/h).round();
    print(rot);
    double a;
    answers.add(double.parse(y0.toStringAsFixed(precision)));
    yVal.add('y0 = ');
    for(int i=0;i<rot;i++){
      a = x0 + (i*h);
      print(a);
      cm.bindVariable(x, new Number(a));
      cm.bindVariable(y, new Number(answers[i]));
      eval=ex.evaluate(EvaluationType.REAL,cm);
      eval=answers[i]+(h*eval);
      answers.add(double.parse(eval.toStringAsFixed(precision)));
      yVal.add('y${i+1} = ');
    }
    //print(answers);
    
    setState(() {
      _functionAnswer=new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('\nIteration Table\n',textAlign: TextAlign.center,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(yVal.toString().split(',').join('\n').substring(1,yVal.toString().split(',').join('\n').length-1),textAlign: TextAlign.center,),
                ),
               // VerticalDivider(),
                Container(
                  child: Text(answers.toString().split(',').join('\n').substring(1,answers.toString().split(',').join('\n').length-1),textAlign: TextAlign.center,),
                  
                ),
              ],
            ),
          ),
          //Text('$answer'),
        ],
      );
    });
  }
  void resetField(){
    func=""; //answer=""; 
    startBracket=false; bracket=0; _precision.clear();
    _controlSS.clear(); _controlx0.clear(); _controlxn.clear(); _controly0.clear();
    setState(() {  _functionAnswer=null; });
  }
  void reset(){
    //=""; // intvl.clear(); xVal.clear(); fx.clear(); iter.clear();
    answers.clear(); yVal.clear();
  }
  void _showKeyboard(context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Enter f(x):',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4),),
            //SingleChildScrollView(
              //scrollDirection: Axis.horizontal,
              //child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('exp'),
                    onPressed: (){
                      setState(() { func+='e^('; startBracket=true; bracket++;});
                    },
                  ),
                  RaisedButton(
                    child: Text('sqrt'),
                    onPressed: (){
                      setState(() { func+='sqrt('; startBracket=true; bracket++;});
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
                  RaisedButton(
                  child: Text('C',style: TextStyle(color: Colors.red),),
                  onPressed: (){
                    setState(() { func=func.substring(0,func.length-1); });
                  },
                ),
                ],
              ),
           // ),
            //SingleChildScrollView(
            //  scrollDirection: Axis.horizontal,
            //  child: 
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.zero,
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
           // ),
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
                  child: Text('y',style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*4 ,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontFamily: 'Serif'),),
                  onPressed: (){
                    setState(() { func+='y'; });
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