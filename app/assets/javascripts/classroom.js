var serverUrl = "/";
var localStream, room;
var conference = document.getElementById('conference');
var dataEvent;

function getParameterByName(name) {
  name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
  var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
  results = regex.exec(location.search);
  return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function sendd() {
  if (localStream !== undefined) {
    localStream.sendData({text:'Hello', timestamp:(new Date()).getTime()});
  }
}

function hidev (tag) {
  if (localStream !== undefined) {
    localStream.hide(tag);
  }
}

function showv (tag) {
  if (localStream !== undefined && localStream.showing !== true) {
    localStream.show(tag);
  }
}

function unpub () {
  if (localStream !== undefined && room !== undefined) {
    room.unpublish(localStream);
  };
}

function pub () {
  if (localStream !== undefined && room !== undefined) {
    room.publish(localStream);
  };
}

function subs(st) {
  if (room !== undefined) {
    if (st === undefined) {
      for (var i in room.remoteStreams) {
        var stream = room.remoteStreams[i];
        if (localStream.getID() !== stream.getID()) {
          room.subscribe(stream);
        }
      }
    } else if(st.getID() !== localStream.getID()) {
      room.subscribe(st);
    }
  };
}

function unsub(st) {
  if (room !== undefined) {
    if (st === undefined) {
      for (var i in room.remoteStreams) {
        var stream = room.remoteStreams[i];
        if (localStream.getID() !== stream.getID()) {
          room.unsubscribe(stream);
          stream.removeEventListener("stream-data", dataEvent);
        }
      }
    } else if(st.getID() !== localStream.getID()) {
      room.unsubscribe(st);
      stream.removeEventListener("stream-data", dataEvent);
    }
  };
}

function room_disconn() {
  if (room !== undefined) {
    room.disconnect();
    localStream.close();
  }
}

window.onload = function() {
  dataEvent = function(evt) {
    console.log('Received data ', evt.msg);
    var div = document.createElement('div');
    div.setAttribute("class", "alert alert-info");
    div.innerHTML='<button type="button" class="close" data-dismiss="alert">&times;</button><strong>Received: </strong>'+evt.msg.text;
    document.getElementById('messenger').appendChild(div);
    $(".alert").delay(2000).addClass("in").fadeOut(4000);
  };

  var screen = getParameterByName("screen");
  var isPublish = getParameterByName("publish");
  var isSubscribe = getParameterByName("subscribe");
  var resolution = getParameterByName("resolution");
  var targetRoom = getParameterByName("room");
  var name = getParameterByName("name");
  var video_constraints = true;
  if(resolution != "") {
    var ints = /^[0-9]*[1-9][0-9]*$/;
    var frameSize = resolution.split(/x/i);
    if(frameSize.length == 2 && ints.test(frameSize[0]) && ints.test(frameSize[1])) {
      if(frameSize[1] > 480) {
        video_constraints = {
          mandatory: {
            minWidth: frameSize[0],
            minHeight: frameSize[1]
          },
          optional: []
        };
      }
      else {
        video_constraints = {
          mandatory: {
            maxWidth: frameSize[0],
            maxHeight: frameSize[1]
          },
          optional: []
        };
      }
    }
  }

  localStream = Woogeen.Stream({audio: true, video: video_constraints, data: true, screen: screen, attributes:{name:name}});

  var createToken = function(userName, role, room, callback) {
    var req = new XMLHttpRequest();
    var url = serverUrl + 'createToken/';
    var body = {username: userName, role: role, room: room};

    req.onreadystatechange = function () {
      if (req.readyState === 4) {
        callback(req.responseText);
      }
    };

    req.open('POST', url, true);
    req.setRequestHeader('Content-Type', 'application/json');
    req.send(JSON.stringify(body));
  };

  createToken("user", "role", targetRoom, function (response) {
    var token = response;
    console.log(token);
    room = Woogeen.Room({token: token});

    localStream.addEventListener("access-accepted", function () {

      var subscribeToStreams = function (streams) {
        for (var index in streams) {
          var stream = streams[index];
          if (localStream.getID() !== stream.getID()) {
            room.subscribe(stream);
          }
        }
      };

      room.addEventListener("room-connected", function (roomEvent) {
      //  room.setMode("mix");
        if(isPublish == "" || isPublish == "true") {
          room.publish(localStream);
        }

        if(isSubscribe == "" || isSubscribe == "true") {
          subscribeToStreams(roomEvent.streams);
        }
      });

      room.addEventListener("stream-subscribed", function(streamEvent) {

        var stream = streamEvent.stream;
        var attr = stream.getAttributes() || {};
        var name = attr.name;
        console.log("name:" + name);
        if (!attr.width || !attr.height) {
          attr = {width:320, height:240};
        }
        var div = document.createElement('div');
        div.setAttribute("style", "width: "+attr.width+"px; height: "+attr.height+"px;");
        div.setAttribute("id", "test" + stream.getID());

        conference.appendChild(div);
        stream.addEventListener("stream-data",dataEvent);
        stream.show("test" + stream.getID());
      });

      room.addEventListener("stream-added", function (streamEvent) {
        if(isSubscribe == "" || isSubscribe == "true") {
          var streams = [];
          streams.push(streamEvent.stream);
          subscribeToStreams(streams);
        }
      });

      room.addEventListener("stream-removed", function (streamEvent) {
        // Remove stream from DOM
        var stream = streamEvent.stream;
        if (stream.elementID !== undefined) {
          var element = document.getElementById(stream.elementID);
          if (element) {
            conference.removeChild(element);
          }
        }
      });

      room.connect();

      localStream.show("myVideo");
      var localView=document.querySelector("#myVideo video");
      if(localView)
        localView.setAttribute("muted", "muted");
    });

    localStream.init();
  });
};