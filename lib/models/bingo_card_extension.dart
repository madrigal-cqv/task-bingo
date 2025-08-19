import 'package:quickstart/models/bingo_card.dart';

extension BingoCardExtension on BingoCard {
  // helper to calculate the end time of the bingo card
  static calculateEndTime(String duration, DateTime curr) {
    switch (duration) {
      case "d":
        return curr.add(const Duration(days: 1));
      case "w":
        return curr.add(const Duration(days: 7));
      case "m":
        return curr.add(const Duration(days: 30));
    }
    return curr;
  }
}
