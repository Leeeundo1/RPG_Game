import 'dart:io';
import 'dart:math';
import '../lib/character.dart';
import '../lib/monster.dart';
import '../lib/game.dart';

void main() {
  print(' 전투 RPG 게임에 오신 걸 환영합니다!');
  stdout.write('캐릭터 이름을 입력하세요 (한글 또는 영문만 허용): ');

  String? input = stdin.readLineSync();
  if (input == null ||
      input.trim().isEmpty ||
      !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(input)) {
    print(' 올바르지 않은 이름입니다. 프로그램을 종료합니다.');
    return;
  }

  final name = input.trim();
  final character = loadCharacter(name);

  // 30% 확률로 체력 보너스
  if (Random().nextDouble() < 0.3) {
    character.hp += 10;
    print('보너스 체력을 얻었습니다! 현재 체력: ${character.hp}');
  }

  final monsters = loadMonsters();
  final game = Game(character, monsters);
  game.startGame();
}
