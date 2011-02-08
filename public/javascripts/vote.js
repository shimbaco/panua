(function($) {
    var like_button = $('button.like');
    var dislike_button = $('button.dislike');
    var this_like_button = function(comment_id) {
        return like_button.filter('[comment-id="' + comment_id + '"]');
    };
    var this_dislike_button = function(comment_id) {
        return dislike_button.filter('[comment-id="' + comment_id + '"]');
    };

    var like_count_inc = function (comment_id, num) {
        var like_count = $('span.like_count[comment-id="' + comment_id + '"]');
        like_count.text(parseInt(like_count.text()) + (num));
    };
    var dislike_count_inc = function (comment_id, num) {
        var dislike_count = $('span.dislike_count[comment-id="' + comment_id + '"]');
        dislike_count.text(parseInt(dislike_count.text()) + (num));
    };

    var like_cancel = function(comment_id) {
        $.ajax({
            type: 'DELETE',
            url: '/comments/like/' + comment_id,
            success: function() {
                this_like_button(comment_id).removeClass('pushed');
                like_count_inc(comment_id, -1);
            }
        });
    };

    var dislike_cancel = function(comment_id) {
        $.ajax({
            type: 'DELETE',
            url: '/comments/dislike/' + comment_id,
            success: function() {
                this_dislike_button(comment_id).removeClass('pushed');
                dislike_count_inc(comment_id, -1);
            }
        });
    };

    //like
    like_button.live('click', function() {
        var button = $(this);
        var comment_id = button.attr('comment-id');
        if (button.hasClass('pushed')) {
            like_cancel(comment_id);
        } else {
            $.ajax({
                type: 'POST',
                url: '/comments/like/' + comment_id,
                success: function() {
                    button.addClass('pushed');
                    like_count_inc(comment_id, 1);
                }
            });
        }
        if (this_dislike_button(comment_id).hasClass('pushed')) {
            dislike_cancel(comment_id);
        }
        return false;
    });

    //dislike
    dislike_button.live('click', function() {
        var button = $(this);
        var comment_id = button.attr('comment-id');
        if (button.hasClass('pushed')) {
            dislike_cancel(comment_id);
        } else {
            $.ajax({
                type: 'POST',
                url: '/comments/dislike/' + comment_id,
                success: function() {
                    button.addClass('pushed');
                    dislike_count_inc(comment_id, 1);
                }
            });
        }
        if (this_like_button(comment_id).hasClass('pushed')) {
            like_cancel(comment_id);
        }
        return false;
    });
})(jQuery);
