
// DOM Ready
jQuery(function(){

  // User Object
  var user = {
    el: $('.user'),
    x: 0,
    y: 0,
    size: $('.user').width()
  };

  // Game Object
  var game = {
    maxDegree: 20,
    maxX: window.innerWidth,
    maxY: window.innerHeight
  };

  // Move
  var lastMove = {
    x: 0,
    y: 0
  };

  // Orientation Events
  $(window).on('deviceorientation', function(e){
    var coord = e.originalEvent,
        x = coord.gamma,
        y = coord.beta,
        z = coord.alpha;
    lastMove.x = x;
    lastMove.y = y;
  });

  // Render
  render = function(){
    user.el.css({ top: user.y, left: user.x });
  };

  // Update
  update = function(){
    x = lastMove.x;
    y = lastMove.y;
    if(x >  game.maxDegree){ x =  game.maxDegree };
    if(x < -game.maxDegree){ x = -game.maxDegree };
    x += game.maxDegree;
    y += game.maxDegree;
    x += game.maxX * x / (game.maxDegree * 2);
    y += game.maxY * y / (game.maxDegree * 2);
    if(x < 0) x = 0;
    if(x >= game.maxX - user.size) x = game.maxX - user.size;
    if(y < 0) y = 0;
    if(y >= game.maxY - user.size) y = game.maxY - user.size;
    user.y = y;
    user.x = x;
  };

  // Loop
  (function animloop(){
    requestAnimFrame(animloop);
    update();
    render();
  })();

});