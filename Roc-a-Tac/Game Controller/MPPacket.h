//
//  MPPacket.h
//  Roc-a-Tac
//
//  Created by Log n Labs on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

typedef enum {
    Player_Added_Piece_Message,
    Player_Changed_Stage_Piece_Message,
	Disconnected_Message,
    Player_Send_Who_Start_Piece_Message,
	Game_Paused_Message,
	Game_Resumed_Message,
    OpponentReady_Message,
    OpponentStartGame_Message,
    MessageTypeHostStatus,    
} MpPacketMessageType;

typedef struct
{
    MpPacketMessageType theMessageKind;
	
} Packet;
typedef struct myStruct 
{
	MpPacketMessageType theMessageKind;
    PiecesTypes pieceType;
    PiecesThemes pieceTheme;
    PiecesModels pieceModel;
    PiecesDirections pieceDirection;
    PiecesAnimationNames pieceAnimationName;
    int boardIndex;
    
    
}GamePacket;

typedef struct  
{
	MpPacketMessageType theMessageKind;
    PiecesTypes pieceType;
    
}StagePacket;

typedef struct  
{
	MpPacketMessageType theMessageKind;
    PiecesTypes pieceType;
    
}StartPiecePacket;

typedef struct
{
    MpPacketMessageType type;
    int ishost;
	
} PacketHostStatus;

