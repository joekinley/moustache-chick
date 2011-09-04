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
    public var dead:Boolean;
    private var touchingLadder:Boolean;
    public var holdingLadder:Boolean;
    public var paralyzed:Boolean;
    private var paralyzeTimer:Number;

    public var whipSprite:FlxSprite;

    public function Player( mySprites:Class )
    {
      this.touchingLadder = false;
      this.holdingLadder = false;
      this.paralyzed = false;
      this.dead = false;
      this.Sprites = mySprites;
      loadGraphic( Sprites, true, false, Globals.TILE_WIDTH, Globals.TILE_HEIGHT );
      this.paralyzeTimer = 0;

      // correct sprite bounds
      width = 14; // collision box tweak
      offset.x = 14;
      centerOffsets( );
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
      addAnimation( 'dying_blood', [43, 44, 45, 0], 10, false );
      
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
      
      // count paralyze timer
      if ( this.paralyzed ) this.paralyzeTimer += FlxG.elapsed;
      if ( this.paralyzeTimer >= Globals.GAME_SPEAR_HIT_TIMEOUT ) {
        this.paralyzed = false;
        this.paralyzeTimer = 0;
      }
      
      if( !this.dead ) {
        velocity.x = 0;
        //facingDir = 'center';
        whipSprite.play( 'up' );

        if( !this.paralyzed ) {
          // movement left and right
          this.handleMovement( );

          // jumping
          this.handleJump( );
          
          // ladder mechanisn
          this.handleLadder( );
        }

        this.handleAnimation( );

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
        
        this.isTouchingLadder( false, x );
      }
      
      super.update( );
    }
       
    public function handleMovement( ):void {
      
      if ( FlxG.keys.LEFT ) {
        if ( jump > 0 ) velocity.x = -Globals.PLAYER_SPEED_JUMP;
        else velocity.x = -Globals.PLAYER_SPEED;
        facingDir = 'left';
        play( 'run_left' );
        whipSprite.play( 'left' );
      }
      if ( FlxG.keys.RIGHT ) {
        if ( jump > 0 ) velocity.x = Globals.PLAYER_SPEED_JUMP;
        else velocity.x = Globals.PLAYER_SPEED;
        facingDir = 'right';
        play( 'run_right' );
        whipSprite.play( 'right' );
      }
    }
    
    public function handleJump( ):void {
      
      // play jump sound
      if( FlxG.keys.justPressed( 'UP' ) ) FlxG.play( Globals.SoundJump, 0.5 );

      // mario style jump mechanic
      if( !this.holdingLadder ) {
        if ( FlxG.keys.UP && jump >= 0 ) {
          jump += FlxG.elapsed;
          if ( jump > Globals.PLAYER_JUMP_MAX ) jump = -1;

        } else jump = -1;

        if ( jump > 0 ) {
          if ( facingDir == 'left' /*&& velocity.x > 0*/ ) play( 'jump_left' );
          else if ( facingDir == 'right' /*&& velocity.x < 0*/ ) play( 'jump_right' );
          else play( 'jump_center' );

          if ( jump < Globals.PLAYER_JUMP_MIN ) velocity.y = -Globals.PLAYER_JUMP;
        } else if( !isTouching( FlxObject.FLOOR ) ) {
          velocity.y += Globals.GAME_GRAVITY;
        }

        if ( isTouching( FlxObject.FLOOR ) ) {
          jump = 0;
        }
      }
    }
    
    public function handleLadder( ):void {
      
      if( this.touchingLadder ) {
        
        if ( !this.holdingLadder && FlxG.keys.UP ) { // hang onto ladder
          // todo: center on ladder sprite      
          velocity.x = 0;
          velocity.y = -Globals.PLAYER_SPEED;
          jump = -1;
          this.holdingLadder = true;
          acceleration.y = 0;
        } else if ( this.holdingLadder && FlxG.keys.UP && ( FlxG.keys.LEFT || FlxG.keys.RIGHT ) ) { // jump off ladder
          this.holdingLadder = false;
          jump = 0;
          acceleration.y = Globals.GAME_GRAVITY;
        } else if ( this.holdingLadder && FlxG.keys.UP ) {
          velocity.y = -Globals.PLAYER_SPEED;
        } else if ( this.holdingLadder && FlxG.keys.DOWN ) {
          velocity.y = Globals.PLAYER_SPEED;
        } else if ( !this.holdingLadder && FlxG.keys.DOWN ) {
          y += 32;
          this.holdingLadder = true;
          acceleration.y = 0;
        }
      } else {
        acceleration.y = Globals.GAME_GRAVITY;
        //jump = 0;
        this.holdingLadder = false;
      }
    }
    
    public function handleAnimation( ):void {
      
      if ( velocity.x == 0 && jump <= 0 ) {
        if ( facingDir == 'left' ) play( 'idle_left' );
        else if ( facingDir == 'right' ) play( 'idle_right' );
        else play( 'idle' );
      }
    }

    public function setWhipping( status:Boolean = false ):void {
      this.whip = status;
      if ( status ) this.whipSprite.revive( );
      else this.whipSprite.kill( );
    }
    
    public function isTouchingLadder( status:Boolean, position:int ):void {
      // only apply position when first holding
      if ( status == true && !touchingLadder && !holdingLadder && FlxG.keys.UP ) x = position;
      
      this.touchingLadder = status;
    }
    
    public function die( ):void {
      if ( !this.dead ) {
        this.velocity.x = 0;
        this.velocity.y = 0;
        this.acceleration.x = 0;
        this.acceleration.y = 0;
        this._flicker = false;
        this._flickerTimer = 0;
        this.dead = true;
        play( 'dying_blood' );
      }
    }
  }

}