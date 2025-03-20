import 'dart:io';
import 'monster.dart';

class Character {
  final String name;
  int hp;
  final int baseAttack;
  final int defense;
  bool _itemUsed = false;

  Character(this.name, this.hp, this.baseAttack, this.defense);

  int get attack => _itemUsed ? baseAttack * 2 : baseAttack;

  void attackMonster(Monster monster) {
    int damage = attack - monster.defense;
    if (damage < 0) damage = 0;
    monster.hp -= damage;
    if (monster.hp < 0) monster.hp = 0;
    print(' $name의 공격! ${monster.name}에게 $damage 데미지');
    _itemUsed = false;
  }

  void useItem() {
    if (_itemUsed) {
      print(' 이미 아이템을 사용하였습니다.');
    } else {
      _itemUsed = true;
      print(' 아이템을 사용하여 공격력이 두 배로 증가합니다!');
    }
  }

  void defend(int damage) {
    hp += damage;
    print(' 방어 성공! 체력 $damage 회복 (현재 체력: $hp)');
  }

  void showStatus() {
    print(' $name | 체력: $hp | 공격력: $baseAttack | 방어력: $defense');
  }

  bool isAlive() => hp > 0;
}

Character loadCharacter(String name) {
  try {
    final file = File('characters.txt');
    final contents = file.readAsStringSync();
    final stats = contents.split(',');

    if (stats.length != 3) {
      throw FormatException('캐릭터 데이터 형식이 올바르지 않습니다.');
    }

    final hp = int.parse(stats[0].trim());
    final attack = int.parse(stats[1].trim());
    final defense = int.parse(stats[2].trim());

    return Character(name, hp, attack, defense);
  } catch (e) {
    print(' 캐릭터 불러오기 실패: $e');
    exit(1);
  }
}
