import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //todo make these options
  int xCount = 7;
  int yCount = 7;
  GridItem _gridItem = GridItem("");
  List<GridItem> _gridCoordinates = [];

  @override
  void initState() {
    _createGrid();
    super.initState();
  }

  void _createGrid() {
    final List _alphabet =
      ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
    for(var y=1; y<=yCount; y++) {
      for(var x=0; x<xCount; x++) {
        _gridCoordinates.add(GridItem("${_alphabet[x]}$y"));
      }
    }
    _nextGridRef();
  }

  void _nextGridRef() {
    if(isComplete()) return;
    GridItem newGridItem = (_gridCoordinates.where((element) => !element.used).toList()..shuffle()).first;
    newGridItem.used = true;
    setState(() {
      _gridItem = newGridItem;
    });
  }

  void _reset() {
    _gridCoordinates.forEach((element) => element.used = false);
    _nextGridRef();
  }

  bool isComplete() => _gridCoordinates.where((element) => !element.used).isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'The next grid reference is:',
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: Text(
                '${_gridItem.reference}',
                key: ValueKey(_gridItem.reference),
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Text(
              '${_gridCoordinates.where((element) => element.used).toList().length} turns taken',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text(
              '${_gridCoordinates.where((element) => !element.used).toList().length} turns remaining',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: xCount, mainAxisSpacing: 1.0, crossAxisSpacing: 1.0,),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: _gridCoordinates.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _GridItemBox(gridItem: _gridCoordinates[index]);
                  }),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isComplete() ? _reset : _nextGridRef,
        child: isComplete() ? Icon(Icons.refresh) : Icon(Icons.skip_next),
      ),
    );
  }
}

class GridItem {
  final String reference;
  bool used;

  GridItem(this.reference, {this.used = false});
}

class _GridItemBox extends StatelessWidget {
  final GridItem gridItem;
  const _GridItemBox({Key key, this.gridItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(gridItem.used),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
          color: gridItem.used ? Colors.green : Colors.black12,
        ),
        child: Center(child: Text(gridItem.reference, style: TextStyle(fontWeight: FontWeight.bold))),
      ),
    );
  }
}

