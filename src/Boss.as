package  
{
  import org.flixel.FlxPath;
  import org.flixel.FlxSprite;
  import org.flixel.FlxTilemap;
  import org.flixel.FlxG;
	
  public class Boss extends FlxSprite 
  {
    private var Sprites:Class;
    private var facingDir:String;
    
    // reference variables from the game needed for proper handling
    private var level:FlxTilemap;
    private var lava:FlxTilemap;
    private var player:Player;
    private var spawnSpearFunc:Function;
    
    private var lavaLevel:int;
    private var levelTimer:Number;
    private var lavaRaiseTimer:Number;
    private var spearTimer:Number;
    
    private var gotoX:int;
    private var gotoY:int;
    private var dead:Boolean;
    
    public function Boss( mySprites:Class ) 
    {
      this.Sprites = mySprites;
      loadGraphic( Sprites, true, false, Globals.TILE_WIDTH, Globals.TILE_HEIGHT );
      facingDir = 'left';
      dead = false;
      
      // initialize animation
      addAnimation( 'idle_left', [55] );
      addAnimation( 'idle_right', [54] );
      addAnimation( 'dying', [43, 44, 45, 0], 10, false );
      
      play( 'idle_left' );
      
      lavaLevel = 1;
      lavaRaiseTimer = 0;
      spearTimer = 0;
      levelTimer = 0;
      gotoX = -1;
      gotoY = -1;
      
      velocity.x = 0;
      velocity.y = 0;
    }
    
    override public function update( ):void {
      
      //FlxG.collide( this.level, this );
      
      // add timers
      this.levelTimer += FlxG.elapsed;
      if( this.levelTimer > 1 ) {
        this.lavaRaiseTimer += FlxG.elapsed;
        this.spearTimer += FlxG.elapsed;
      }
      
      // spawn lava
      if ( this.lavaRaiseTimer > Globals.BOSS_LAVA_SPAWN ) {
        this.raiseLava( );
        this.lavaRaiseTimer = 0;
      }
      
      // spawn spears
      if ( !this.dead && this.spearTimer > Globals.BOSS_SPEAR_SPAWN ) {
        this.spawnSpear( );
        this.spearTimer = 0;
      }
      
      this.raiseBoss( );
      this.handleGoto( );
      
      this.handlePlayerDeath( );
      this.handleBossDeath( );
      
      super.update( );
    }
    
    public function setAssets( myLevel:FlxTilemap, myLava:FlxTilemap, myPlayer:Player, myFunc:Function ):void {
      this.level = myLevel;
      this.lava = myLava;
      this.player = myPlayer;
      this.spawnSpearFunc = myFunc;
    }
    
    // randomly shoots an arrow into the direction of the player
    public function spawnSpear( ):void {
      
      if ( this.player.y + Globals.TILE_HEIGHT >= this.y && this.player.y - 2 * Globals.TILE_HEIGHT <= this.y ) {
        this.spawnSpearFunc( ( this.x / Globals.TILE_WIDTH ) + (int)( this.y / Globals.TILE_HEIGHT ) * this.level.widthInTiles );
      }
    }
    
    // raises lava level by one
    public function raiseLava( ):void {
      
      if ( this.lavaLevel >= this.level.heightInTiles - 11 ) return;
      
      this.lavaLevel++;
      
      var startI:int = ( this.lava.widthInTiles * this.lava.heightInTiles ) - this.lavaLevel * this.lava.widthInTiles + 1;
      var endI:int = startI + this.lava.widthInTiles - 2;
      
      // set all tiles at level to lava
      for ( var i:int = startI; i < endI; i++ ) {
        this.lava.setTileByIndex( i, 24 );
        this.level.setTileByIndex( i, 22 );
      }
    }
    
    public function raiseBoss( ):void {
      
      // raise boss too
      this.gotoX = x;
      //this.gotoY = (int)( startI / this.level.widthInTiles ) * Globals.TILE_HEIGHT - 2 * this.level.widthInTiles;
      this.gotoY = this.player.y;
    }
    
    
    // handles goto properly
    public function handleGoto( ):void {
      
      if ( this.y <= 11 * Globals.TILE_HEIGHT ) return;
      
      if ( Math.abs( this.gotoX - this.x ) < Globals.BOSS_SPEED ) this.x = this.gotoX;
      if ( Math.abs( this.gotoY - this.y ) < Globals.BOSS_SPEED ) this.y = this.gotoY;
      
      // x axis
      if ( this.gotoX >= 0 && this.x != this.gotoX ) {
        if ( this.x < this.gotoX ) { // go left
          velocity.x = Globals.BOSS_SPEED;
        } else if ( this.x > this.gotoX ) { // go right
          velocity.x = -Globals.BOSS_SPEED;
        }
      } else {
        velocity.x = 0;
      }
      
      // y axis
      if ( this.gotoY >= 0 && this.y != this.gotoY ) {
        if ( this.y < this.gotoY ) { // go up
          velocity.y = Globals.BOSS_SPEED;
        } else if ( this.y > this.gotoY ) { // go down
          velocity.y = -Globals.BOSS_SPEED;
        }
      } else {
        velocity.y = 0;
      }
    }
    
    public function handlePlayerDeath( ):void {
      
      if ( this.lavaLevel < 3 ) return;
      if ( (int)(this.level.heightInTiles * Globals.TILE_HEIGHT - this.lavaLevel * Globals.TILE_HEIGHT) < (int)(this.player.y) ) Globals.health = 0;
    }
    
    public function handleBossDeath( ):void {
      if ( !this.dead && (int)(this.level.heightInTiles * Globals.TILE_HEIGHT - (this.lavaLevel) * Globals.TILE_HEIGHT - 5) < (int)(this.y) ) {
        this.play( 'dying' );
        this.dead = true;
      }
    }
    
  }

}