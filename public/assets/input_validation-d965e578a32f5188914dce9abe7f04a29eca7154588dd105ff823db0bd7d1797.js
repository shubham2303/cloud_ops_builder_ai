$(document).ready(function(){
    $(document).on('click',".submit_valid",function(){
        $(".phone_margin").remove();
        // $(".inline-errors").remove();
        var value = $(".phone_valid").val();
        if (value.length >11 || value.length < 10) {
            $('.phone_valid').after(
                '<div class="c_dark_red phone_margin">length should be between 10 or 11 digits</div>'
            );
            return false;
        }
        else if((value.length == 11 && value[0] != '0')||(value.length == 10 && value[0] == '0')){
            $('.phone_valid').after(
                '<div class="c_dark_red phone_margin">please enter correct number</div>'
            );
            return false;
        }

    });

    $(".time").each(function(index){
        // alert($(this).val());
        if (index >0) {
            var text = $(this).text()
            var date = new Date(text + ' UTC');

            $(this).text(date.toLocaleDateString() +' '+date.toLocaleTimeString());
        }
    });
        var offset = new Date().getTimezoneOffset();
        $('.time_format').val(offset);


    // $(".flashes" ).fadeOut(5000);
});
