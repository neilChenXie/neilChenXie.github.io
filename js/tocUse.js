var config = {
	listType: 'ul',
	headers: 'h2, h3, h4, h5, h6',
	minimumHeaders: 1,
};

$(document).ready(function() {
	var emWidth = $(window).width() / parseFloat($("body").css("font-size"));
	if (emWidth >= 64 ) {
		$('#big_toc').toc(config);
	} else {
		$('#tiny_toc').toc(config);
	}
});
