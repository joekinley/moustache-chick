package
{
	/**
   * ...
   * @author Rafael Wenzel
   */
  public class Globals
  {

    public static const TILE_WIDTH:int = 16;
    public static const TILE_HEIGHT:int = 16;

    // game constants
    public static const GAME_GRAVITY:int = 200;
    public static const PLAYER_SPEED:int = 150;
    public static const PLAYER_JUMP:int = 800;
    public static const PLAYER_JUMP_MAX:Number = 0.25;
    public static const PLAYER_JUMP_MIN:Number = 0.0625;

    // special tiles
    public static const TILES_EMPTY:int = 1;
    public static const TILES_PLAYER_START:int = 2;
    public static const TILES_WALL:int = 22;
  }

}