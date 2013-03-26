function initializeMap() {
  var gmap = document.createElement("script");
  gmap.type = "text/javascript";
  gmap.src = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=mapCallback";
  (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(gmap);
}

function mapCallback() {
  updateMap(rcLat, rcLon, 'Number Near Here');
}

function updateMap(lat, lon, markerTitle) {
  var myLatlng = new google.maps.LatLng(lat, lon);
  var myOptions = {
    zoom: 10,
    center: myLatlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  var marker = new google.maps.Marker({
      position: myLatlng,
      map: map,
      animation: google.maps.Animation.DROP,
      title: markerTitle
  });
}

function retrieveCallerId(caller_id_path) {
  return $.ajax({
    type: 'GET',
    url: caller_id_path,
    dataType: 'json',
    success: callerIdSuccess,
    error: callerIdError
  });
}

function callerIdSuccess(requestedObject) {
  if (requestedObject) {
    $('#caller-id').text(requestedObject);
  } else {
    $('#caller-id').text('Unknown');
  }
}

function callerIdError() {
  $('#caller-id').text('Temporarily Unknown');
}

function retrieveTelcoInfo(telco_info_path) {
  return $.ajax({
    type: 'GET',
    url: telco_info_path,
    dataType: 'json',
    success: telcoInfoSuccess,
    error: telcoInfoError
  });
}

function telcoInfoSuccess(requestedObject) {
  if (requestedObject) {
    $('#carrier-company').text(requestedObject.company_name);
    $('#rate-center').text(requestedObject.rc);
    $('#region').text(requestedObject.region);
    $('#ilec').text(requestedObject.ilec_name);
    $('#latitude').text(requestedObject.rc_lat);
    $('#longitude').text(requestedObject.rc_lon);


    $('#carrier-type').text(requestedObject.company_type);
    $('#exchange').text(requestedObject.exch);
    $('#ilec-ocn').text(requestedObject.ilec_ocn);
    $('#lata').text(requestedObject.lata);
    $('#switch').text(requestedObject.switch);
    $('#switch-name').text(requestedObject.switchname);
    $('#switch-type').text(requestedObject.switchtype);
    $('#rc-h').text(requestedObject.rc_h);
    $('#rc-v').text(requestedObject.rc_v);

    rcLat = requestedObject.rc_lat;
    rcLon = requestedObject.rc_lon;
  } else {
    $('#carrier-company').text('Unknown');
    $('#rate-center').text('Unknown');
    $('#region').text('Unknown');
    $('#ilec').text('Unknown');
    $('#latitude').text('Unknown');
    $('#longitude').text('Unknown');

    $('#carrier-type').text('Unknown');
    $('#exchange').text('Unknown');
    $('#ilec-ocn').text('Unknown');
    $('#lata').text('Unknown');
    $('#switch').text('Unknown');
    $('#switch-name').text('Unknown');
    $('#switch-type').text('Unknown');
    $('#rc-h').text('Unknown');
    $('#rc-v').text('Unknown');

    rcLat = 0;
    rcLon = 0;
  }

  initializeMap();
}

function telcoInfoError() {
  $('#carrier-company').text('Temporarily Unknown');
  $('#rate-center').text('Temporarily Unknown');
  $('#region').text('Temporarily Unknown');
  $('#ilec').text('Temporarily Unknown');
  $('#latitude').text('Temporarily Unknown');
  $('#longitude').text('Temporarily Unknown');

  $('#carrier-type').text('Temporarily Unknown');
  $('#exchange').text('Temporarily Unknown');
  $('#ilec-ocn').text('Temporarily Unknown');
  $('#lata').text('Temporarily Unknown');
  $('#switch').text('Temporarily Unknown');
  $('#switch-name').text('Temporarily Unknown');
  $('#switch-type').text('Temporarily Unknown');
  $('#rc-h').text('Temporarily Unknown');
  $('#rc-v').text('Temporarily Unknown');

  rcLat = 0;
  rcLon = 0;
  initializeMap();
}

function initNumberShow(caller_id_path, telco_info_path, type) {
  if (type == 1) {
    retrieveCallerId(caller_id_path);
  }
  retrieveTelcoInfo(telco_info_path);
}
