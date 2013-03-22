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

function getJson(url) {
  return $.ajax({
    type: 'GET',
    url: url,
    dataType: 'json'
  });
}

function initNumberShow(number) {
  rcLat = 2;
  rcLon = 3;
  initializeMap();
}
