import "package:flutter/material.dart";

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
