import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "result";
  Game game = Game();
  bool isSwitched = false;

  _onTap(int index) async {
    if ((!Player.playerO.contains(index) || Player.playerO.isEmpty) &&
        (!Player.playerX.contains(index) || Player.playerX.isEmpty)) {
      game.playGame(index, activePlayer);
      updateState();

      if (!isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    return setState(() {
      activePlayer = activePlayer == "X" ? "O" : "X";
      turn++;

      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != "") {
        gameOver = true;
        result = "$winnerPlayer is the winner!";
      } else if (!gameOver && turn == 9) {
        result = "It's Draw";
      }
    });
  }

  void resetGame() {
    setState(() {
      activePlayer = "X";
      gameOver = false;
      turn = 0;
      result = "";
      Player.playerO = [];
      Player.playerX = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [
                  ..._firstBlock(),
                  const SizedBox(height: 30),
                  _expanded(context),
                  ..._lastBlock(),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [..._firstBlock(), ..._lastBlock()],
                    ),
                  ),
                  _expanded(context)
                ],
              ),
      ),
    );
  }

  List<Widget> _firstBlock() {
    return [
      SwitchListTile.adaptive(
          title: const Text(
            "Turn on/off two players",
            style: TextStyle(color: Colors.white, fontSize: 28),
            textAlign: TextAlign.center,
          ),
          value: isSwitched,
          onChanged: (bool newValue) {
            setState(() {
              isSwitched = newValue;
            });
          }),
      const SizedBox(height: 40),
      Text(
        "It's $activePlayer turn".toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 52),
        textAlign: TextAlign.center,
      )
    ];
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio:
            MediaQuery.of(context).orientation == Orientation.landscape
                ? 1.2
                : 1.0,
        children: List.generate(
            9,
            (index) => InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: gameOver ? null : () => _onTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        Player.playerX.contains(index)
                            ? Player.x
                            : Player.playerO.contains(index)
                                ? Player.o
                                : Player.empty,
                        style: TextStyle(
                          color: Player.playerX.contains(index)
                              ? Colors.blue
                              : Colors.pink,
                          fontSize: 52,
                        ),
                      ),
                    ),
                  ),
                )),
      ),
    );
  }

  List<Widget> _lastBlock() {
    return [
      Text(
        result,
        style: const TextStyle(color: Colors.white, fontSize: 42),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: resetGame,
        icon: const Icon(Icons.replay),
        label: const Text("repeat the game"),
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).splashColor),
        ),
      )
    ];
  }
}
