import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/common/config.dart';

enum GameItemType {
  Player,
  Diamond,
  PowerupBasic,
  BlackHoleSmall,
  BlackHoleMedium,
  BlackHoleLarge,
  HorizontalWall,
  VerticalWall
}

@immutable
class GameItem {
  final GameItemType type;
  final int score;
  final double health;
  final Rect rect;

  const GameItem._(
    this.type,
    this.rect,
    this.score,
    this.health,
  );

  bool get isPickup => type == GameItemType.Diamond;
  bool get isWall =>
      type == GameItemType.VerticalWall || type == GameItemType.HorizontalWall;
  bool get isBlackhole =>
      type == GameItemType.BlackHoleSmall ||
      type == GameItemType.BlackHoleMedium ||
      type == GameItemType.BlackHoleLarge;

  @override
  String toString() {
    return '{ ${type.toString().substring(13)}: $rect }';
  }

  static GameItemType _getType(String shortID) {
    switch (shortID) {
      case 'd':
        return GameItemType.Diamond;
      case '+':
        return GameItemType.PowerupBasic;
      case 'o':
        return GameItemType.BlackHoleSmall;
      case 'O':
        return GameItemType.BlackHoleMedium;
      case '0':
        return GameItemType.BlackHoleLarge;
      case 'p':
        return GameItemType.Player;
      case '-':
        return GameItemType.HorizontalWall;
      case '|':
        return GameItemType.VerticalWall;
      default:
        throw new Exception('Unknown game item "$shortID"');
    }
  }

  static int _getScore(GameItemType type) {
    switch (type) {
      case GameItemType.Diamond:
        return Config.pickupScoreDiamond;
      case GameItemType.PowerupBasic:
        return 0;
      case GameItemType.BlackHoleSmall:
      case GameItemType.BlackHoleMedium:
      case GameItemType.BlackHoleLarge:
      case GameItemType.HorizontalWall:
      case GameItemType.VerticalWall:
      case GameItemType.Player:
        return 0;
      default:
        throw Exception('Unknown type $type');
    }
  }

  static double _getHealth(GameItemType type) {
    switch (type) {
      case GameItemType.Diamond:
        return 0;
      case GameItemType.BlackHoleSmall:
      case GameItemType.BlackHoleMedium:
      case GameItemType.BlackHoleLarge:
        return Config.healthDecBlackhole;
      case GameItemType.PowerupBasic:
        return Config.healthIncBasic;
      case GameItemType.HorizontalWall:
      case GameItemType.VerticalWall:
        return Config.wallHealthFactor;
      case GameItemType.Player:
        return 0;
      default:
        throw Exception('Unknown type $type');
    }
  }

  static Rect _getRect(int row, int col) {
    return Rect.fromLTRB(col.toDouble(), row.toDouble(), 1.0, 1.0);
  }

  static GameItem create(String shortID, int row, int col) {
    final type = _getType(shortID);
    final rect = _getRect(row, col);
    final score = _getScore(type);
    final health = _getHealth(type);

    return GameItem._(type, rect, score, health);
  }
}
