import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numerical_techniques/size_config.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';

class RegulaFalsi extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RegulaFalsi();
  }
}

class _RegulaFalsi extends State<RegulaFalsi>{
  bool startBracket=false;
  int bracket=0;
  double A,B;
  String func="";
  String answer="";
  final _precision= TextEditingController();
  int precision=2;
  Column _functionAnswer;
  //List<String> iter=new List<String>();
  List<int> iter=new List<int>();
  List<String> xVal=new List<String>();
  List<String> fx=new List<String>();
  List<String> intvl=new List<String>();
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
          title: Text('Regula Falsi Method'),
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
    xVal.add('x'); fx.add('f(x)'); intvl.add('Interval');
    precision=(_precision.text.length==0)?2:num.parse(_precision.text);
    double eval=0;
    Variable x=new Variable('x');
    Parser p=new Parser();
    Expression ex=p.parse(func);
    ContextModel cm=new ContextModel();   
    int i=0; double check=0,a,b,old; bool repeat=true;
    if(func.contains('ln') || func.contains('log')) i=1;
    //print('$i');
    while(repeat){
      cm.bindVariable(x, new Number(i));
      eval=ex.evaluate(EvaluationType.REAL,cm);
      print('$i --> $eval');
      if(eval<0){ a=i.toDouble();}
      else{ b=i.toDouble();}
      i++;
      if(a==null || b==null) continue;
      if((a-b).abs()==1) repeat=false;
    }
    bool rev=false;
    if(a>b){
      a=a+b;
      b=a-b;
      a=a-b;
      rev=true;
    }
    A=a; B=b;
    print('Root Lies in [$a , $b]');
    old=(a+b)/2;
    check=old;
    i=1; double fa,fb,numm;
    do{
      print(i);
      cm.bindVariable(x, new Number(a));
      fa=ex.evaluate(EvaluationType.REAL,cm);
      cm.bindVariable(x, new Number(b));
      fb=ex.evaluate(EvaluationType.REAL,cm);
      numm=((a*fb)-(b*fa))/(fb-fa);
      cm.bindVariable(x, new Number(numm));
      eval=ex.evaluate(EvaluationType.REAL,cm);
      print(eval);
      if(rev){
        if(eval>0) a=numm;
        else b=numm;
      }else{
        if(eval<0) a=numm;
        else b=numm;
      }

      print('[$a , $b]');
      //answer+="$i\t${numm.toStringAsFixed(precision+2)}\t${eval.toStringAsFixed(precision+2)}\n";
      iter.add(i);
      xVal.add(numm.toStringAsFixed(precision+2));
      fx.add(eval.toStringAsFixed(precision+2));
      intvl.add('[${a.toStringAsFixed(precision+2)} -- ${b.toStringAsFixed(precision+2)}]');
      if(i>1){ check=(old-numm).abs(); old=numm;}
      //print(check);
      i++;
    }while(check>=(2/pow(10, precision+1)));
    //print(answer);
    setState(() {
      _functionAnswer=new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('\nRoot lies in [$A , $B]'),
          Text('\nIteration Table\n',textAlign: TextAlign.center,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text('\n '+iter.toString().split(',').join('\n').substring(1,iter.toString().split(',').join('\n').length-1),textAlign: TextAlign.center,),
                  
                ),
                VerticalDivider(),
                Container(
                  child: Text(' '+xVal.toString().split(',').join('\n').substring(1,xVal.toString().split(',').join('\n').length-1),textAlign: TextAlign.center,),
                ),
                VerticalDivider(),
                Container(
                  child: Text(' '+fx.toString().split(',').join('\n').substring(1,fx.toString().split(',').join('\n').length-1),textAlign: TextAlign.center,),
                ),
                VerticalDivider(),
                Container(
                  child: Text(' '+intvl.toString().split(',').join('\n').substring(1,intvl.toString().split(',').join('\n').length-1),textAlign: TextAlign.center,),
                ),
              ],
            ),
          ),
          Text('$answer'),
        ],
      );
    });
  }
  void resetField(){
    func=""; answer="";
    startBracket=false; bracket=0; _precision.clear();
    setState(() {  _functionAnswer=null; });
  }
  void reset(){
    answer=""; intvl.clear(); xVal.clear(); fx.clear(); iter.clear();
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
                    child: Text('|x|'),
                    onPressed: (){
                      setState(() { func+='abs('; startBracket=true; bracket++;});
                    },
                  ),
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