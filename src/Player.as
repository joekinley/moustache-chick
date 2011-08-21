package
{
	/**
   * ...
   * @author Rafael Wenzel
   */
  import org.flixel.*;

  public class Player extends FlxSprite
  {
    private var Sprites:Class;
    private var jump:Number;
    private var whip:Boolean;
    public var facingDir:String;

    public var whipSprite:FlxSprite;

    public function Player( mySprites:Class )
    {
      this.Sprites = mySprites;
      loadGraphic( Sprites, true, false, Globals.TILE_WIDTH, Globals.TILE_HEIGHT );

      width = 12; // collision box tweak
      drag.x = Globals.PLAYER_SPEED * 8;
      drag.y = Globals.PLAYER_SPEED * 8;
      maxVelocity.x = Globals.PLAYER_SPEED;
      maxVelocity.y = Globals.GAME_GRAVITY;
      acceleration.y = Globals.GAME_GRAVITY;
      centerOffsets( );

      addAnimation( 'idle', [4] );
      addAnimation( 'idle_right', [4] );
      addAnimation( 'idle_left', [5] );
      addAnimation( 'run_left', [16,17], 10 );
      addAnimation( 'run_right', [14,15], 10 );
      addAnimation( 'jump_right', [6] );
      addAnimation( 'jump_left', [7] );
      addAnimation( 'jump_center', [8] );
      jump = 0;
      play( 'idle' );

      // create whip sprite
      whipSprite = new FlxSprite( );
      whipSprite.loadGraphic( Sprites, true, false, Globals.TILE_WIDTH, Globals.TILE_HEIGHT );
      whipSprite.addAnimation( 'left', [38] );
      whipSprite.addAnimation( 'right', [37] );
      whipSprite.addAnimation( 'up', [36] );
      whipSprite.kill( );
    }

    override public function update( ):void {

      velocity.x = 0;
      //facingDir = 'center';
      whipSprite.play( 'up' );

      if ( FlxG.keys.LEFT ) {
        velocity.x = -Globals.PLAYER_SPEED;
        facingDir = 'left';
        play( 'run_left' );
        whipSprite.play( 'left' );
      }
      if ( FlxG.keys.RIGHT ) {
        velocity.x = Globals.PLAYER_SPEED;
        facingDir = 'right';
        play( 'run_right' );
        whipSprite.play( 'right' );
      }

      // play jump sound
      if( FlxG.keys.justPressed( 'UP' ) ) FlxG.play( Globals.SoundJump, 0.5 );

      // mario style jump mechanic
      if ( FlxG.keys.UP && jump >= 0 ) {
        jump += FlxG.elapsed;
        if ( jump > Globals.PLAYER_JUMP_MAX ) jump = -1;

      } else jump = -1;

      if ( jump > 0 ) {
        if ( facingDir == 'left' ) play( 'jump_left' );
        else if ( facingDir == 'right' ) play( 'jump_right' );
        else play( 'jump_center' );

        if ( jump < Globals.PLAYER_JUMP_MIN ) velocity.y = -Globals.PLAYER_JUMP;
      } else if( !isTouching( FlxObject.FLOOR ) ) {
        velocity.y = Globals.GAME_GRAVITY;
      }

      if ( isTouching( FlxObject.FLOOR ) ) {
        jump = 0;
      }

      if ( velocity.x == 0 && jump <= 0 ) {
        if ( facingDir == 'left' ) play( 'idle_left' );
        else if ( facingDir == 'right' ) play( 'idle_right' );
        else play( 'idle' );
      }

      // also show whip sprite
      if ( this.whip ) {
        if( velocity.x < 0 ) {
          whipSprite.x = this.x - this.width;
          whipSprite.y = this.y;
        } else if ( velocity.x > 0 ) {
          whipSprite.x = this.x + this.width;
          whipSprite.y = this.y;
        } else {
          whipSprite.x = this.x;
          whipSprite.y = this.y - this.height;
        }
      }

      super.update( );
    }

    public function setWhipping( status:Boolean = false ):void {
      this.whip = status;
      if ( status ) this.whipSprite.revive( );
      else this.whipSprite.kill( );
    }
  }

}