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

    public function Player( mySprites:Class )
    {
      this.Sprites = mySprites;
      loadGraphic( Sprites, true, false, Globals.TILE_WIDTH, Globals.TILE_HEIGHT );

      drag.x = Globals.PLAYER_SPEED * 8;
      drag.y = Globals.PLAYER_SPEED * 8;
      maxVelocity.x = Globals.PLAYER_SPEED;
      maxVelocity.y = Globals.GAME_GRAVITY;
      acceleration.y = Globals.GAME_GRAVITY;

      addAnimation( 'idle', [2] );
      jump = 0;
    }

    override public function update( ):void {

      velocity.x = 0;
      play( 'idle' );

      if ( FlxG.keys.LEFT ) {
        velocity.x = -Globals.PLAYER_SPEED;
      }
      if ( FlxG.keys.RIGHT ) {
        velocity.x = Globals.PLAYER_SPEED;
      }

      // mario style jump mechanic
      if ( FlxG.keys.UP && jump >= 0 ) {
        jump += FlxG.elapsed;
        if ( jump > Globals.PLAYER_JUMP_MAX ) jump = -1;

      } else jump = -1;

      if ( jump > 0 ) {
        if ( jump < Globals.PLAYER_JUMP_MIN ) velocity.y = -Globals.PLAYER_JUMP;
      } else if( !isTouching( FlxObject.FLOOR ) ) {
        velocity.y = Globals.GAME_GRAVITY;
      }

      if ( isTouching( FlxObject.FLOOR ) ) {
        jump = 0;
      }

      super.update( );
    }
  }

}