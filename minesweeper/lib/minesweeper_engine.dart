import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:minesweeper/game_board_builder.dart';

enum Difficulty { easy, medium, hard }

class MinesweeperEngine extends ChangeNotifier {
  MinesweeperEngine({
    required this.rows,
    required this.columns,
    required this.difficulty,
  }) {
    _seedMines();
  }

  final int rows;
  final int columns;
  final Difficulty difficulty;

  final revealedLocations = <Coords>{};
  final mineLocations = <Coords>{};
  final adjacentMineCounts = <Coords, int>{};

  void _seedMines() {
    final numSquares = rows * columns;
    final int numMines = switch (difficulty) {
      Difficulty.easy => (numSquares * 0.25).floor(),
      Difficulty.medium => (numSquares * 0.32).floor(),
      Difficulty.hard => (numSquares * 0.4).floor(),
    };

    final coordsToHoldMines = allCoords.toList()..shuffle();
    mineLocations.addAll(coordsToHoldMines.sublist(0, numMines));

    for (final coords in allCoords) {
      adjacentMineCounts[coords] = getAdjacentMines(coords);
    }
  }

  void clickedCoordinates(Coords coords) {
    revealedLocations.add(coords);
    notifyListeners();
  }

  Iterable<Coords> get allCoords sync* {
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        yield Coords(row: row, column: column);
      }
    }
  }

  int getAdjacentMines(Coords coords) {
    int adjacentMines = 0;
    for (int rowDelta in rowAdjacencyIterator) {
      for (int columnDelta in columnAdjacencyIterator) {
        final adjacentCoords = Coords(
          row: coords.row + rowDelta,
          column: coords.column + columnDelta,
        );
        if (coords == adjacentCoords) {
          continue;
        }
        if (mineLocations.contains(adjacentCoords)) {
          adjacentMines++;
        }
      }
    }
    return adjacentMines;
  }

  Iterable<int> get rowAdjacencyIterator sync* {
    yield -1;
    yield 0;
    yield 1;
  }

  Iterable<int> get columnAdjacencyIterator sync* {
    yield -1;
    yield 0;
    yield 1;
  }
}
