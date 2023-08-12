import "package:flutter/material.dart";
import 'dart:math';


class Grafo{
  late int line;
  late int column;
  late String composition;
  late bool check;
  late int? value;
  late String? player;

  Grafo(this.line, this.column, this.composition, this.check, {this.value, this.player});
}

class GamePage extends StatefulWidget{
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>{
  static const String Player_1 = 'Player 1';
  static const String Player_2 = 'Player 2';

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  late List<List<Grafo>> graph = [];
  late int gameSize;

  late var containerColumn;

  static const styleText = TextStyle(
              color: Colors.green,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            );

  @override
  void initState() {
    initializeGame();
    super.initState();
  }
  void initializeGame(){
    currentPlayer = Player_1;
    gameSize = 5;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""]; //9 empty places
    assembleGraph(); //Montando o grafo do jogo
  }

  void assembleGraph(){
    late List<List<Widget>> containerGraph = [];
    for(int i = 0; i < gameSize * 2 - 1; i++){
      graph.add([]);
      containerGraph.add([]);
      for(int j = 0; j < gameSize * 2 - 1; j++){
        if(i % 2 == 0){
          if(j % 2 == 0) {
            graph[i].add(Grafo(i, j, "vertex", true));
            containerGraph[i].add(_vertex());
          } else{
            graph[i].add(Grafo(i, j, "edgeH", false));
            containerGraph[i].add(_edgeH(graph[i][j]));
          }
        }
        if(i % 2 == 1){
          if(j % 2 == 0) {
            graph[i].add(Grafo(i, j, "edgeV", false));
            containerGraph[i].add(_edgeV(graph[i][j]));
          } else{
            graph[i].add(Grafo(i, j, "square", false, value: 1 + Random().nextInt(3)));
            containerGraph[i].add(_square(graph[i][j]));
          }
        }
      }
    }
    containerColumn = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        gameSize * 2 - 1,
        (i) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(
            gameSize * 2 -1, (j) => containerGraph[i][j]),
        )
      )
      );
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerText(),
            _turn(),
            _gameContainer(),
          ]),
      )
    );
  }

  Widget _headerText(){
    return Column(
          children: [
            const Text("Square Game", style: styleText,
            ),
            Text("vez do $currentPlayer", style: styleText,
            ),
          ],
        );
  }

  Widget _turn(){
    const textStyle = TextStyle( 
                color: Colors.white,
              );
    var p1Container = Container( 
      width: 100,
      height: 100,
      decoration: BoxDecoration(  
        color: currentPlayer == Player_2 ? 
        const Color.fromARGB(75, 68, 137, 255) : Colors.blue,
        border: Border.all(
          width: 5.0,
          color: Colors.black12
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Player 1",
            style: textStyle,
            ),
            Text( 
              "Pontos",
              style: textStyle,
            ),
            Text( 
              "0:0",
              style: textStyle,
            ),
        ],
      ),
    );
    var p2Container = Container( 
      width: 100,
      height: 100,
      decoration: BoxDecoration(  
        color: currentPlayer == Player_1 ? 
        const Color.fromARGB(122, 255, 214, 64) : Colors.amber,
        border: Border.all(
          width: 5.0,
          color: Colors.black12
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Player 2",
            style: textStyle,
            ),
            Text( 
              "Pontos",
              style: textStyle,
            ),
            Text( 
              "0:0",
              style: textStyle,
            ),
        ],
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [p1Container, p2Container],
    );
  }

  Widget _gameContainer(){
    return Container(
      height: MediaQuery.of(context).size.height/2,
      width: MediaQuery.of(context).size.height/2,
      margin: const EdgeInsets.all(8),
      child: containerColumn
      );
  }

  Widget _vertex(){
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  Widget _edgeH(Grafo e){
    return InkWell( 
        onTap: (){
          setState(() {
            if(!e.check && !gameEnd){
              e.check = true;
              checkSquareTopBot(e);
              assembleGraph();
              changeTurn();
            }
          });
        },
        child: Container(
        width: 45,
        height: 45/6,
        decoration: BoxDecoration(
          color: e.check? Colors.black87 : Colors.black12,
        ),
      )
    );
  }

  Widget _edgeV(Grafo e){
    return InkWell( 
        onTap: (){
          setState(() {
            e.check = true;
            checkSquareLeftRight(e);
            assembleGraph();
            changeTurn();
          });
        },
        child: Container(
        width: 45/6,
        height: 45,
        decoration: BoxDecoration(
          color: e.check? Colors.black : Colors.black12,
        ),
      )
    );
  }

  Widget _square(Grafo s){
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: !s.check? 
        Colors.black87 : s.player == 'Player 1' ? 
        Colors.blue : Colors.amber,
      ),
      child: Center(
        child: Text(
          '${s.value}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
        ),
      ),
    );
  }

  checkSquareTopBot(Grafo e){
    print(e.line);
    if(!(e.line - 1 < 0)){
      if(graph[e.line][e.column].check && graph[e.line - 1][e.column - 1].check
      && graph[e.line - 1][e.column + 1].check && graph[e.line - 2][e.column].check
      ){
        if(!graph[e.line - 1][e.column].check){
          graph[e.line - 1][e.column].check = true;
          graph[e.line - 1][e.column].player = currentPlayer;
        }
      }
    }
    if(!(e.line + 1 > gameSize * 2 - 2)){
      if(graph[e.line][e.column].check && graph[e.line + 1][e.column - 1].check
      && graph[e.line + 1][e.column + 1].check && graph[e.line + 2][e.column].check
      ){
        if(!graph[e.line + 1][e.column].check){
          print("aqui");
          graph[e.line + 1][e.column].check = true;
          graph[e.line + 1][e.column].player = currentPlayer;
        }
      }
    }
  }

  checkSquareLeftRight(Grafo e){
    if(!(e.column - 1 < 0)){
      if(graph[e.line][e.column].check && graph[e.line - 1][e.column - 1].check
      && graph[e.line + 1][e.column - 1].check && graph[e.line][e.column - 2].check
      ){
        if(!graph[e.line][e.column - 1].check){
          graph[e.line][e.column - 1].check = true;
          graph[e.line][e.column - 1].player = currentPlayer;
        }
      }
    }
    if(!(e.column + 1 > gameSize * 2 - 2)){
      if(graph[e.line][e.column].check && graph[e.line - 1][e.column + 1].check
      && graph[e.line + 1][e.column + 1].check && graph[e.line][e.column + 2].check
      ){
        if(!graph[e.line][e.column + 1].check){
          graph[e.line][e.column + 1].check = true;
          graph[e.line][e.column + 1].player = currentPlayer;
        }
      }
    }
  }

  changeTurn(){
    if(currentPlayer == Player_1){
      currentPlayer = Player_2;
    } else{
      currentPlayer = Player_1;
    }
    // checkForWinner();
  }
  
  // checkForWinner(){
  //    List<List<int>> WinningList = [
  //     [0, 1, 2],
  //     [3, 4, 5],
  //     [6, 7, 8],
  //     [0, 3, 6],
  //     [1, 4, 7],
  //     [2, 5, 8],
  //     [0, 4, 8],
  //     [2, 4, 6],
  //    ];

  //    for(var winningPos in WinningList){
  //     String playerPosition0 = occupied[winningPos[0]];
  //     String playerPosition1 = occupied[winningPos[1]];
  //     String playerPosition2 = occupied[winningPos[2]];

  //     if(playerPosition0.isNotEmpty){
  //       if(playerPosition0 == playerPosition1 && playerPosition0 == playerPosition2){
  //         showGameOverMessage("Player $playerPosition0 Won");
  //         gameEnd = true;
  //         return;
  //       }
  //     }
  //    }
  // }

  // showGameOverMessage(String message){
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Game Over \n $message", 
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //           fontSize: 20,
  //         )
  //       )
  //     )
  //   );
  // }
}