---
title: 关键词小工具
date: 2018-06-06 20:30:15 +0800
category: Sekorm
tags: [tools]
---

<input type="text" id="adj"/>
<input type="text" id="noun"/>
<input type="button" id="create" value="create"/>
<p id="result"></p> 

<script>
$("#create").click(function(){
  $("#result").empty();
  var res=new Array();
  var adjs = $("#adj").val().split(/[,，]/);
  var nouns= $("#noun").val().split(/[,，]/);
  $.each(adjs,function(i,part1) {
    
    $.each(nouns,function(j,part2) {
        $("#result").prepend(part1+part2+",");
      });
    
    });
});
</script>

