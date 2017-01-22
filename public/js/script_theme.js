$(function() {
  $('.all-articles .nav').each(function(i, elem) {
    if ((i + 1) % 2 == 1) { 
      $(this).children("li").addClass("white-li");
    }
    else $$(this).children("li").addClass("black-li")
  });
});