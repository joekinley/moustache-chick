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
    private var facingDir:String;

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
    }

    override public function update( ):void {

      velocity.x = 0;
      facingDir = 'center';

      if ( FlxG.keys.LEFT ) {
        velocity.x = -Globals.PLAYER_SPEED;
        facingDir = 'left';
        play( 'run_left' );
      }
      if ( FlxG.keys.RIGHT ) {
        velocity.x = Globals.PLAYER_SPEED;
        facingDir = 'right';
        play( 'run_right' );
      }

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

      super.update( );
    }
  }

}