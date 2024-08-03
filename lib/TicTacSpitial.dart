import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tic_tac/constant.dart';

class TicTacSpatial extends StatefulWidget {
  const TicTacSpatial({super.key});

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacSpatial> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late List<String> list = ['X', 'O'];
  final _random = Random();
  late List<Point<int>> _xMoves;
  late List<Point<int>> _oMoves;
  late bool RuleOn=false;
  int NumOfSteps= 5;

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
          if (_xMoves.length > NumOfSteps) {
            _removeRandomMove(_xMoves);
          }
        } else {
          _oMoves.add(Point(row, col));
          if (_oMoves.length > NumOfSteps) {
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
        title: const Center(child: Text('Tic Tac Toe',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container( width: widthR(220, context),
                    height: heightR(20, context),
                    child: Text("Play with Rule",style: TextStyle(fontSize: sizeR(15, context),color: Colors.white,fontWeight: FontWeight.bold),)),
                Transform.scale(
                  scale: sizeR(0.8, context),
                  child: Switch(value: RuleOn, activeTrackColor: Color(0xff13a795),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey[300],
                      trackOutlineColor: MaterialStatePropertyAll(Colors.transparent),
                      onChanged: (value) {
                    setState(() {
                      RuleOn=!RuleOn;
                      RuleOn==false ? NumOfSteps=5 : NumOfSteps=3;
                      print(RuleOn);
                      print(NumOfSteps);
                    });
                      },
                  ),
                ),
              ],
            ),
            SizedBox(height: heightR(20, context),),
            _buildBoard(),
            const SizedBox(height: 20),
            _buildStatus(),
            const SizedBox(height: 20),
            _buildResetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return Container(
      decoration: const BoxDecoration(
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: const [
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
                              ? Colors.white
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
    );
  }

  Widget _buildStatus() {
    return Text(
      _winner == ''
          ? 'Current Player: $_currentPlayer'
          : _winner == 'Draw'
          ? 'It\'s a Draw!'
          : 'Winner: $_winner',
      style: const TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w500),
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff004038),
          fixedSize: Size(double.maxFinite, sizeR(48, context)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizeR(17, context)))
      ),
      onPressed: _resetGame,
      child: const Text('Restart Game',style: TextStyle(color: Colors.amber),),
    );
  }
}
