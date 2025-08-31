
// JS Scripts By Christopher W. Gonzalez D.K.A "gchriswill"
// Copyright (c) 2016-2025 Christopher W Gonzalez Melendez. All rights reserved.

// window.addEventListener("DOMContentLoaded", function() {
//     //alertingUser();
//     //console.log(window.innerHeight + " " + window.innerWidth);
// });

function alertingUser(){
    if (window.confirm("Thanks for visiting Toony Cam's website.\n\nA wild, fun and innovative project that started as a college project.\n\nPlease feel free to take a look at the publicly available archive on GitHub.\n\n\"> We hope to bring it back someday... 2.0 🤩\"\n\nWould you like to visit the GitHub repository?")) {
      window.open("https://github.com/gchriswill/toonycam", "_blank");
    }
}

// Release Date Timer ==================================================================================================
function getTimeRemaining(endtime){
  var t = Date.parse(endtime) - Date.parse(new Date() );
  var seconds = Math.floor((t / 1000) % 60);
  var minutes = Math.floor((t / 1000 / 60) % 60);
  var hours = Math.floor((t / (1000 * 60 * 60)) % 24);
  var days = Math.floor(t / (1000 * 60 * 60 * 24));
  return {
    'total': t,
    'days': days,
    'hours': hours,
    'minutes': minutes,
    'seconds': seconds
  };
}

function initializeClock(id, endtime) {
  var clock = document.getElementById(id);
  var daysSpan = clock.querySelector('.days');
  var hoursSpan = clock.querySelector('.hours');
  var minutesSpan = clock.querySelector('.minutes');
  var secondsSpan = clock.querySelector('.seconds');

  function updateClock() {
    var t = getTimeRemaining(endtime);

    daysSpan.innerHTML = t.days;
    hoursSpan.innerHTML = ('0' + t.hours).slice(-2);
    minutesSpan.innerHTML = ('0' + t.minutes).slice(-2);
    secondsSpan.innerHTML = ('0' + t.seconds).slice(-2);

    if (t.total <= 0) {
      clearInterval(timeinterval);
    }
  }

  updateClock();
  var timeinterval = setInterval(updateClock, 1000);
}

//var deadline = new Date("2017-03-03");
//console.log(new Date("2017-02-01"));
//initializeClock('clockdiv', deadline);
// =====================================================================================================================

// Custom Implementation for 'index' state =============================================================================
function toogleNav() {

    var pos = document.getElementById("navid");
    var menu = document.getElementById("hmenu_mb");
    var main = document.getElementsByTagName("main")[0];

    if (menu.innerHTML == "close") {

        menu.innerHTML = "menu";

        main.style.transition = "0.3s";
        main.style.opacity = "1";
        main.style.transform = "scale(1)";

        pos.style.transition = "0.3s";
        pos.style.transform = "translateX(-100px)";
        pos.style.visibility = "hidden";

    }else{

        menu.innerHTML = "close";

        main.style.transition = "0.6s";
        main.style.opacity = "0.5";
        main.style.transform = "scale(0.75)";

        pos.style.transition = "0.6s";
        pos.style.transform = "translateX(0px)";
        pos.style.visibility = "visible";

    }
}
