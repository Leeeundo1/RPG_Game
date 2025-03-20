import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';

class Game {
  final Character character;
  final List<Monster> monsters;
  int defeatedCount = 0;
  final Random random = Random();

  Game(this.character, this.monsters);

  void startGame() {
    print('\n 게임을 시작합니다!\n');

    while (character.isAlive() && monsters.isNotEmpty) {
      Monster monster = getRandomMonster();
      print('\n 새로운 몬스터 등장!');
      monster.showStatus();
      character.showStatus();

      battle(monster);

      if (!character.isAlive()) {
        print('\n ${character.name}이(가) 쓰러졌습니다... 게임 오버!');
        saveResult('패배');
        return;
      }

      defeatedCount++;
      monsters.remove(monster);
      print('🎉 ${monster.name} 처치 완료! (남은 몬스터: ${monsters.length})');

      if (monsters.isEmpty) {
        print('모든 몬스터를 처치했습니다! 게임 승리!');
        saveResult('승리');
        return;
      }

      stdout.write('다음 몬스터와 싸우시겠습니까? (y/n): ');
      String? choice = stdin.readLineSync()?.toLowerCase();
      if (choice != 'y') {
        print(' 게임을 종료합니다.');
        saveResult('중도 종료');
        return;
      }
    }
  }

  void battle(Monster monster) {
    while (monster.isAlive() && character.isAlive()) {
      print('\n 행동 선택: [1] 공격하기 | [2] 방어하기 | [3] 아이템 사용');
      stdout.write('선택 > ');
      String? input = stdin.readLineSync();

      if (input == '1') {
        character.attackMonster(monster);
      } else if (input == '2') {
        character.defend(monster.attack);
      } else if (input == '3') {
        character.useItem();
        continue;
      } else {
        print(' 올바른 입력이 아닙니다.');
        continue;
      }

      if (monster.isAlive()) {
        monster.attackCharacter(character);
      }

      character.showStatus();
      monster.showStatus();
    }
  }

  Monster getRandomMonster() {
    return monsters[random.nextInt(monsters.length)];
  }

  void saveResult(String result) {
    stdout.write('\n 결과를 result.txt에 저장할까요? (y/n): ');
    String? input = stdin.readLineSync()?.toLowerCase();
    if (input == 'y') {
      final file = File('result.txt');
      file.writeAsStringSync(
        '이름: ${character.name}\n남은 체력: ${character.hp}\n결과: $result\n',
        mode: FileMode.write,
      );
      print(' 저장 완료: result.txt');
    } else {
      print(' 저장하지 않았습니다.');
    }
  }
}
