import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    title: 'My app', // used by the OS task switcher
    home: MainMenu(),
  ));
}
List<dynamicWidget> dynamicList = <dynamicWidget>[];
List<PopUp> PopUpList = <PopUp>[];

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body:Stack( children:
          [Container(
          decoration: BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.fill,
        image:AssetImage('assets/images/menu.jpg'),             //сюда картинку
      ),
          ),
          ),
      Positioned(
        left:MediaQuery. of(context). size. width/4,
        top:MediaQuery. of(context). size. height*47/100,
        child:ButtonTheme(
          minWidth: MediaQuery. of(context). size. width/2,
          height: MediaQuery. of(context). size. height/15*2,
        child: RaisedButton(
          child: Text('Start Game'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        )
      ),
          ]
      ),
    );
  }
}



class dynamicWidget extends StatefulWidget {
  Key key = UniqueKey();
  //Key key = Key(dynamicList.length.toString());
  int _start = 10;
  Offset posit= Offset(Random().nextInt(300).toDouble(),Random().nextInt(600).toDouble() );  /////


  dynamicWidget(int start) {
    this._start = start;
  }

  @override
  _dynamicWidget createState() => new _dynamicWidget(_start,key);
}

class _dynamicWidget extends State<dynamicWidget>{
  String pic = 'assets/images/short';
  double width = 210.0, height = 210.0;
  Offset position;
  Timer _timer;
  int _start = 10;
  Key _key;

  _dynamicWidget(int start, Key key) {
    this._key = key;
    this._start = start;
  }

  @override
  void initState() {
    if(Random().nextInt(2)==1) {width=300; height=150;pic = 'assets/images/long';}
    pic += Random().nextInt(3).toString()+'.jpg';
    position = dynamicList[dynamicList.indexWhere((element) => element.key==_key)].posit;
    //position = Offset( (MediaQuery.of(context).size.height)/2,(MediaQuery.of(context).size.width)/2);
    startTimer();
  }
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            _timer.cancel();
          } else {
            _start = _start - 1;
            dynamicList[dynamicList.indexWhere((element) =>element.key==_key)]._start=_start;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      //key:Key(dynamicList.length.toString()),
      left: position.dx,
      top: position.dy ,
      child: Draggable(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:AssetImage(pic),
            ),
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 8,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          width: width,
          height: height,
          child: Text("$_start", style: Theme.of(context).textTheme.headline,textAlign: TextAlign.end),
          //child: Center(child: Text("$_start"),),
        ),
        feedback:  Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:AssetImage(pic),
            ),
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 8,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          width: width,
          height: height,
          child: Text("??", style: Theme.of(context).textTheme.headline,textAlign: TextAlign.end),
          //child: Center(child: Text("??", style: Theme.of(context).textTheme.headline,),),
        ),
        childWhenDragging: Container(),
        onDraggableCanceled: (Velocity velocity, Offset offset){
          setState(() => position = offset);
          dynamicList[dynamicList.indexWhere((element) => element.key==_key)].posit=position;
        },
        maxSimultaneousDrags: 1,
      ),
    );
  }

}

class PopUp extends StatefulWidget{
  int count = 5;
  double size = 50;
  @override
  _PopUp createState() => new _PopUp(count,size);
}

class _PopUp extends State<PopUp>{

  _PopUp(int count, double size) {
    this.count = count;
    this.size = size;
    this.diff= ((size-15)/count).round();
  }
  int diff;
  int count;
  double size;
  //int diff = ((size-15)/count).round();
  @override
  Widget build(BuildContext context) {
    return  Positioned(
      left: 0,
      top: 0,
      width:  MediaQuery. of(context). size. width,
      height: MediaQuery. of(context). size. height,
      child:Stack( children:
      [Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image:AssetImage('assets/images/canyou.jpg'),             //сюда картинку
          ),
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 8,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
        Positioned(
            left: (MediaQuery. of(context). size. width-70)*Random().nextDouble(),
            top: (MediaQuery. of(context). size. height-70)*Random().nextDouble(),
            width: size,
            height: size,
            child: FloatingActionButton(
              onPressed:(){
                count--;
                if(count==0){
                  dynamicList.clear();
                  PopUpList.removeLast();
                  Navigator.pop(context);
                }
                else setState(() {});
                size-=diff;
                //PopUpList.removeLast();
                },
            )
        ),
      ]
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int min = 5;
  Timer _timer;
  void startTimer() {
    //await Future.delayed( Duration(seconds: _start), (){});
    const oneSec = const Duration(milliseconds: 100);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer)  {
        if(PopUpList.isEmpty){_timer.cancel();dynamicList.clear();}
        if(Random().nextInt(4)==0) dynamicList.add(new dynamicWidget(min+ Random().nextInt(15)));           /////тут вероятность
        setState(() {
          dynamicList.removeWhere((item) => item._start == 0);
        });
      },
    );
  }

  @override
  void initState() {
    startTimer();
    PopUpList.add(new PopUp());
  }

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    return new WillPopScope(
      child: new Scaffold(
        body: Stack(
          children: [
            Stack(
              children: PopUpList,
            ),
            Stack(
              children: dynamicList,
            )
          ],
          //children: dynamicList,
        ),
        /* floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10.0,
            right: 0.0,
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                    startTimer();
                  // for(int i=0;i<10;i++) PopUpList.add(new PopUp());          //
                    PopUpList.add(new PopUp());
              },
              child: Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 30,
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                _timer.cancel();
                setState(() {
                   dynamicList.clear();
                   PopUpList.clear();
                });
              },
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),*/
        /*floatingActionButton: new FloatingActionButton(
          onPressed: (){
            setState(() {
              dynamicList.add(new dynamicWidget());
            });
          },
            child:new Icon(Icons.add)
        )*/
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}