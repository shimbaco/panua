(function($) {
    //フォロー
    $('.follow-state button.follow').live('click', function() {
        var button = $(this);
        var userId = button.attr('user-id');
        $.ajax({
            type: 'POST',
            url: '/users/follow/' + userId,
            success: function() {
                button.removeClass('follow').addClass('remove pushed').text('following');
            }
        });
        return false;
    });

    //フォローしてる人のボタンにカーソルを乗せたらremoveと表示する。離れたらもとに戻す(followingと表示する)。
    var removeButton = $('.follow-state button.remove');
    removeButton.live('mouseover', function() {$(this).text('remove');});
    removeButton.live('mouseout', function() {$(this).text('following');});

    //リムーブ
    $('.follow-state button.remove').live('click', function() {
        var button = $(this);
        var userId = button.attr('user-id');
        $.ajax({
            type: 'DELETE',
            url: '/users/remove/' + userId,
            success: function() {
                button.removeClass('remove pushed').addClass('follow').text('follow');
            }
        });
        return false;
    });
})(jQuery);
