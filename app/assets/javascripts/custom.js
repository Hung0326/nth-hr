$(document).on("turbolinks:load", function(){

  $('.span_click_favorite').click(function (e) { 
    $('.overlay_login').addClass('show');    
  });

  $('.icon_close_modal_login').click(function (e) { 
    $('.overlay_login').removeClass('show');
    
  });
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
    body.stop().animate({ scrollTop: 0}, 700, 'swing')
  });
  // => end

  $(".btn_option_location-vn").click(function (){
    var body = $("html, body");
    $('.btn_option_location-vn').addClass('active');
    body.stop().animate({ scrollTop: $('.title_list_city_vn').offset().top}, 700, 'swing');        
  });

  $(".btn_option_location-qt").click(function (){
    var body = $("html, body");
    console.log('bam')
    body.stop().animate({ scrollTop: $('.title_list_city_qt').offset().top}, 700, 'swing');        
  });
  // change lable
  $("input[type=file]").on('change',function(){
    document.getElementById ("label_name_file").innerHTML = this.files[0].name;
  });

  // show & hide password
  $(".icon_show_password").on('click',function() {
    $(".input_password").attr('type', 'text');
    $(".icon_show_password").hide()
    $(".icon_hide_password").show()
  });

  $(".icon_hide_password").on('click',function() {
    $(".input_password").attr('type', 'password');
    $(".icon_hide_password").hide()
    $(".icon_show_password").show()
  });

});
$(document).on("turbolinks:click", function(){
  $(".box_loading").show();
});

$(document).on("turbolinks:load", function(){
  $(".box_loading").hide();
});
