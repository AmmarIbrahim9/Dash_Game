class Player {
  String name;
  int position;
  int money;
  bool inJail;
  int jailTurns;

  Player(this.name, {this.position = 0, this.money = 1500, this.inJail = false, this.jailTurns = 0});
}
