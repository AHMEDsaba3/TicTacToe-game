import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class TicTacSpatial extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacSpatial> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late List<String> list = ['X', 'O'];
  final _random = new Random();
  late List<Point<int>> _xMoves;
  late List<Point<int>> _oMoves;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.filled(3, ''));
      _currentPlayer = list[_random.nextInt(list.length)];
      _winner = '';
      _xMoves = [];
      _oMoves = [];
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] == '' && _winner == '') {
      setState(() {
        _board[row][col] = _currentPlayer;
        if (_currentPlayer == 'X') {
          _xMoves.add(Point(row, col));
          if (_xMoves.length > 3) {
            _removeRandomMove(_xMoves);
          }
        } else {
          _oMoves.add(Point(row, col));
          if (_oMoves.length > 3) {
            _removeRandomMove(_oMoves);
          }
        }

        if (_checkWinner(row, col)) {
          _winner = _currentPlayer;
        } else if (_board.every((row) => row.every((cell) => cell != ''))) {
          _winner = 'Draw';
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  void _removeRandomMove(List<Point<int>> moves) {
    Point<int> toRemove = moves[_random.nextInt(moves.length)];
    setState(() {
      _board[toRemove.x][toRemove.y] = '';
      moves.remove(toRemove);
    });
  }

  bool _checkWinner(int row, int col) {
    // Check row
    if (_board[row].every((cell) => cell == _currentPlayer)) return true;
    // Check column
    if (_board.every((r) => r[col] == _currentPlayer)) return true;
    // Check diagonals
    if (row == col && _board.every((r) => r[_board.indexOf(r)] == _currentPlayer)) return true;
    if (row + col == 2 && _board.every((r) => r[2 - _board.indexOf(r)] == _currentPlayer)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(child: Text('Tic Tac Toe',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBoard(),
          SizedBox(height: 20),
          _buildStatus(),
          SizedBox(height: 20),
          _buildResetButton(),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: List.generate(3, (row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (col) {
                return GestureDetector(
                  onTap: () => _makeMove(row, col),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _board[row][col],
                          style: TextStyle(fontSize: 40,
                            color: _board[row][col] == 'X'
                                ? Colors.amber
                                : _board[row][col] == 'O'
                                ? Colors.tealAccent
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatus() {
    return Text(
      _winner == ''
          ? 'Current Player: $_currentPlayer'
          : _winner == 'Draw'
          ? 'It\'s a Draw!'
          : 'Winner: $_winner',
      style: TextStyle(fontSize: 24),
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: _resetGame,
      child: Text('Restart Game'),
    );
  }
}
