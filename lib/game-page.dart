import "package:flutter/material.dart";
import 'dart:math';


class Grafo{
  late int line;
  late int column;
  late String composition;
  late bool check;
  late int? value;

  Grafo(this.line, this.column, this.composition, this.check, [this.value]);
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
  static const int gameSize = 5;

  late var containerColumn;


  var vertex = Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(50),
    ),
  );

  var edgeH = InkWell( 
      onTap: (){
        print("edgeH");
      },
      child: Container(
      width: 45,
      height: 45/6,
      decoration: BoxDecoration(
        color: Colors.black38,
      ),
    )
  );

  var edgeV = InkWell( 
      onTap: (){
        print("edgeV");
      },
      child: Container(
      width: 45/6,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.black38,
      ),
    )
  );

  var square = Container(
    width: 45,
    height: 45,
    decoration: BoxDecoration(
      color: Colors.black87,
    ),
  );

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
            containerGraph[i].add(vertex);
          } else{
            graph[i].add(Grafo(i, j, "edgeH", false));
            containerGraph[i].add(edgeH);
          }
        }
        if(i % 2 == 1){
          if(j % 2 == 0) {
            graph[i].add(Grafo(i, j, "edgeV", true));
            containerGraph[i].add(edgeV);
          } else{
            graph[i].add(Grafo(i, j, "square", false,  1 + Random().nextInt(3)));
            containerGraph[i].add(square);
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

  Widget _gameContainer(){
    return Container(
      height: MediaQuery.of(context).size.height/2,
      width: MediaQuery.of(context).size.height/2,
      margin: const EdgeInsets.all(8),
      child: containerColumn
      );
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