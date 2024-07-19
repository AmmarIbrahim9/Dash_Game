import 'model/player.dart';
import 'model/properties.dart';

import 'model/card.dart'; // Import your card class

class GameLogic {
  List<Player> players;
  List<Property> properties;
  List<GameCard> chanceCards;
  List<GameCard> communityChestCards;
  int currentPlayerIndex;
  int doublesRolled;

  GameLogic(this.players, this.properties, this.chanceCards, this.communityChestCards)
      : currentPlayerIndex = 0, doublesRolled = 0;

  Player get currentPlayer => players[currentPlayerIndex];

  void rollDice() {
    // Simplified dice rolling for demonstration
    int dice1 = (1 + (5 * (new DateTime.now().microsecond % 1000000) / 1000000)).toInt();
    int dice2 = (1 + (5 * (new DateTime.now().microsecond % 1000000) / 1000000)).toInt();

    // Example implementation of doubles rule
    if (dice1 == dice2) {
      doublesRolled++;
      if (doublesRolled == 3) {
        sendToJail();
        return;
      }
    } else {
      doublesRolled = 0;
    }

    // Update player position
    currentPlayer.position = (currentPlayer.position + dice1 + dice2) % properties.length;
    handleLandOnSpace();
  }

  void handleLandOnSpace() {
    var property = properties[currentPlayer.position];
    if (property.isOwned && property.owner != currentPlayer) {
      payRent();
    } else if (!property.isOwned) {
      // Option to buy the property
    } else if (property.name.contains("Chance")) {
      drawCard(CardType.chance); // Draw a chance card
    } else if (property.name.contains("Community Chest")) {
      drawCard(CardType.communityChest); // Draw a community chest card
    } else if (property.name.contains("Go To Jail")) {
      sendToJail();
    }
  }

  void nextPlayer() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    doublesRolled = 0;
  }

  void buyProperty() {
    var property = properties[currentPlayer.position];
    if (!property.isOwned && currentPlayer.money >= property.price) {
      currentPlayer.money -= property.price;
      property.isOwned = true;
      property.owner = currentPlayer;
    }
  }

  void payRent() {
    var property = properties[currentPlayer.position];
    if (property.isOwned && property.owner != currentPlayer) {
      currentPlayer.money -= property.rent!;
      property.owner?.money += property.rent!;
    }
  }

  void drawCard(CardType type) {
    List<GameCard> cardList = type == CardType.chance ? chanceCards : communityChestCards;
    if (cardList.isNotEmpty) {
      GameCard card = cardList.removeAt(0); // Draw the top card
      card.action(); // Execute the card's action
      cardList.add(card); // Put the card back at the bottom
    }
  }

  void buyHouse() {
    var property = properties[currentPlayer.position];
    if (property.isOwned && property.owner == currentPlayer && property.houses < 4 && !property.hasHotel) {
      int housePrice = property.housePrice;
      if (currentPlayer.money >= housePrice) {
        currentPlayer.money -= housePrice;
        property.houses += 1;
        property.rent = (property.rent! * 2); // Example rent increase
      }
    }
  }

  void buyHotel() {
    var property = properties[currentPlayer.position];
    if (property.isOwned && property.owner == currentPlayer && property.houses == 4 && !property.hasHotel) {
      int hotelPrice = property.hotelPrice;
      if (currentPlayer.money >= hotelPrice) {
        currentPlayer.money -= hotelPrice;
        property.houses = 0;
        property.hasHotel = true;
        property.rent = (property.rent! * 2); // Example rent increase
      }
    }
  }

  void handleJail() {
    if (currentPlayer.jailTurns < 3) {
      currentPlayer.jailTurns++;
      nextPlayer();
    } else {
      currentPlayer.inJail = false;
      currentPlayer.jailTurns = 0;
      rollDice();
    }
  }

  void sendToJail() {
    currentPlayer.inJail = true;
    currentPlayer.position = properties.indexWhere((property) => property.name == "Jail");
    nextPlayer();
  }
}
