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

    // level generator constants
    public static const WORLDGEN_FLOOR_RANDOM:int = 4; // possibility percent at which a initial floor will be created
    public static const WORLDGEN_EVOLUTION_RUNS:int = 5; // chance for tiles to grow
    public static const WORLDGEN_GROW_RANDOM:int = 40; // percental chance for growing

    // game constants
    public static const GAME_GRAVITY:int = 200;
    public static const GAME_LAVA_SPREAD_POSSIBILITY:int = 10; // x percent chance of lava spreading to both sides
    public static const GAME_LAVA_SPEED:int = 10; // in seconds how often lava update routine has to be called
    public static const GAME_LAVA_NEW:int = 2; // in seconds when a new lava shall appear
    public static const PLAYER_SPEED:int = 150;
    public static const PLAYER_JUMP:int = 800;
    public static const PLAYER_JUMP_MAX:Number = 0.25;
    public static const PLAYER_JUMP_MIN:Number = 0.0625;

    // special tiles
    public static const TILES_EMPTY:int = 1;
    public static const TILES_PLAYER_START:int = 2;
    public static const TILES_EXIT:int = 11;
    public static const TILES_WALL:int = 22;
    public static const TILES_LAVA_SOURCE:int = 23;
  }

}