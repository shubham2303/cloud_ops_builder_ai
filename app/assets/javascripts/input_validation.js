$(document).ready(function(){
    $(document).on('click',".submit_valid",function(){
        $(".phone_margin").remove();
        // $(".inline-errors").remove();
        var value = $(".phone_valid").val();
        var beat_code = $( ".beat_code" ).val();

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
        else if(beat_code == ""){
            $('.beat_code').after(
                '<div class="c_dark_red phone_margin">please choose some value according to lga</div>'
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

    $(document).on('change',".lga",function(){
        var lga  = this.value;
        $.ajax({
            url: "/admin/revenue_beats",
            type: "GET",
            data: {lga : lga},
            success: function(data){
                $(".beat_code").html('<option value="">Please select</option>');
                for(var k in data){
                    $(".beat_code").append('<option value="'+k+'">' + data[k] + '</option>');
                }
            }
        });

    });
});
