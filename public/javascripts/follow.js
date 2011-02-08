(function($) {
    //フォロー
    $('.follow-state button.follow').live('click', function() {
        var button = $(this);
        var user_id = button.attr('user-id');
        $.ajax({
            type: 'POST',
            url: '/users/follow/' + user_id,
            success: function() {
                button.removeClass('follow').addClass('remove pushed').text('following');
            }
        });
        return false;
    });

    //フォローしてる人のボタンにカーソルを乗せたらremoveと表示する。離れたらもとに戻す(followingと表示する)。
    var remove_button = $('.follow-state button.remove');
    remove_button.live('mouseover', function() {$(this).text('remove');});
    remove_button.live('mouseout', function() {$(this).text('following');});

    //リムーブ
    $('.follow-state button.remove').live('click', function() {
        var button = $(this);
        var user_id = button.attr('user-id');
        $.ajax({
            type: 'DELETE',
            url: '/users/remove/' + user_id,
            success: function() {
                button.removeClass('remove pushed').addClass('follow').text('follow');
            }
        });
        return false;
    });
})(jQuery);
