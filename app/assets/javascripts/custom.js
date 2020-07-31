$(document).on("turbolinks:load", function(){
  // => scroll to top
  $(window).scroll(function(){
    if ($(this).scrollTop() > 550) {   
      $(".btn-scroll-top").css('opacity',1);       
      $(".btn-scroll-top").fadeIn(400);
    } else {
      $(".btn-scroll-top").fadeOut(400);
    }
  });

  $(".btn-scroll-top").click(function (e){
    var body = $("html, body");
    console.log('wed')
    body.stop().animate({ scrollTop: 0}, 700, 'swing')
  });
// => end

  $('.block_click_favorite').click(function (e) { 
    $('.overlay_login').addClass('show');    
  });

  $('.icon_close_modal_login').click(function (e) { 
    $('.overlay_login').removeClass('show');
    
  });

});
