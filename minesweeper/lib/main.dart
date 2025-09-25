import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper/game_board_builder.dart';
import 'package:minesweeper/minesweeper_engine.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(30.0),
          child: Center(
            child: GameBoard(rows: 20, columns: 15),
          ),
        ),
      ),
    );
  }
}

class GameBoard extends StatelessWidget {
  const GameBoard({required this.rows, required this.columns, super.key});

  final int rows;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSquareWidth = constraints.maxWidth / columns;
        final maxSquareHeight = constraints.maxHeight / rows;
        final squareSize = min(maxSquareWidth, maxSquareHeight);

        final builder = GameBoardBuilder(
          squareSize: squareSize,
          constraints: Size(
            squareSize * columns,
            squareSize * rows,
          ),
          rows: rows,
          columns: columns,
        );

        return Center(
          child: SizedBox.fromSize(
            size: builder.constraints,
            child: _GameBoardInner(builder),
          ),
        );
      },
    );
  }
}

class _GameBoardInner extends StatefulWidget {
  const _GameBoardInner(this.builder);

  final GameBoardBuilder builder;

  @override
  State<_GameBoardInner> createState() => _GameBoardInnerState();
}

class _GameBoardInnerState extends State<_GameBoardInner> {
  late final MinesweeperEngine engine;

  @override
  initState() {
    super.initState();
    engine = MinesweeperEngine(
      rows: widget.builder.rows,
      columns: widget.builder.columns,
      difficulty: Difficulty.easy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: engine,
      builder: (context, _) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (details) {
            final coords = widget.builder.getRowColumnForCoordinates(
              details.localPosition,
            );
            engine.clickedCoordinates(coords);
          },
          child: Stack(
            children: <Widget>[
              ...verticalLines(),
              ...horizontalLines(),
              ...borderWidgets(),
              ...revealedSquares(),
              // ...drawMines(),
            ],
          ),
        );
      },
    );
  }

  Iterable<Widget> revealedSquares() sync* {
    for (final coords in engine.revealedLocations) {
      if (engine.mineLocations.contains(coords)) {
        yield widget.builder
            .getCoordsContentsPosition(coords)
            .toWidget(
              Center(
                child: Text('M', style: TextStyle(color: Colors.red)),
              ),
            );
        continue;
      }

      final countOfMines = engine.adjacentMineCounts[coords]!;
      if (countOfMines == 0) {
        yield widget.builder
            .getFillSquarePosition(coords)
            .toWidget(Container(color: Colors.yellow[300]!));
      } else {
        yield widget.builder
            .getCoordsContentsPosition(coords)
            .toWidget(
              Center(
                child: Text(
                  '$countOfMines',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
      }
    }
  }

  Iterable<Widget> drawMines() sync* {
    for (final coords in engine.mineLocations) {
      yield widget.builder
          .getCoordsContentsPosition(coords)
          .toWidget(
            Center(
              child: Text('M', style: TextStyle(color: Colors.red)),
            ),
          );
    }
  }

  Iterable<Widget> verticalLines() sync* {
    for (int i = 0; i < widget.builder.columns; i++) {
      yield widget.builder
          .verticalLinePosition(i)
          .toWidget(
            Container(color: Colors.grey[400]),
          );
    }
  }

  Iterable<Widget> horizontalLines() sync* {
    for (int i = 0; i < widget.builder.rows; i++) {
      yield widget.builder
          .horizontalLinePosition(i)
          .toWidget(
            Container(color: Colors.grey[400]),
          );
    }
  }

  List<Widget> borderWidgets() {
    return [
      // Left border
      widget.builder.leftBorderPosition().toWidget(
        Container(color: Colors.grey[700]),
      ),
      // Top border
      widget.builder.topBorderPosition().toWidget(
        Container(color: Colors.grey[700]),
      ),
      // Bottom border
      widget.builder.bottomBorderPosition().toWidget(
        Container(color: Colors.grey[700]),
      ),
      // Right border
      widget.builder.rightBorderPosition().toWidget(
        Container(color: Colors.grey[700]),
      ),
    ];
  }
}
