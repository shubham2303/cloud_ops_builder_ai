$(document).ready(function(){$(document).on("click",".submit_valid",function(){$(".phone_margin").remove();var e=$(".phone_valid").val();return e.length>11||e.length<10?($(".phone_valid").after('<div class="c_dark_red phone_margin">length should be between 10 or 11 digits</div>'),!1):11==e.length&&"0"!=e[0]||10==e.length&&"0"==e[0]?($(".phone_valid").after('<div class="c_dark_red phone_margin">please enter correct number</div>'),!1):void 0})});