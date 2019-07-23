// 本ファイルには、Jqueryで操作する設定を書く


// ボタンを押されると、メニューが出る
$(function() {
 
    $('.menu-trigger').on('click', function() {
      // $(this).toggleClass('active');
      // メニューの非表示、表示を切り替える
      $('#search-menu').fadeToggle();
      return false;
    });
   
});

// 画面遷移用
$(function () {
  $(".animsition").animsition();
});