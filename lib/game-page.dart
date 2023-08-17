import "package:flutter/material.dart";
import 'package:responsive_styles/breakpoints/breakpoints.dart';
import 'dart:math';
import 'dart:async';

import 'package:responsive_styles/responsive/responsive.dart';

class Grafo {
  late int line;
  late int column;
  late String composition;
  late bool check;
  late int? value;
  late String? player;

  Grafo(this.line, this.column, this.composition, this.check,
      {this.value, this.player});
}

class Player {
  late String name;
  late int score;
  late int index;
  late Time time;
  late Color color;

  Player(this.name, this.score, this.index, this.time, this.color);
}

class Time {
  late int timeRemaining;
  late String clock;

  Time(this.timeRemaining, this.clock);
}

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Timer time;

  late Player Player_1;
  late Player Player_2;

  late String currentPlayer;
  late bool gameEnd;
  late bool gameStart;
  late bool pause;
  late List<String> occupied;

  late List<List<Grafo>> graph;
  late int gameSize;

  late var containerColumn;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    Player_1 = Player(
        'Player 1', 0, 1, Time(181, ""), Color.fromARGB(255, 220, 20, 60));
    Player_2 = Player(
        'Player 2', 0, 2, Time(180, ""), Color.fromARGB(255, 26, 187, 66));
    graph = [];
    currentPlayer = Player_1.name;
    gameSize = 6;
    gameStart = false;
    gameEnd = true;
    pause = false;
    assembleGraph(); //Montando o grafo do jogo
  }

  void startTimer() {
    time = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (Player_1.time.timeRemaining > 0 &&
            Player_2.time.timeRemaining > 0 &&
            !gameEnd &&
            !pause) {
          currentPlayer == Player_1.name
              ? Player_1.time.timeRemaining--
              : Player_2.time.timeRemaining--;
          Player_1.time.clock =
              '${(Player_1.time.timeRemaining / 60).toInt()}:${Player_1.time.timeRemaining % 60}';
          Player_2.time.clock =
              '${(Player_2.time.timeRemaining / 60).toInt()}:${Player_2.time.timeRemaining % 60}';
        } else {
          time.cancel();
          gameEnd = true;
          if (Player_1.time.timeRemaining <= 0)
            showGameOverMessage("${Player_1.name} Wins!");
          else if (Player_2.time.timeRemaining <= 0)
            showGameOverMessage("${Player_2.name} Wins!");
        }
      });
    });
  }

  void assembleGraph() {
    late List<List<Widget>> containerGraph = [];
    for (int i = 0; i < gameSize * 2 - 1; i++) {
      graph.add([]);
      containerGraph.add([]);
      for (int j = 0; j < gameSize * 2 - 1; j++) {
        if (i % 2 == 0) {
          if (j % 2 == 0) {
            graph[i].add(Grafo(i, j, "vertex", true));
            containerGraph[i].add(_vertex());
          } else {
            graph[i].add(Grafo(i, j, "edgeH", false));
            containerGraph[i].add(_edgeH(graph[i][j]));
          }
        }
        if (i % 2 == 1) {
          if (j % 2 == 0) {
            graph[i].add(Grafo(i, j, "edgeV", false));
            containerGraph[i].add(_edgeV(graph[i][j]));
          } else {
            graph[i].add(
                Grafo(i, j, "square", false, value: 1 + Random().nextInt(3)));
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
                      gameSize * 2 - 1, (j) => containerGraph[i][j]),
                )));
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var gameColumn =
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      gameStart ? _turn(responsive) : _headerText(),
      gameStart ? _gameContainer(responsive) : _contentHome()
    ]);
    var xsColumn =
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      gameStart ? _turn(responsive) : _headerText(),
      gameStart ? _gameContainer(responsive) : _contentHome(),
      gameStart
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _containerPlayer(Player_1, Player_2),
                _containerPlayer(Player_2, Player_1)
              ],
            )
          : Container()
    ]);
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 38, 34, 40),
        body: Center(
            child: responsive.value({
          Breakpoints.xl: gameColumn,
          Breakpoints.lg: gameColumn,
          Breakpoints.md: gameColumn,
          Breakpoints.sm: gameColumn,
          Breakpoints.xs: xsColumn
        })));
  }

  Widget _headerText() {
    return Column(
      children: [
        const Text(
          "Squaro Game",
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontFamily: 'Squarea',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _contentHome() {
    var btnStart = ElevatedButton(
      onPressed: () {
        setState(() {
          gameEnd = false;
          gameStart = true;
          startTimer();
          updateGraph();
        });
      },
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(255, 20, 17, 27),
        onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      ),
      child:
          Text("START", style: TextStyle(fontSize: 20, fontFamily: 'Squarea')),
    );

    return Center(
      child: btnStart,
    );
  }

  Widget _turn(Responsive responsive) {
    var p1Container = _containerPlayer(Player_1, Player_2);
    var p2Container = _containerPlayer(Player_2, Player_1);
    var textMid = Text(
      "vez do $currentPlayer",
      style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Squarea'),
    );

    var playButton = IconButton(
        onPressed: () {
          setState(() {
            if (!gameEnd) {
              pause = false;
              startTimer();
              updateGraph();
            }
          });
        },
        iconSize: 50,
        color: Colors.white,
        icon: Icon(Icons.play_arrow));

    var pauseButton = IconButton(
        onPressed: () {
          setState(() {
            if (!gameEnd) {
              pause = true;
              updateGraph();
            }
          });
        },
        iconSize: 50,
        color: Colors.white,
        icon: Icon(Icons.pause));

    var refreshButton = IconButton(
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        iconSize: 50,
        color: Colors.white,
        icon: Icon(Icons.refresh));

    var rowButtons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [pause ? playButton : pauseButton, refreshButton],
    );

    var columnMid = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [textMid, rowButtons],
    );

    return responsive.value({
      Breakpoints.xl: columnMid,
      Breakpoints.lg: columnMid,
      Breakpoints.md: columnMid,
      Breakpoints.sm: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [p1Container, columnMid, p2Container]),
      Breakpoints.xs: columnMid
    });
  }

  Widget _containerPlayer(Player p1, Player p2) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: currentPlayer == p2.name ? p1.color.withOpacity(0.5) : p1.color,
        border: Border.all(width: 5.0, color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${p1.name}",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontFamily: 'Squarea'),
          ),
          Text(
            "${p1.score}",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontFamily: 'Squarea'),
          ),
          Text(
            "${p1.time.clock}",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontFamily: 'Squarea'),
          ),
        ],
      ),
    );
  }

  Widget _gameContainer(Responsive responsive) {
    var p1Container = _containerPlayer(Player_1, Player_2);
    var p2Container = _containerPlayer(Player_2, Player_1);
    var container = Container(
        height: 649 * (gameSize / 10),
        width: 649 * (gameSize / 10),
        margin: const EdgeInsets.all(8),
        child: containerColumn);
    return responsive.value({
      Breakpoints.xl: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [p1Container, container, p2Container]),
      Breakpoints.lg: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [p1Container, container, p2Container]),
      Breakpoints.md: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [p1Container, container, p2Container]),
      Breakpoints.sm: container,
      Breakpoints.xs: container
    });
  }

  Widget _vertex() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  Widget _edgeH(Grafo e) {
    return InkWell(
        onTap: () {
          setState(() {
            if (!e.check && !gameEnd && gameStart) {
              e.check = true;
              checkSquareTopBot(e);
              updateGraph();
              changeTurn();
            }
          });
        },
        child: Container(
          width: 45,
          height: 45 / 6,
          decoration: BoxDecoration(
            color: e.check ? Colors.white : Colors.black12,
          ),
        ));
  }

  Widget _edgeV(Grafo e) {
    return InkWell(
        onTap: () {
          setState(() {
            if (!e.check && !gameEnd && gameStart) {
              e.check = true;
              checkSquareLeftRight(e);
              updateGraph();
              changeTurn();
            }
          });
        },
        child: Container(
          width: 45 / 6,
          height: 45,
          decoration: BoxDecoration(
            color: e.check ? Colors.white : Colors.black12,
          ),
        ));
  }

  Widget _square(Grafo s) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: !s.check
            ? Colors.black87
            : s.player == 'Player 1'
                ? Player_1.color
                : Player_2.color,
      ),
      child: Center(
        child: Text(
          '${s.value}',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: 'Squarea'),
        ),
      ),
    );
  }

  updateGraph() {
    List<List<Widget>> containerGraph = [];
    for (int i = 0; i < graph.length; i++) {
      containerGraph.add([]);
      for (int j = 0; j < graph.length; j++) {
        if (i % 2 == 0) {
          if (j % 2 == 0) {
            containerGraph[i].add(_vertex());
          } else {
            containerGraph[i].add(_edgeH(graph[i][j]));
          }
        } else if (i % 2 == 1) {
          if (j % 2 == 0) {
            containerGraph[i].add(_edgeV(graph[i][j]));
          } else {
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
                      gameSize * 2 - 1, (j) => containerGraph[i][j]),
                )));
  }

  checkSquareTopBot(Grafo e) {
    if (!(e.line - 1 < 0)) {
      Grafo square = graph[e.line - 1][e.column];
      if (graph[e.line][e.column].check &&
          graph[e.line - 1][e.column - 1].check &&
          graph[e.line - 1][e.column + 1].check &&
          graph[e.line - 2][e.column].check) {
        if (!square.check) {
          square.check = true;
          square.player = currentPlayer;
          addScore(square);
        }
      }
    }
    if (!(e.line + 1 > gameSize * 2 - 2)) {
      Grafo square = graph[e.line + 1][e.column];
      if (graph[e.line][e.column].check &&
          graph[e.line + 1][e.column - 1].check &&
          graph[e.line + 1][e.column + 1].check &&
          graph[e.line + 2][e.column].check) {
        if (!square.check) {
          square.check = true;
          square.player = currentPlayer;
          addScore(square);
        }
      }
    }
  }

  checkSquareLeftRight(Grafo e) {
    if (!(e.column - 1 < 0)) {
      Grafo square = graph[e.line][e.column - 1];
      if (graph[e.line][e.column].check &&
          graph[e.line - 1][e.column - 1].check &&
          graph[e.line + 1][e.column - 1].check &&
          graph[e.line][e.column - 2].check) {
        if (!square.check) {
          square.check = true;
          square.player = currentPlayer;
          addScore(square);
        }
      }
    }
    if (!(e.column + 1 > gameSize * 2 - 2)) {
      Grafo square = graph[e.line][e.column + 1];
      if (graph[e.line][e.column].check &&
          graph[e.line - 1][e.column + 1].check &&
          graph[e.line + 1][e.column + 1].check &&
          graph[e.line][e.column + 2].check) {
        if (!square.check) {
          square.check = true;
          square.player = currentPlayer;
          addScore(square);
        }
      }
    }
  }

  addScore(Grafo s) {
    if (currentPlayer == Player_1.name)
      Player_1.score += s.value?.toInt() ?? 0;
    else if (currentPlayer == Player_2.name)
      Player_2.score += s.value?.toInt() ?? 0;
  }

  changeTurn() {
    if (currentPlayer == Player_1.name) {
      currentPlayer = Player_2.name;
    } else {
      currentPlayer = Player_1.name;
    }
    checkForWinner();
  }

  checkForWinner() {
    String message = "";

    bool checkGame =
        graph.every((row) => row.every((element) => element.check == true));

    if (checkGame) {
      message = Player_1.score > Player_2.score
          ? "${Player_1.name} Wins!"
          : Player_1.score == Player_2.score
              ? "Empate"
              : "${Player_2.name} Wins!";
      showGameOverMessage(message);
      gameEnd = true;
    }
  }

  showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Fim de Jogo \n $message",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontFamily: 'Squarea'))));
  }
}
