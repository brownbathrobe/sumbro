
// DOM Ready
jQuery(function($){

  // Game Object
  var game = {
    maxDegree: 20,
    maxX: window.innerWidth,
    maxY: window.innerHeight,
    entities: [],
    createPlayer: function(name, x, y){
      var circleSd = new b2CircleDef();
      circleSd.density = 1.0;
      circleSd.radius = 20;
      circleSd.restitution = 0.5;
      circleSd.friction = 1;
      var circleBd = new b2BodyDef();
      circleBd.AddShape(circleSd);
      circleBd.position.Set(x,y);
      var circleBody = this.world.CreateBody(circleBd);
      circleBody.name = name;
      this.entities.push(circleBody);
    }
  };

  // Orientation Events
  $(window).on('deviceorientation', function(e){
    var coord = e.originalEvent,
        x = coord.gamma,
        y = coord.beta,
        z = coord.alpha;
  });

  // Render
  render = function(){
    for (var b = game.world.m_bodyList; b; b = b.m_next) {
      for (var s = b.GetShapeList(); s != null; s = s.GetNext()) {
        drawShape(s);
      }
    }
  };


  drawShape = function(shape){
    entity = game.entities[0];
    $('.user1').css({top: entity.m_position.y, left: entity.m_position.x, width: entity.m_shapeList.m_radius*2, height: entity.m_shapeList.m_radius*2})
    entity = game.entities[1];
    $('.user2').css({top: entity.m_position.y, left: entity.m_position.x, width: entity.m_shapeList.m_radius*2, height: entity.m_shapeList.m_radius*2})
  }

  drawWorld = function(world){
    for (var b = world.m_bodyList; b; b = b.m_next) {
      for (var s = b.GetShapeList(); s != null; s = s.GetNext()) {
        drawShape(s);
      }
    }
  }
  // Update
  update = function(){
    for(i=0; i<game.entities.length;i++){
      entity = game.entities[i];
      entity.update();
    }
  };
  step = function(){
    game.world.Step(1.0/60, 1);
    drawWorld(game.world); 
    game.entities[0].m_shapeList.m_body.ApplyForce(new b2Vec2(20,-300), game.entities[0].m_position);
    setTimeout(step, 17);
  }

  init = function(){
    var worldAABB = new b2AABB();
    worldAABB.minVertex.Set(0, 0);
    worldAABB.maxVertex.Set(window.innerWidth, window.innerHeight - 200);
    var gravity = new b2Vec2(0, 300);
    var doSleep = true;
    var world = new b2World(worldAABB, gravity, doSleep); 
    game.world = world;

    game.createPlayer('darrin', 20, 20);
    game.createPlayer('shane', 50, 50);
    console.log(game);
    step();
  }();

  // Loop
  // (function animloop(){
  //   requestAnimFrame(animloop);
    // update();
    // render();
  // })();
});
