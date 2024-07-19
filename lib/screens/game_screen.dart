// lib/screens/game_screen.dart

import 'package:flutter/material.dart';
import '../gamelogic.dart';
import '../model/player.dart';
import '../model/properties.dart';

import '../model/card.dart' as CustomCards; // Rename import to avoid conflicts

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic gameLogic;

  @override
  void initState() {
    super.initState();
    List<Player> players = [Player('Player 1'), Player('Player 2')];
    List<Property> properties = List.generate(
      40,
          (index) => Property('Property $index', 100 + index * 10, 10 + index, housePrice: 50, hotelPrice: 200),
    );
    List<CustomCards.GameCard> chanceCards = [
      CustomCards.GameCard(type: CustomCards.CardType.chance, description: 'Advance to Go', action: () {
        gameLogic.currentPlayer.position = 0;
      }),
      CustomCards.GameCard(type: CustomCards.CardType.chance, description: 'Go to Jail', action: () {
        gameLogic.sendToJail();
      }),
    ];
    List<CustomCards.GameCard> communityChestCards = [
      CustomCards.GameCard(type: CustomCards.CardType.communityChest, description: 'Bank error in your favor', action: () {
        gameLogic.currentPlayer.money += 200;
      }),
      CustomCards.GameCard(type: CustomCards.CardType.communityChest, description: 'Doctor\'s fees', action: () {
        gameLogic.currentPlayer.money -= 50;
      }),
    ];

    gameLogic = GameLogic(players, properties, chanceCards.cast<CustomCards.GameCard>(), communityChestCards.cast<CustomCards.GameCard>());
  }

  void rollDice() {
    setState(() {
      gameLogic.rollDice();
      gameLogic.payRent();
    });
  }

  void buyProperty() {
    setState(() {
      gameLogic.buyProperty();
    });
  }

  void buyHouse() {
    setState(() {
      gameLogic.buyHouse();
    });
  }

  void buyHotel() {
    setState(() {
      gameLogic.buyHotel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monopoly Game'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (context, index) {
                var property = gameLogic.properties[index];
                return Container(
                  margin: EdgeInsets.all(2.0),
                  color: property.isOwned ? Colors.green[200] : Colors.blue[100],
                  child: Center(
                    child: Text(property.name),
                  ),
                );
              },
              itemCount: gameLogic.properties.length,
            ),
          ),
          ElevatedButton(
            onPressed: rollDice,
            child: Text('Roll Dice'),
          ),
          ElevatedButton(
            onPressed: buyProperty,
            child: Text('Buy Property'),
          ),
          ElevatedButton(
            onPressed: buyHouse,
            child: Text('Buy House'),
          ),
          ElevatedButton(
            onPressed: buyHotel,
            child: Text('Buy Hotel'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: gameLogic.players.map((player) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(player.name),
                    Text('Position: ${player.position}'),
                    Text('Money: \$${player.money}'),
                    Text('In Jail: ${player.inJail ? 'Yes' : 'No'}'),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
