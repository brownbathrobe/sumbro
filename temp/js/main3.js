
// DOM Ready
jQuery(function($){

  // Game Object
  var game = {
    maxDegree: 20,
    maxX: window.innerWidth,
    maxY: window.innerHeight,
    entities: [],
    createPlayer: function(name, x, y){
    }
  };

  // Orientation Events
  $(window).on('deviceorientation', function(e){
    var coord = e.originalEvent,
        x = coord.gamma,
        y = coord.beta,
        z = coord.alpha;
  });

  $(window).on('click', function(e){
    mouseFollow.target.x = e.clientX;
    mouseFollow.target.y = e.clientY;
  });

  // Update
  update = function(){
    game.physics.step();
    render();
  };

  // Render
  render = function(){
    radius = game.physics.particles[0].radius;
    $('.user1').css({
      top: game.physics.particles[0].pos.y - radius, 
      left: game.physics.particles[0].pos.x - radius,
      height: radius * 2,
      width: radius * 2
    });
    $('.user2').css({
      top: game.physics.particles[1].pos.y - radius, 
      left: game.physics.particles[1].pos.x - radius,
      height: radius * 2,
      width: radius * 2
    });
    setTimeout(update, 17);
  };


  init = function(){
    game.physics = new Physics();
    game.physics.integrator = new Verlet();
    game.collision = new Collision();

    bounds = new EdgeBounce((new Vector(0,0)), (new Vector(window.innerWidth, window.innerHeight)));

    var pullToCenter = new Attraction();
    window.mouseFollow = new Attraction();

    mouseFollow.strength = 900;

    pullToCenter.target.x = window.innerWidth/2;
    pullToCenter.target.y = window.innerHeight/2;
    pullToCenter.strength = 120;

    var wander = new Wander(1);

    console.log(game);
    for(i=0; i<2; i++){
      var particle = new Particle( Math.random() );
      // var position = new Vector( Math.random( window.innerWidth ), Math.random( window.innerHeight ) );
      var position = new Vector(i * 100, i * 200);
      particle.setMass(0.5);
      particle.setRadius( 30 );
      particle.moveTo( position );

      game.collision.pool.push( particle );

      particle.behaviours.push( bounds, game.collision );

      game.physics.particles.push( particle );
    }
    game.physics.particles[0].behaviours.push(mouseFollow);
    game.physics.particles[1].behaviours.push(wander);


    // game.createPlayer('darrin', 20, 20);
    // game.createPlayer('shane', 50, 50);
    update();
  }();

  // Loop
  // (function animloop(){
  //   requestAnimFrame(animloop);
    // update();
    // render();
  // })();
});
