function locale(){
  var c = document.cookie.split('; ');
  var tmp;
  for(var i = 0; i < c.length; i++) {
    tmp = c[i].split('=');
    if(tmp[0] == "locale") {
      break;
    }
  }
  return tmp[1];
}

$(".momentjs-time").each(function() {
  var time;
  var start = $(this).data("time");
  if(locale() == 'en') {
    moment.lang("en-ca");
    time = moment(start).tz("Asia/Chongqing").format("h:mm a, MMM Do");
  } else {
    moment.lang("zh-cn");
    time = moment(start).tz("Asia/Chongqing").format("MMMD日 Ah:mm");
  }

  $(this).html(time);
});

$(".momentjs-timeago").each(function() {
  var time;
  var start = $(this).data("timeago");
  if(locale() == 'en') {
    moment.lang("en-ca");
    time = moment(start).tz("Asia/Chongqing").fromNow();
  } else {
    moment.lang("zh-cn");
    time = moment(start).tz("Asia/Chongqing").fromNow();
  }

  $(this).html(time);
});
