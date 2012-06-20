/* 
 * File:   computerplayer.c
 * Author: ammar
 *
 * Created on 27 February 2012, 13:26
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "computerplayer.h"

static int board[9];
static int replace[3];
static bool belong[9];
static bool playerRes[9];
static bool computerRes[9];
static int mode;
static bool notfull;
static int turns;
static int steps;
static int firstpiece;

void start(int mod, int turn) {
    unsigned int seed = (unsigned int) time(NULL);
    srand(seed);
    mode = mod;
    turns = turn;
    steps = 0;
    notfull = true;
    int* ptr = board;
    bool* ptrb;
    int i;
    for (i = 0; i < 9; i++) {
        *(ptr + i) = -1;
    }
    ptr = replace;
    *ptr = 2;
    *(ptr + 1) = 0;
    *(ptr + 2) = 1;
    ptrb = playerRes;
    for (i = 0; i < 9; i++) {
        *(ptrb + i) = true;
    }
    ptrb = computerRes;
    for (i = 0; i < 9; i++) {
        *(ptrb + i) = true;
    }
    ptrb = belong;
    for (i = 0; i < 9; i++) {
        *(ptrb + i) = true;
    }
}

void putmove(int index, int type) {
    int* ptr = board;
    bool* ptrb = belong;
    
    if (!notfull) {
        increaseRes(computerRes, board[index]);
    }

    *(ptr + index) = type;
    *(ptrb + index) = false;
    decreaseRes(playerRes, type);
    notfull = isNotFull(board);
}

struct move getnextmove() {
    struct move x;
    if (turns == 0 && steps == 0) {
        x.index = 4;
        x.type = rand() % 3;
        firstpiece = x.type;
    } else if (turns == 0 && steps == 1) {
        if (board[0] == -1 && board[8] == -1) {
            x.index = 0;
        } else {
            x.index = 2;
        }
        x.type = rand() % 3;
        if (firstpiece == x.type) {
            x.type = replace[x.type];
        }
        
    } else if (turns == 1 && steps == 0) {
        if (board[4] == -1) {
            x.index = 4;
            x.type = rand() % 3;
        } else {
            int four[] = {0, 2, 6, 8};
            x.index = four[rand() % 4];
            x.type = rand() % 3;
        }
        firstpiece = x.type;
    } else if (turns == 1 && steps == 1) {
        if (board[4] == -1) {
            x.index = 4;
            x.type = rand() % 3;
        } else if (!belong[4]) {
            int i;
            for (i = 0; i < 9; i++) {
                if (i != 4 && board[i] != -1 && !belong[i]) {
                    int xor = board[4]^board[i];
                    x.index = i == 2 ? 6 : i == 6 ? 2 : i == 0 ? 8 : i == 8 ? 0 : i == 1 ? 7 : i == 7 ? 1 : i == 3 ? 5 : 3;
                    if (xor > 0 && board[x.index] == -1) {
                        x.type = 3 - xor;
                    } else {
                        if (board[0] == -1 && (board[2] == 1 || board[6] == 1)) {
                            x.index = 0;
                        } else if (board[2] == -1 && (board[0] == 1 || board[8] == 1)) {
                            x.index = 2;
                        }else if (board[6] == -1 && (board[0] == 1 || board[8] == 1)) {
                            x.index = 6;
                        }else {
                            x.index = 8;
                        }
                        x.type = rand() % 3;
                    }
                    break;
                }
            }
            
        } else {
            int xor = board[0]^board[1]^board[2];
            bool check = false;
            if (xor<-1 && (belong[0]^belong[1]^belong[2]) && !(belong[0] && belong[1] && belong[2])) {
                x.index = board[0] == -1 ? 0 : board[1] == -1 ? 1 : 2;
                x.type = xor + 4;
                check = true;
            }
            xor = board[0]^board[3]^board[6];
            if (xor<-1 && (belong[0]^belong[3]^belong[6]) && !(belong[0] && belong[3] && belong[6])) {
                x.index = board[0] == -1 ? 0 : board[3] == -1 ? 3 : 6;
                x.type = xor + 4;
                check = true;
            }
            xor = board[6]^board[7]^board[8];
            if (xor<-1 && (belong[6]^belong[7]^belong[8]) && !(belong[6] && belong[7] && belong[8])) {
                x.index = board[6] == -1 ? 6 : board[7] == -1 ? 7 : 8;
                x.type = xor + 4;
                check = true;
            }
            xor = board[2]^board[5]^board[8];
            if (xor<-1 && (belong[2]^belong[5]^belong[8]) && !(belong[2] && belong[5] && belong[8])) {
                x.index = board[2] == -1 ? 2 : board[5] == -1 ? 5 : 8;
                x.type = xor + 4;
                check = true;
            }
            if (!check) {
                int four[] = {1, 3, 5, 7};
                x.index = four[rand() % 4];
                while (board[x.index] != -1) {
                    x.index = four[rand() % 4];
                }
                x.type = rand() % 3;
            }
        }
        if (firstpiece == x.type) {
            x.type = replace[x.type];
        }
    } else if (mode == 0) {
        if (notfull) {
            if (steps%2==1) {//if easier %3==1, %3==2==> if %3
                x.index = rand() % 9;
                while (board[x.index]!=-1) {
                    x.index = rand() % 9;
                }
                x.type = rand()%3;
                while (!(computerRes[x.type * 3] | computerRes[x.type * 3 + 1] | computerRes[x.type * 3 + 2])) {
                    x.type = rand()%3;
                }
            } else {
                struct movevalue y = minmaxphaseone(board, belong, playerRes, computerRes, 1);
                x.index = y.index;
                x.type = y.type;
            }
            
        } else {
            bool found = false;
            while (!found) {
                x.index = rand() % 9;
                while (belong[x.index]) {
                    x.index = rand() % 9;
                }
                x.type = replace[board[x.index]];
                if (computerRes[x.type * 3] | computerRes[x.type * 3 + 1] | computerRes[x.type * 3 + 2]) {
                    found = true;
                }
            }
            increaseRes(playerRes, board[x.index]);
        }
    } else {
        if (notfull) {
            struct movevalue y = minmaxphaseone(board, belong, playerRes, computerRes, 1);
            x.index = y.index;
            x.type = y.type;
            if (y.value<=0 && mode==2) {//mode==1, type != board[4],belong[4]=1
                x.type = rand()%3;
                while (!(computerRes[x.type * 3] | computerRes[x.type * 3 + 1] | computerRes[x.type * 3 + 2])) {
                    x.type = rand()%3;
                }
            }
            
        } else {
            if (mode==1 && steps%3==0) {
                bool found = false;
                while (!found) {
                    x.index = rand() % 9;
                    while (belong[x.index]) {
                        x.index = rand() % 9;
                    }
                    x.type = replace[board[x.index]];
                    if (computerRes[x.type * 3] | computerRes[x.type * 3 + 1] | computerRes[x.type * 3 + 2]) {
                        found = true;
                    }
                }
                increaseRes(playerRes, board[x.index]);
            }else {
                //            struct movevalue y = minmaxphasetwo(board, belong, playerRes, computerRes,mode==1&&steps%2==1?1:3);
//                struct movevalue y = minmaxphasetwo(board, belong, playerRes, computerRes,mode==1?1:5);
                struct movevalue y = minmaxphasetwo(board, belong, playerRes, computerRes,mode==1?1:3);
                x.index = y.index;
                x.type = y.type;
                increaseRes(playerRes, board[x.index]);
            }
        }
    }
    decreaseRes(computerRes, x.type);
    board[x.index] = x.type;
    belong[x.index] = 1;
    steps++;
    notfull = isNotFull(board);
    return x;
}

bool isNotFull(int myboard[]) {
    int i;
    int *ptr = myboard;
    for (i = 0; i < 9; i++) {
        if (*(ptr + i) == -1) {
            return true;
        }
    }
    return false;
}

int checkwin(int myboard[], bool mybelong[]) {
    int i;
    int x;
    for (i = 0; i < 7; i += 3) {
        x = myboard[i]^myboard[i + 1]^myboard[i + 2];
        if (x == 3) {
            if (mybelong[i] & mybelong[i + 1] & mybelong[i + 2])
                return 1;
            else if (!(mybelong[i] | mybelong[i + 1] | mybelong[i + 2])) {
                return -1;
            }
        }
    }
    for (i = 0; i < 3; i += 1) {
        x = myboard[i]^myboard[i + 3]^myboard[i + 6];
        if (x == 3) {
            if (mybelong[i] & mybelong[i + 3] & mybelong[i + 6])
                return 1;
            else if (!(mybelong[i] | mybelong[i + 3] | mybelong[i + 6])) {
                return -1;
            }
        }
    }
    x = myboard[2]^myboard[4]^myboard[6];
    if (x == 3) {
        if (mybelong[2] & mybelong[4] & mybelong[6])
            return 1;
        else if (!(mybelong[2] | mybelong[4] | mybelong[6])) {
            return -1;
        }
    }
    x = myboard[0]^myboard[4]^myboard[8];
    if (x == 3) {
        if (mybelong[0] & mybelong[4] & mybelong[8])
            return 1;
        else if (!(mybelong[0] | mybelong[4] | mybelong[8])) {
            return -1;
        }
    }
    return 0;
}

void copyarray(int array1[], int array2[], int size) {
    int *ptr1 = array1;
    int *ptr2 = array2;
    int i;
    for (i = 0; i < size; i++) {
        *(ptr1 + i) = *(ptr2 + i);
    }
}

void copyarrayb(bool array1[], bool array2[], int size) {
    bool *ptr1 = array1;
    bool *ptr2 = array2;
    int i;
    for (i = 0; i < size; i++) {
        *(ptr1 + i) = *(ptr2 + i);
    }
}

void increaseRes(bool array[], int type) {
    int k;
    bool *ptrb = array;
    for (k = type * 3; k < type * 3 + 3; k++) {
        if (*(ptrb + k) == false) {
            *(ptrb + k) = true;
            break;
        }
    }
}

void decreaseRes(bool array[], int type) {
    int k;
    bool *ptrb = array;
    for (k = type * 3; k < type * 3 + 3; k++) {
        if (*(ptrb + k) == true) {
            *(ptrb + k) = false;
            break;
        }
    }
}

struct movevalue minmaxphaseone(int myboard[], bool mybelong[], bool myplayerRes[], bool mycomputerRes[], int turn) {
    if (checkwin(myboard, mybelong) != 0 || !isNotFull(myboard)) {//terminal child
        int x = checkwin(myboard, mybelong);
        struct movevalue y;
        y.index = 0;
        y.type = 0;
        if (x == 0) {
            y = minmaxphasetwo(myboard, mybelong, myplayerRes, mycomputerRes, 2);
            y.value *= (6 - turn);
        } else if (x == 1) {
            y.value = 9 - turn;
        } else {
            y.value = -9 + turn;
        }
        return y;
    } else if (turn % 2 == 1) {//computer
        int *ptr = myboard;
        int i;
        struct movevalue nextmove;
        nextmove.index = 0;
        nextmove.type = 0;
        nextmove.value = -9;
        for (i = 0; i < 9; i++) {
            if (*(ptr + i) == -1) {
                int j;
                for (j = 0; j < 3; j++) {
                    bool available = mycomputerRes[j * 3] | mycomputerRes[j * 3 + 1] | mycomputerRes[j * 3 + 2];
                    if (available) {
                        int mynextboard[9];
                        bool mynextbelong[9];
                        bool mynextplayerRes[9];
                        bool mynextcomputerRes[9];
                        copyarray(mynextboard, myboard, 9);
                        copyarrayb(mynextplayerRes, myplayerRes, 9);
                        copyarrayb(mynextbelong, mybelong, 9);
                        copyarrayb(mynextcomputerRes, mycomputerRes, 9);
                        mynextboard[i] = j;
                        decreaseRes(mynextcomputerRes, j);
                        struct movevalue y = minmaxphaseone(mynextboard, mynextbelong, mynextplayerRes, mynextcomputerRes, turn + 1);
                        if (y.value >= nextmove.value) {
                            nextmove.value = y.value;
                            nextmove.index = i;
                            nextmove.type = j;
                        }
                        
                    }
                }
            }
        }
        return nextmove;
    } else {//player
        int *ptr = myboard;
        int i;
        struct movevalue nextmove;
        nextmove.index = 0;
        nextmove.type = 0;
        nextmove.value = 1;
        for (i = 0; i < 9; i++) {
            if (*(ptr + i) == -1) {
                int j;
                for (j = 0; j < 3; j++) {
                    bool available = myplayerRes[j * 3] | myplayerRes[j * 3 + 1] | myplayerRes[j * 3 + 2];
                    if (available) {
                        int mynextboard[9];
                        bool mynextbelong[9];
                        bool mynextplayerRes[9];
                        bool mynextcomputerRes[9];
                        copyarray(mynextboard, myboard, 9);
                        copyarrayb(mynextplayerRes, myplayerRes, 9);
                        copyarrayb(mynextbelong, mybelong, 9);
                        copyarrayb(mynextcomputerRes, mycomputerRes, 9);
                        mynextboard[i] = j;
                        mynextbelong[i] = false;
                        decreaseRes(mynextplayerRes, j);
                        struct movevalue y = minmaxphaseone(mynextboard, mynextbelong, mynextplayerRes, mynextcomputerRes, turn + 1);
                        if (y.value <= nextmove.value) {
                            nextmove.value = y.value;
                            nextmove.index = i;
                            nextmove.type = j;
                        }
                        
                    }
                }
            }
        }
        return nextmove;
    }
    
}

struct movevalue minmaxphasetwo(int myboard[], bool mybelong[], bool myplayerRes[], bool mycomputerRes[], int limit) {
    if (checkwin(myboard, mybelong) != 0 | limit == 0) {//terminal child
        int x = checkwin(myboard, mybelong);
        struct movevalue y;
        y.index = 0;
        y.type = 0;
        if (x == 0) {
            y.value = 0;
        } else if (x == 1) {
            y.value = 1;
        } else {
            y.value = -1;
        }
        return y;
    } else if (limit % 2 == 1) {//computer
        int i;
        struct movevalue nextmove;
        nextmove.index = 0;
        nextmove.type = 0;
        nextmove.value = -1;
        for (i = 0; i < 9; i++) {
            int j = replace[myboard[i]];
            if (!mybelong[i]) {
                bool available = mycomputerRes[j * 3] | mycomputerRes[j * 3 + 1] | mycomputerRes[j * 3 + 2];
                if (available) {
                    int mynextboard[9];
                    bool mynextbelong[9];
                    bool mynextplayerRes[9];
                    bool mynextcomputerRes[9];
                    copyarray(mynextboard, myboard, 9);
                    copyarrayb(mynextplayerRes, myplayerRes, 9);
                    copyarrayb(mynextbelong, mybelong, 9);
                    copyarrayb(mynextcomputerRes, mycomputerRes, 9);
                    mynextboard[i] = j;
                    mynextbelong[i] = true;
                    decreaseRes(mynextcomputerRes, j);
                    increaseRes(mynextplayerRes, myboard[i]);
                    struct movevalue y = minmaxphasetwo(mynextboard, mynextbelong, mynextplayerRes, mynextcomputerRes, limit - 1);
                    if (y.value >= nextmove.value) {
                        nextmove.value = y.value;
                        nextmove.index = i;
                        nextmove.type = j;
                    }
                    
                }
            }
            
        }
        return nextmove;
    } else {//player
        int i;
        struct movevalue nextmove;
        nextmove.index = 0;
        nextmove.type = 0;
        nextmove.value = 1;
        for (i = 0; i < 9; i++) {
            int j = replace[myboard[i]];
            if (mybelong[i]) {
                bool available = myplayerRes[j * 3] | myplayerRes[j * 3 + 1] | myplayerRes[j * 3 + 2];
                if (available) {
                    int mynextboard[9];
                    bool mynextbelong[9];
                    bool mynextplayerRes[9];
                    bool mynextcomputerRes[9];
                    copyarray(mynextboard, myboard, 9);
                    copyarrayb(mynextplayerRes, myplayerRes, 9);
                    copyarrayb(mynextbelong, mybelong, 9);
                    copyarrayb(mynextcomputerRes, mycomputerRes, 9);
                    mynextboard[i] = j;
                    mynextbelong[i] = false;
                    decreaseRes(mynextplayerRes, j);
                    increaseRes(mynextcomputerRes, myboard[i]);
                    struct movevalue y = minmaxphasetwo(mynextboard, mynextbelong, mynextplayerRes, mynextcomputerRes, limit - 1);
                    if (y.value <= nextmove.value) {
                        nextmove.value = y.value;
                        nextmove.index = i;
                        nextmove.type = j;
                    }
                    
                }
            }
            
        }
        return nextmove;
    }
}
