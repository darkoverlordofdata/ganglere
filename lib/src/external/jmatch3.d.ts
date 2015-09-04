/**
 * Created by DarkOverlordOfData
 * Date: 7/16/15
 */
declare module jMatch3 {
    
    export class Piece {
        
        constructor(grid:Grid, x:number, y:number);
        clear(): void;
        deepMatchingNeighbours(piece: Piece): Piece[];
        matchingNeighbours(): Piece[];
        neighbour(direction): Piece;
        neighbours(): Piece[];
        relativeCoordinates(direction: any, distance: number): any;
        object: any;
        x: number;
        y: number;
    }
    
    export class Grid {

        static getLastEmptyPiece(pieces: Piece[]): Piece;
        constructor(options);
        applyGravity(): Piece[];
        clearMatches(): boolean;
        coordsInWorld(coords): boolean;
        debug(symbols): void;
        forEachMatch(callback: Function): void;
        forEachPiece(callback: Function): void;
        getColumn(column:number, reverse:boolean): Piece[];
        getMatches(): Piece[];
        getPiece(coords): Piece;
        getRow(row:number, reverse:boolean): Piece[];
        neighbourOf(piece: Piece, direction): Piece;
        neighboursOf(piece: Piece): any;
        swapPieces(piece1: Piece, piece2: Piece): void;
        
    }

}
