import 'dart:io';
import 'dart:math';
import 'character.dart';

class Monster {
  final String name;
  int hp;
  final int maxAttack;
  int attack;
  int defense = 0;
  int _turnCounter = 0;

  Monster(this.name, this.hp, this.maxAttack, int characterDefense)
    : attack = max(characterDefense, Random().nextInt(maxAttack) + 1);

  void attackCharacter(Character character) {
    int damage = attack - character.defense;
    if (damage < 0) damage = 0;
    character.hp -= damage;
    print(' $name의 공격! ${character.name}에게 $damage 데미지를 입혔습니다.');
    _increaseDefense();
  }

  void _increaseDefense() {
    _turnCounter++;
    if (_turnCounter % 3 == 0) {
      defense += 2;
      print(' $name의 방어력이 증가했습니다! 현재 방어력: $defense');
    }
  }

  void showStatus() {
    print(' $name | 체력: $hp | 공격력: $attack | 방어력: $defense');
  }

  bool isAlive() => hp > 0;
}

List<Monster> loadMonsters() {
  try {
    final file = File('monsters.txt');
    final contents = file.readAsStringSync();
    final lines = contents.split('\n');
    List<Monster> monsters = [];

    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      final parts = line.split(',');
      if (parts.length != 3) continue;

      final name = parts[0].trim();
      final hp = int.parse(parts[1].trim());
      final maxAttack = int.parse(parts[2].trim());

      monsters.add(Monster(name, hp, maxAttack, 0));
    }

    return monsters;
  } catch (e) {
    print(' 몬스터 불러오기 실패: $e');
    exit(1);
  }
}
