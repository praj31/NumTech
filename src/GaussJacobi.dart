import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';
import 'package:numerical_techniques/size_config.dart';

class GaussJacobi extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _GaussJacobi();
  }
}

class _GaussJacobi extends State<GaussJacobi>{
  String eqns; // to store the input of comma separated equations
  List<String> _eqns; // to store the list of equations split by comma
  bool noValue=false; // validator
  Column answers; // used to show answers after clicking Calculate
  String _ans; // to store the final answer in the string
  List<String> unk=new List<String>(); // store the list of unknowns
  List<List<double>> coeff=new List<List<double>>(); // store the list of coefficients {a[][]} matrix 
  List<double> res=new List<double>(); // store the list of b[] on equations
  List<double> temp=new List<double>(); // temporary list
  List<List<double>> _answer=new List<List<double>>(); // to store iterations
  final _controller1= TextEditingController(); // the equation input controller
  final _controller2= TextEditingController(); // the precision input controller
  int precision=3; // default precision count
  int iteration=0,iterCounter=0; // iterations: number of iterations(_answer.length), iterCounter is the count
  List<Variable> vars = new List<Variable>();
  List<Expression> eqn = new List<Expression>();
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
          title: Text('Gauss Jacobi Method'),
        ),
        body: ListView(
          children: <Widget>[
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Text('\nEnter equations separated by comma:', 
              textAlign: TextAlign.left,
            ),
            TextField(
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (term){ 
                  FocusNode().unfocus();
                  afterEqns();
                },
                decoration: InputDecoration(
                  hintText: 'E.g. 8x-y+2z=13,x-10y+3z=17,3x+2y+12z=25',
                  errorText: noValue?"Type a valid equation":null,
                  contentPadding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                ),   
                controller: _controller1, 
              ),    
            Text('\nEnter precision (fix upto d.p.):',textAlign: TextAlign.left,),
            TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              controller: _controller2,
              decoration: InputDecoration(contentPadding: EdgeInsets.fromLTRB(5,10,0,0),hintText: '3 (by default)'),
              onSubmitted: (term){FocusNode().unfocus(); },
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
            Card(
              child: answers, // called when changes are made
            ),           
          ]
        ),
          ]),
      ),
    );
  }

  void afterEqns(){
    eqns = _controller1.text; // stores input
    _eqns = eqns.split(","); // split input
    for(String i in _eqns) i=i.trim(); // trim for whitespaces
  }

  void calculate(){
    afterEqns(); // if user clicks calculate again
    resetAll(); // reset all functions before recalculation
    precision = (_controller2.text.length==0)?3:num.parse(_controller2.text); // change precision as per input
    String s=_eqns[0]; // store first equation entered
    for(int i=0;i<s.length;i++){ /* loop that extracts unknowns */
      int c = s.codeUnitAt(i);
      if(c>=97 && c<=122 || c>=65 && c<=90) unk.add(s[i]); // add it to unk list
    }
    int i=0; String unknown="",temp="";
    unk.forEach((f)=>vars.add(new Variable(f)));
    
    //To re-write the equations in a form necessary for conversion
    _eqns.forEach((f){
      if(!f.startsWith('-')) f = '+'+f;
      temp = "";
      unknown = unk[i];
      temp += '('+ f.substring(f.indexOf('=')+1);
      if(i==0){
        temp += f.substring(f.indexOf(unknown)+1,f.indexOf('=')).replaceAll('-', '*').replaceAll('+', '-').replaceAll('*', '+');
        temp += (')/'+ f.substring(0,f.indexOf(unknown)));
      }
      else if(i==unk.length-1){
        temp += f.substring(0,f.indexOf(unk[i-1])+1).replaceAll('-', '*').replaceAll('+', '-').replaceAll('*', '+');
        temp += (')/'+ f.substring(f.indexOf(unk[i-1])+1,f.indexOf(unknown)));
      }
      else{
        temp += f.substring(0,f.indexOf(unk[i-1])+1).replaceAll('-', '*').replaceAll('+', '-').replaceAll('*', '+');
        temp += f.substring(f.indexOf(unknown)+1,f.indexOf('=')).replaceAll('-', '*').replaceAll('+', '-').replaceAll('*', '+');
        temp += (')/'+ f.substring(f.indexOf(unk[i-1])+1,f.indexOf(unknown)));
      }
      if(temp.endsWith('+') || temp.endsWith('-')) temp+='1';
      if(temp.endsWith('/')) temp=temp.substring(0,temp.length-1);
      if(temp.substring(temp.indexOf('/')+1).startsWith('+')) temp = temp.substring(0,temp.indexOf('/')+1) + temp.substring(temp.indexOf('/')+2);
      for(int i=0;i<temp.length-1;i++){
        if((temp.codeUnitAt(i)>=48 && temp.codeUnitAt(i)<=57) && (temp.codeUnitAt(i+1)>=97 && temp.codeUnitAt(i+1)<=122)){
          temp = temp.substring(0,i+1)+'*'+temp.substring(i+1);
        }
      }
      _eqns[i] = temp;
      i++;
    });
    print(_eqns);
    Parser p=new Parser();
    ContextModel cm=new ContextModel();
    _eqns.forEach((f)=>eqn.add(p.parse(f)));
    List<double> func=new List<double>(unk.length);
    List<double> temp2=new List<double>(unk.length);
    temp2.fillRange(0,temp2.length,0);
    func.fillRange(0, func.length,0); 
    double check=0; // flag for continuing iterations, initially zero
    do{
      for(int j=0;j<unk.length;j++){
          if(j!=i) cm.bindVariable(vars[j], new Number(temp2[j]));
      }
      for(int i=0;i<unk.length;i++){ 
        func[i]= eqn[i].evaluate(EvaluationType.REAL,cm);
        func[i]=double.parse(func[i].toStringAsFixed(precision)); 
      }
      print(func);
      _answer.add(func.toList()); // add the iteration[i] values to _answer
      check=(func[0]-temp2[0]).abs(); // update check flag
      print('check: $check');
      for(int i=0;i<unk.length;i++) temp2[i]=func[i]; // transfer func[] values to temp2[] for next iteration
      func.fillRange(0,func.length,0); // refill func to 0, similar to flushing for new input
    } while (check>(1/pow(10, precision)));
    print(_answer);
    iteration=_answer.length; // stores the number of iterations

    makeChanges(); // once calculations have concluded, call the makeChanges method to display them
  }

  void makeChanges(){ // reverts back to answer<Widget> for displaying answers
    setState(() {
      _ans=_answer[iterCounter].toString().split(',').join('\n'); // store the iteration[i] as string joined by \n
      _ans=' '+_ans.substring(1,_ans.length-1); // remove '[' and ']' left out in previous step
      String finalAns = _answer[iteration-1].toString().split(',').join('\n'); // store last iteration as string joined by \n
      finalAns = ' '+finalAns.substring(1,finalAns.length-1); // remove '[' and ']' left out in previous step
      if(eqns==null){ // validation condition for improper input
        if(eqns.length<1){
          if(eqns.contains(' ') || eqns.contains(';') || eqns.contains('/')) noValue=true; // true if there is error
        }
      }
      else{  
        noValue=false; // default it back to false
        answers=new Column( // <Widget> to be returned
          children: <Widget>[
            Container(
              child: Text('Iteration (${iterCounter+1}/$iteration)',style: TextStyle(fontSize: 18)),
            ),
            ListTile(
              title: Text('$_ans'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){ backButtonState(); },
                  
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: (){ frontButtonState(); },
                ),
              ],
            ),
            Container(
              child: Text('Final Answer',style: TextStyle(fontSize: 18)),
            ),
            ListTile(
              title: Text(finalAns),
            ),
          ],
        );
      }
    });
  }

  void resetField(){ // resetting fields of input, precision
    noValue=false; precision=3;
    setState(() {
      answers=null;
    });
    _controller1.clear(); _controller2.clear();
    eqns=null;
  }

  double sum(List<double> li,List<double> temp, int n){ /* function returning evaluated function expression */
    double ans=0; int i=0; // initial variables
    li.forEach((f){ ans+=(f*temp[i++]*-1); }); // calculates and sums coeff*value in unknown for each equation
    ans-=(coeff[n][n]*temp[n]*-1); // counter balancing for extra term
    return -ans; // return after balancing sign
  }

  void resetAll(){ // clear all the used arrays for new set of inputs. Invoked by Reset button.
    unk.clear(); res.clear(); coeff.clear(); temp.clear();
    _answer.clear();
    iterCounter=0; iteration=0;
  }

  void backButtonState(){ /* decrease iterCounter with back button */
    setState(() {
      if(iterCounter>0) --iterCounter; 
      makeChanges();
    });
  }
  
  void frontButtonState(){ /* increase iterCounter with fwd button */
    setState(() {
      if(iterCounter<iteration-1) ++iterCounter;
      makeChanges();
    }); 
  }
}
