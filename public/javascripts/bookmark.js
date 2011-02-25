(function($) {
    $('#bookmark_url').focusout(function() {
        if ($('#bookmark_url').val() != '' && $('#bookmark_title').val() == '') {
            $('<img src="/images/loading.gif">').appendTo('dt#title').hide().fadeIn("slow");
            $.ajax({
                type: 'GET',
                url: '/bookmarks/get_page_title.json',
                data: ({url : $("#bookmark_url").val()}),
                success: function(data) {
                    $("#bookmark_title").val(data.title);
                    $('dt#title img').fadeOut();
                }
            });
        }
    });
})(jQuery);