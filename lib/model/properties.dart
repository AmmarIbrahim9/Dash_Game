import 'package:dash/model/player.dart';

class Property {
  String name;
  int price;
  int? rent;
  bool isOwned;
  Player? owner;
  int houses;
  bool hasHotel;
  int housePrice;
  int hotelPrice;

  Property(this.name, this.price, this.rent,
      {this.isOwned = false, this.owner, this.houses = 0, this.hasHotel = false, this.housePrice = 0, this.hotelPrice = 0});
}
