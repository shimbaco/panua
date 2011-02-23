(function($) {
    var likeButton = $('button.like');
    var dislikeButton = $('button.dislike');
    var thisLikeButton = function(commentId) {
        return likeButton.filter('[comment-id="' + commentId + '"]');
    };
    var thisDislikeButton = function(commentId) {
        return dislikeButton.filter('[comment-id="' + commentId + '"]');
    };

    var likeCountInc = function (commentId, num) {
        var likeCount = $('span.like_count[comment-id="' + commentId + '"]');
        likeCount.text(parseInt(likeCount.text()) + (num));
    };
    var dislikeCountInc = function (commentId, num) {
        var dislikeCount = $('span.dislike_count[comment-id="' + commentId + '"]');
        dislikeCount.text(parseInt(dislikeCount.text()) + (num));
    };

    var likeCancel = function(commentId) {
        $.ajax({
            type: 'DELETE',
            url: '/comments/like/' + commentId,
            success: function() {
                thisLikeButton(commentId).removeClass('pushed');
                likeCountInc(commentId, -1);
            }
        });
    };

    var dislikeCancel = function(commentId) {
        $.ajax({
            type: 'DELETE',
            url: '/comments/dislike/' + commentId,
            success: function() {
                thisDislikeButton(commentId).removeClass('pushed');
                dislikeCountInc(commentId, -1);
            }
        });
    };

    //like
    likeButton.live('click', function() {
        var button = $(this);
        var commentId = button.attr('comment-id');
        if (button.hasClass('pushed')) {
            likeCancel(commentId);
        } else {
            $.ajax({
                type: 'POST',
                url: '/comments/like/' + commentId,
                success: function() {
                    button.addClass('pushed');
                    likeCountInc(commentId, 1);
                }
            });
        }
        if (thisDislikeButton(commentId).hasClass('pushed')) {
            dislikeCancel(commentId);
        }
        return false;
    });

    //dislike
    dislikeButton.live('click', function() {
        var button = $(this);
        var commentId = button.attr('comment-id');
        if (button.hasClass('pushed')) {
            dislikeCancel(commentId);
        } else {
            $.ajax({
                type: 'POST',
                url: '/comments/dislike/' + commentId,
                success: function() {
                    button.addClass('pushed');
                    dislikeCountInc(commentId, 1);
                }
            });
        }
        if (thisLikeButton(commentId).hasClass('pushed')) {
            likeCancel(commentId);
        }
        return false;
    });
})(jQuery);
