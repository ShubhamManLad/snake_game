import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/pixels/blank_pixel.dart';
import 'package:snake_game/pixels/dead_pixel.dart';
import 'package:snake_game/pixels/food_pixel.dart';
import 'package:snake_game/pixels/snake_pixel.dart';

class Game_Screen extends StatefulWidget {
  const Game_Screen({super.key});

  @override
  State<Game_Screen> createState() => _Game_ScreenState();
}

enum Direction { UP, DOWN, RIGHT, LEFT }

class _Game_ScreenState extends State<Game_Screen> {
  int rows = 10;
  int cols = 10;
  List<int> snake_position = [0, 1, 2];
  int food_position = 45;
  Direction snake_direction = Direction.RIGHT;
  bool isAlive = true;

  void start_game() {
    isAlive = true;

    snake_position = [0, 1, 2];
    food_position = 45;
    snake_direction = Direction.RIGHT;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        if(isAlive) {
          // Move snake
          moveSnake();
        }
        else{
          timer.cancel();
          showDialog(
              context: context,
              builder: (context){
                return Center(
                  child: GestureDetector(
                    onTap: (){
                      start_game();
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          child:Text('Game Over')
                        ),
                        Container(
                            child:Text('Score: ${snake_position.length}')
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      });
    });
  }

  void moveSnake(){
    switch (snake_direction) {
      case Direction.DOWN:
        moveDown();
        break;

      case Direction.LEFT:
        moveLeft();
        break;

      case Direction.UP:
        moveUp();
        break;

      case Direction.RIGHT:
        moveRight();
        break;

      default:
    }

    List<int> unsafe = snake_position.sublist(0,snake_position.length-2);

    if (snake_position.last==food_position){
      eatFood();
    }
    else if(unsafe.contains(snake_position.last)){
      game_Over();
    }
    else{
      snake_position.removeAt(0);
    }
  }

  // 0 1 2 3
  void game_Over(){
    isAlive = false;
  }

  void eatFood(){
    food_position = Random().nextInt(rows*cols-1);
  }

  // [ 1 2 3]
  void moveRight() {
    if (snake_position.last%cols == 9){
      snake_position.add(snake_position.last - rows+1);
    }
    else {
      snake_position.add(snake_position.last + 1);
    }
  }

  void moveLeft() {
    if (snake_position.last%cols == 0){
      snake_position.add(snake_position.last + rows -1);
    }
    else {
      snake_position.add(snake_position.last - 1);
    }
  }

  void moveUp() {
    if(snake_position.last<cols){
      snake_position.add((cols-1)*rows + snake_position.last%cols);
      print('Up wall');
    }
    else {
      snake_position.add(snake_position.last - rows);
    }
  }

  void moveDown() {
    if(snake_position.last>(cols-1)*rows){
      snake_position.add(snake_position.last%cols);
      print('Down wall');
    }
    else {
      snake_position.add(snake_position.last + rows);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    start_game();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(flex: 1, child: Container()),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 && snake_direction!=Direction.LEFT) {
                  snake_direction = Direction.RIGHT;
                }
                if (details.delta.dx < 0 && snake_direction!=Direction.RIGHT) {
                  snake_direction = Direction.LEFT;
                }
              },
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 && snake_direction!=Direction.UP) {
                  snake_direction = Direction.DOWN;
                }
                if (details.delta.dy < 0 && snake_direction!=Direction.DOWN) {
                  snake_direction = Direction.UP;
                }
              },
              child: Container(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: rows * cols,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rows),
                    itemBuilder: (context, index) {
                      if (snake_position.contains(index)) {
                        if (isAlive) {
                          return Snake_Pixel();
                        }
                        else{
                          return Dead_Pixel();
                        }
                      } else if (index == food_position) {
                        return Food_Pixel();
                      }
                      return Blank_Pixel();
                    }),
              ),
            ),
          ),
          Expanded(flex: 1, child: Container())
        ],
      ),
    );
  }
}
