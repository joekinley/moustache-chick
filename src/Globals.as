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
    public static const WORLDGEN_FLOOR_RANDOM:int = 5; // possibility percent at which a initial floor will be created
    public static const WORLDGEN_EVOLUTION_RUNS:int = 5; // chance for tiles to grow
    public static const WORLDGEN_GROW_RANDOM:int = 40; // percental chance for growing
    public static const WORLDGEN_LAVASOURCE_RANDOM:int = 15; // permille chance of getting a lava source

    // game constants
    public static const GAME_GRAVITY:int = 200;
    public static const GAME_LAVA_SPREAD_POSSIBILITY:int = 25; // x percent chance of lava spreading to both sides
    public static const GAME_LAVA_SPEED:Number = 0.10; // in seconds how often lava update routine has to be called (0.20)
    public static const GAME_LAVA_NEW:Number = 0.5; // in seconds when a new lava shall appear (2)
    public static const GAME_LAVA_ANIMATION_SPEED:Number = 0.25; // animation speed for lava
    public static const GAME_COLLECTIBLE_ANIMATION_SPEED:Number = 0.5; // animation speed of collectibles
    public static const PLAYER_SPEED:int = 120;
    public static const PLAYER_JUMP:int = 800;
    public static const PLAYER_JUMP_MAX:Number = 0.25;
    public static const PLAYER_JUMP_MIN:Number = 0.0625;

    // special tiles
    public static const TILES_EMPTY:int = 1;
    public static const TILES_PLAYER_START:int = 2;
    public static const TILES_EXIT:int = 11;
    public static const TILES_WALL:int = 22;
    public static const TILES_LAVA_SOURCE:int = 23;
    public static const TILES_COLLECTIBLE_INDICATOR:int = 10;

    // helper functions
    public static function randomNumber( max:int, min:int = 0 ):int {
      return Math.random( ) * ( max - min ) + min;
    }

    [Embed(source = '../assets/sound/jump.mp3')] public static const SoundJump:Class;
    [Embed(source = '../assets/sound/hurt.mp3')] public static const SoundHurt:Class;

  }

}