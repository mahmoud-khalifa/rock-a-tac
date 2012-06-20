/* 
 * File:   computerplayer.c
 * Author: ammar
 *
 * Created on 27 February 2012, 13:26
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
struct move {
    int index;
    int type;
};

struct movevalue {
    int index;
    int type;
    int value;
};


void start(int mod, int turn);
void putmove(int index, int type);
bool isNotFull(int myboard[]);
int checkwin(int myboard[], bool mybelong[]);
struct move getnextmove();
struct movevalue minmaxphaseone(int myboard[], bool mybelong[], bool myplayerRes[], bool mycomputerRes[], int turn);
struct movevalue minmaxphasetwo(int myboard[], bool mybelong[], bool myplayerRes[], bool mycomputerRes[], int limit);
void copyarray(int array1[], int array2[], int size);
void copyarrayb(bool array1[], bool array2[], int size);
void increaseRes(bool array[], int type);
void decreaseRes(bool array[], int type);
