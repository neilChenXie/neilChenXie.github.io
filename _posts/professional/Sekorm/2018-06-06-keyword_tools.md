---
title: 关键词小工具
date: 2018-06-06 20:30:15 +0800
category: Sekorm
tags: [tools]
---

### 小工具

<input type="text" id="adj" placeholder="低功耗,高主频"/>
<input type="text" id="noun" placeholder="mcu,单片机"/>
<input type="button" id="create" value="create"/>
<p id="result">低功耗mcu,低功耗单片机,高主频mcu,高主频单片机</p> 

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

### Code

代码如下

```html
<input type="text" id="adj"/>
<input type="text" id="noun"/>
<input type="button" id="create" value="create"/>
<p id="result"></p> 
```

```js
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
```
