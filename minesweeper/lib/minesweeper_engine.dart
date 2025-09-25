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
      adjacentMineCounts[coords] = _getAdjacentMines(coords);
    }
  }

  void clickedCoordinates(Coords coords) {
    if (revealedLocations.contains(coords)) {
      return;
    }
    revealedLocations.add(coords);

    if (adjacentMineCounts[coords] == 0) {
      _revealAdjacent(coords);
    }

    notifyListeners();
  }

  void _revealAdjacent(Coords coords) {
    final queue = <Coords>[..._getAdjacentCoords(coords)];
    final visited = <Coords>{coords};

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      if (visited.contains(current) || revealedLocations.contains(current)) {
        continue;
      }

      visited.add(current);
      revealedLocations.add(current);

      if (adjacentMineCounts[current] == 0) {
        queue.addAll(_getAdjacentCoords(current));
      }
    }
  }

  Iterable<Coords> get allCoords sync* {
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        yield Coords(row: row, column: column);
      }
    }
  }

  int _getAdjacentMines(Coords coords) {
    int adjacentMines = 0;
    for (final adjacentCoords in _getAdjacentCoords(coords)) {
      if (mineLocations.contains(adjacentCoords)) {
        adjacentMines++;
      }
    }
    return adjacentMines;
  }

  Iterable<Coords> _getAdjacentCoords(Coords coords) sync* {
    for (int rowDelta = -1; rowDelta <= 1; rowDelta++) {
      for (int columnDelta = -1; columnDelta <= 1; columnDelta++) {
        if (rowDelta == 0 && columnDelta == 0) {
          continue;
        }

        final adjacentRow = coords.row + rowDelta;
        final adjacentColumn = coords.column + columnDelta;

        if (adjacentRow >= 0 &&
            adjacentRow < rows &&
            adjacentColumn >= 0 &&
            adjacentColumn < columns) {
          yield Coords(row: adjacentRow, column: adjacentColumn);
        }
      }
    }
  }
}
