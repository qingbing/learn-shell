/**
 * HTML 布局
 * .player[data-num-control][data-carousel-control][data-interval]>ul.items>(li>img+div.carousel-caption>(h3+p))*3
 * 参数设置
 *  num-control : 是否有数字控制，true为需要
 *  carousel-control : 是否有左右控制，true为需要
 *  interval : 轮播间隔时间
 */
(function ($) {
    $('.player').each(function (i) {
        var $player = $(this);
        // 添加幻灯片类
        $player.addClass("carousel slide").attr("data-ride", "carousel");
        // 获取ID
        var id = $player.attr('id');
        if (!id) {
            id = "player-" + i;
            $player.attr('id', id);
        }
        var $items = $player.find('.items').addClass('carousel-inner').addClass("list-unstyled");
        // 激活第一项
        $items.children('li').addClass('item').eq(0).addClass('active');

        var k = 0, total = $items.children('li').length;
        // 添加数字控制
        if (0 === $player.find(".carousel-indicators").length && $player.data("num-control")) {
            var $ol = $('<ol class="carousel-indicators"></ol>');
            for (k = 0; k < total; k++) {
                if (0 === k) {
                    $ol.append('<li data-target="#' + id + '" data-slide-to="' + k + '" class="active"></li>');
                    continue;
                }
                $ol.append('<li data-target="#' + id + '" data-slide-to="' + k + '"></li>');
            }
            $ol.prependTo($player);
        }
        // 左右控制
        if (0 === $player.find(".carousel-control").length && $player.data("carousel-control")) {
            $player.append('<a class="left carousel-control" href="#' + id + '" role="button" data-slide="prev">' +
                '<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>' +
                '<span class="sr-only">Previous</span>' +
                '</a>' +
                '<a class="right carousel-control" href="#' + id + '" role="button" data-slide="next">' +
                '<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>' +
                '<span class="sr-only">Next</span>' +
                '</a>');
        }
        $player.carousel();
    })
})(jQuery);