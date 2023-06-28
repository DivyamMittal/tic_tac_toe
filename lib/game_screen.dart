// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/homepage_screen.dart';

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;
  const GameScreen({super.key, required this.player1, required this.player2});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _board = List.generate(3, (_) => List.generate(3, (_) => ""));
    _currentPlayer = "X";
    _winner = "";
    _gameOver = false;
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ""));
      _currentPlayer = "X";
      _winner = "";
      _gameOver = false;
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] != "" || _gameOver) {
      return;
    }

    setState(() {
      _board[row][col] = _currentPlayer;

      // check for the winner
      if (_board[row][0] == _currentPlayer &&
          _board[row][1] == _currentPlayer &&
          _board[row][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][col] == _currentPlayer &&
          _board[1][col] == _currentPlayer &&
          _board[2][col] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][0] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][2] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][0] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      }

      // switch players
      _currentPlayer = _currentPlayer == "X" ? "O" : "X";

      // check for a tie
      if (!_board.any((row) => row.any((cell) => cell == ""))) {
        _gameOver = true;
        _winner = "It's a tie";
      }

      if (_winner != "") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          btnOkText: "Play Again",
          title: _winner == "X"
              ? "${widget.player1} Won!"
              : _winner == "O"
                  ? "${widget.player2} Won!"
                  : "Its a tie",
          btnOkOnPress: () {
            _resetGame();
          },
        ).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF323D5B),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 70,
          ),
          SizedBox(
            height: 120,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Turn: ",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    _currentPlayer == "X"
                        ? "${widget.player1} ($_currentPlayer)"
                        : "${widget.player2} ($_currentPlayer)",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            _currentPlayer == "X" ? Colors.red : Colors.blue),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: Color(0xFF5F6B84),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            child: GridView.builder(
              padding: EdgeInsets.all(3),
              itemCount: 9,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                int row = index ~/ 3;
                int col = index % 3;
                return GestureDetector(
                  onTap: () => _makeMove(row, col),
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Color(0xFF0E1E3A),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        _board[row][col],
                        style: TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.bold,
                            color: _board[row][col] == "X"
                                ? Colors.red
                                : Colors.blue),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: _resetGame,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                  child: const Text(
                    "Reset",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                  child: const Text(
                    "Restart",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
