
// DOM Ready
jQuery(function(){

  // User Object
  var user1 = {
    id: 'user1',
    el: $('.user1'),
    x: 0,
    y: 0,
    nextX: 0,
    nextY: 0,
    lastX: 0,
    lastY: 0,
    size: $('.user1').width(),
    update: function(){
      x = this.nextX;
      y = this.nextY;
      if(x >  game.maxDegree){ x =  game.maxDegree };
      if(x < -game.maxDegree){ x = -game.maxDegree };
      x += game.maxDegree;
      y += game.maxDegree;
      x += game.maxX * x / (game.maxDegree * 2);
      y += game.maxY * y / (game.maxDegree * 2);
      if(x < 0) x = 0;
      if(x >= game.maxX - user1.size) x = game.maxX - user1.size;
      if(y < 0) y = 0;
      if(y >= game.maxY - user1.size) y = game.maxY - user1.size;
      user1.lastX = user1.x;
      user1.lastY = user1.y;
      user1.y = y;
      user1.x = x;
      this.collide();
    },
    render: function(){
      user1.el.css({ top: user1.y, left: user1.x });
    },
    collide: function(){
      for(j=0; j<game.entities.length;j++){
         entityB = game.entities[j];
         if(this.id != entityB.id){
           dx = this.x - entityB.x;
           dy = this.y - entityB.y;
           distance = Math.sqrt((dx*dx)+(dy*dy));
           if(distance < (this.size / 2 + entityB.size / 2)){
             this.x = this.lastX;
             this.y = this.lastY;
             entityB.x = entityB.lastX;
             entityB.y = entityB.lastY;
           }
          }
      }
    }
  };
  var user2 = {
    id: 'user2',
    el: $('.user2'),
    x: 100,
    y: 100,
    nextX: 0,
    nextY: 0,
    lastX: 0,
    lastY: 0,
    size: $('.user2').width(),
    update: function(){
      x = this.nextX;
      y = this.nextY;
      if(x >  game.maxDegree){ x =  game.maxDegree };
      if(x < -game.maxDegree){ x = -game.maxDegree };
      x += game.maxDegree;
      y += game.maxDegree;
      x += game.maxX * x / (game.maxDegree * 2);
      y += game.maxY * y / (game.maxDegree * 2);
      if(x < 0) x = 0;
      if(x >= game.maxX - user2.size) x = game.maxX - user2.size;
      if(y < 0) y = 0;
      if(y >= game.maxY - user2.size) y = game.maxY - user2.size;
      user2.lastX = user2.x;
      user2.lastY = user2.y;
      user2.y = y;
      user2.x = x;
      this.collide();
    },
    render: function(){
      user2.el.css({ top: user2.y, left: user2.x });
    },
    collide: function(){
      for(j=0; j<game.entities.length;j++){
         entityB = game.entities[j];
         if(this.id != entityB.id){
           dx = this.x - entityB.x;
           dy = this.y - entityB.y;
           distance = Math.sqrt((dx*dx)+(dy*dy));
           if(distance < (this.size / 2 + entityB.size / 2)){
             this.x = this.lastX;
             this.y = this.lastY;
           }
          }
      }
    }
  };

  // Game Object
  var game = {
    maxDegree: 20,
    maxX: window.innerWidth,
    maxY: window.innerHeight,
    entities: [],
  };

  // Orientation Events
  $(window).on('deviceorientation', function(e){
    var coord = e.originalEvent,
        x = coord.gamma,
        y = coord.beta,
        z = coord.alpha;
    user1.nextX = x;
    user1.nextY = y;
  });

  // Render
  render = function(){
    for(i=0; i<game.entities.length;i++){
      entity = game.entities[i];
      entity.render();
    }
  };

  // Update
  update = function(){
    for(i=0; i<game.entities.length;i++){
      entity = game.entities[i];
      entity.update();
    }
  };
  
  checkCollisions = function(){
    for(i=0; i<game.entities.length;i++){
      entityA = game.entities[i];
      for(j=0; j<game.entities.length;j++){
         entityB = game.entities[j];
         if(entityA.id != entityB.id){
           dx = entityA.x - entityB.x;
           dy = entityA.y - entityB.y;
           distance = Math.sqrt((dx*dx)+(dy*dy));
           if(distance < (entityA.size / 2 + entityB.size / 2)){
             entityA.nextX = entityA.lastX;
             entityA.nextY = entityA.lastY;
             entityB.nextX = entityB.lastX;
             entityB.nextY = entityB.lastY;
           }
          }
      }
    }
  }

  init = function(){
    game.entities.push(user1);
    game.entities.push(user2);
  }();

  // Loop
  (function animloop(){
    requestAnimFrame(animloop);
    update();
    render();
  })();

  

});
