
import 'package:flutter/material.dart';
import 'package:game/custom_dialogue.dart';
import 'package:game/game_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<GameButton> buttonList;
  var player1;
  var player2;
  var activePlayer;

  @override
  void initState() {
    super.initState();
    buttonList = doInit();
    activePlayer = 1; // Initialize active player
  }

  List<GameButton> doInit() {
    player1 = [];
    player2 = [];
    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = 'X';
        gb.bg = Colors.blue;
        activePlayer = 2;
        player1.add(gb.id);
      } else {
        gb.text = 'O';
        gb.bg = Colors.black;
        activePlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      
      var winner = checkWinner();
      if (winner == -1) {
        if (buttonList.every((p) => p.text != "")) {
          showDialog(
            context: context,
            builder: (_) => CustomDialogue(
              "Game Tied",
              "Please press the reset button to start",
              resetGame,
            ),
          );
        }
      }
      
      if (winner != -1) {
        if (winner == 1) {
          showDialog(
            context: context,
            builder: (_) => CustomDialogue(
              "Player 1 Won",
              "Please press the reset button to start",
              resetGame,
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => CustomDialogue(
              "Player 2 Won",
              "Please press the reset button to start",
              resetGame,
            ),
          );
        }
      }
    });
  }

  int checkWinner() {
    var winner = -1;
    // Row checks
    for (int i = 0; i < 3; i++) {
      if (player1.contains(i * 3 + 1) &&
          player1.contains(i * 3 + 2) &&
          player1.contains(i * 3 + 3)) {
        winner = 1;
      }
      if (player2.contains(i * 3 + 1) &&
          player2.contains(i * 3 + 2) &&
          player2.contains(i * 3 + 3)) {
        winner = 2;
      }
    }
    // Column checks
    for (int i = 0; i < 3; i++) {
      if (player1.contains(i + 1) &&
          player1.contains(i + 4) &&
          player1.contains(i + 7)) {
        winner = 1;
      }
      if (player2.contains(i + 1) &&
          player2.contains(i + 4) &&
          player2.contains(i + 7)) {
        winner = 2;
      }
    }
    // Diagonal checks
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }
    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    return winner;
  }

  void resetGame() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    setState(() {
      buttonList = doInit();
      activePlayer = 1; // Reset the active player
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Tic Tac Toe",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xfff6921e), Color(0xffee4036)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 65.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 9.0,
                  ),
                  itemCount: buttonList.length,
                  itemBuilder: (context, index) => SizedBox(
                    width: 100,
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: buttonList[index].enabled
                            ? () => playGame(buttonList[index])
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonList[index].bg,
                          disabledBackgroundColor: buttonList[index].bg,
                        ),
                        child: Text(
                          buttonList[index].text,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: resetGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Color of the button
                ),
                child: const Text(
                  'Reset Game',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 20), // Add some spacing
            ],
          ),
        ),
      ),
    );
  }
}

