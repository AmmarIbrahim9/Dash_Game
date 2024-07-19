// lib/models/card.dart


enum CardType { chance, communityChest }

class GameCard {
  final CardType type;
  final String description;
  final Function action;

  GameCard({required this.type, required this.description, required this.action});
}
