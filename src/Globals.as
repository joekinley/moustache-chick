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
    public static const WORLDGEN_FLOOR_RANDOM:int = 9; // possibility percent at which a initial floor will be created
    public static const WORLDGEN_EVOLUTION_RUNS:int = 7; // chance for tiles to grow
    public static const WORLDGEN_GROW_RANDOM:int = 60; // percental chance for growing
    public static const WORLDGEN_LAVASOURCE_RANDOM:int = 15; // permille chance of getting a lava source
    public static const WORLDGEN_COIN_RANDOM:int = 15; // permille chance of a coin appearing in the level
    public static const WORLDGEN_HEART_RANDOM:int = 5; // permille chance of a heart tank appearing in the level

    // game constants
    public static const GAME_GRAVITY:int = 200;
    public static const GAME_LAVA_SPREAD_POSSIBILITY:int = 100; // x percent chance of lava spreading to both sides
    public static const GAME_LAVA_SPEED:Number = 0.20; // in seconds how often lava update routine has to be called (0.20)
    public static const GAME_LAVA_NEW:Number = 2.0; // in seconds when a new lava shall appear (2)
    public static const GAME_LAVA_ANIMATION_SPEED:Number = 0.25; // animation speed for lava
    public static const GAME_COLLECTIBLE_ANIMATION_SPEED:Number = 0.5; // animation speed of collectibles
    public static const GAME_LOST_LIFE_LOSE_SCORE:int = 10; // lose this amount of score when dying
    public static const GAME_HIT_LAVA_LOSE_SCORE:int = 2; // lose this amount of score when hitting lavas
    public static const GAME_SPIKE_ANIMATION_SPEED:Number = 0.025; // animation speed for appearing spikes
    public static const GAME_SPIKE_DURATION:Number = 3; // duration of appeared spikes
    public static const GAME_SHAKE_MAX_TIMER:Number = 15; // shake screen every x seconds
    public static const GAME_SHAKE_CHANCE:Number = 20; // permillion chance of shaking earlier
    public static const PLAYER_SPEED:int = 110; // 150 (120 for slower but still okay)
    public static const PLAYER_JUMP:int = 800; // 800
    public static const PLAYER_JUMP_MAX:Number = 0.25; // 0.25
    public static const PLAYER_JUMP_MIN:Number = 0.0625; // 0.0625
    public static const PLAYER_MAX_HEALTH:int =  15; // 15
    public static const PLAYER_WHIP_DURATION:Number = 1; // seconds the whip is on

    // special tiles
    public static const TILES_EMPTY:int = 1;
    public static const TILES_PLAYER_START:int = 2;
    public static const TILES_EXIT:int = 11;
    public static const TILES_WALL:int = 22;
    public static const TILES_LAVA_SOURCE:int = 23;
    public static const TILES_COLLECTIBLE_INDICATOR:int = 10;
    public static const TILES_HEART_INDICATOR:int = 36;
    public static const TILES_SPIKES:int = 40; // TODO: draw spikes (3 states for smooth movement)

    // helper functions
    public static function randomNumber( max:int, min:int = 0 ):int {
      return Math.random( ) * ( max - min ) + min;
    }

    public static var score:int = 0;
    public static var health:int = 0;
    public static var hasWhip:Boolean = false;

    [Embed(source = '../assets/graphics/background.png')] public static const Background:Class;
    [Embed(source = '../assets/graphics/menuback.png')] public static const MenuBackground:Class;
    [Embed(source = '../assets/sound/jump.mp3')] public static const SoundJump:Class;
    [Embed(source = '../assets/sound/hurt.mp3')] public static const SoundHurt:Class;
    [Embed(source = '../assets/sound/coin.mp3')] public static const SoundCoin:Class;
    [Embed(source = '../assets/sound/crush.mp3')] public static const SoundCrush:Class;

  }

}