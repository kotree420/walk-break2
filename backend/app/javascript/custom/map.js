let map;
let directionsService;
let directionsRenderer;
let geocoder;
let poly;
let polyline;

function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    zoom: 15,
    center: { lat: 35.681862, lng: 139.767174 }, //初期表示位置は東京駅
  });

  directionsService = new google.maps.DirectionsService();
  directionsRenderer = new google.maps.DirectionsRenderer({
    draggable: true,
    map
  });
  directionsRenderer.setMap(map);
  geocoder = new google.maps.Geocoder();

  // walking_routes#new
  if (document.getElementById("add-waypoint")) {
    document.getElementById("add-waypoint").addEventListener("click", () => {
      const form_count = document.querySelectorAll(".waypoint").length + 1;
      const max_waypoint_count = 10; // 経由地点が10を越えると課金レートが高くなるため

      if (form_count <= max_waypoint_count) {
        const new_div = document.createElement("div");
        new_div.className = "waypoint-wrapper form-floating mb-3";

        const new_label = document.createElement("label");
        new_label.className ="waypoint-label";
        new_label.textContent = "経由地(" + form_count + "):";

        const new_form = document.createElement("input");
        new_form.className = "waypoint form-control";
        new_form.id = "waypoint" + form_count;
        new_form.type = "text";
        new_form.placeholder = "有楽町駅";

        new_div.appendChild(new_form);
        new_div.appendChild(new_label);
        document.getElementById("waypoints").appendChild(new_div);
      };
    });

    document.getElementById("remove-waypoint").addEventListener("click", () => {
      const delete_label = document.getElementById("waypoints").lastChild;
      delete_label.remove();
      const directions_removed_waypoint = directionsRenderer.getDirections();
      if (directions_removed_waypoint) {
        displayRoute(directionsService, directionsRenderer);
        computeRouteInformation(directions_removed_waypoint);
      };
    });

    document.getElementById("display-route").addEventListener("click", () => {
      displayRoute(directionsService, directionsRenderer);
    });
  }

  directionsRenderer.addListener("directions_changed", () => {
    const directions = directionsRenderer.getDirections();
    if (directions) {
      computeRouteInformation(directions);
    };
  });

  // walking_routes#show
  if (document.getElementById("show-start-address-label") && document.getElementById("show-end-address-label")) {
    window.addEventListener("load", () => {
      let show_start_address = document.getElementById("show-start-address").innerText;
      geocoder.geocode({ 'address': show_start_address })
        .then( ({results}) => {
          if (results[0]) {
            // show-start-addressをセンターにする
            map.setCenter(results[0].geometry.location);
          } else {
            window.alert("No waypoint results found");
          };
        })
        .catch((e) => window.alert("Geocoder failed due to: " + e));

      show_polyline = document.getElementById("show-encorded-path").value;
      displayPolyline(show_polyline);
    });
  }
}

function displayRoute(directionsService, directionsRenderer) {
  const start = document.getElementById('start').value;
  const end = document.getElementById('end').value;
  const waypoints = [];
  const inputArray = document.getElementsByClassName("waypoint");

  for (let i = 0; i < inputArray.length; i++) {
    if (inputArray.item(i).value){
      waypoints.push({
        location: inputArray[i].value,
        stopover: true
      });
    };
  };

  const request = {
    origin: start,
    destination: end,
    waypoints: waypoints,
    travelMode: 'WALKING',
  };

  directionsService.route(request)
    .then((result) => {
      directionsRenderer.setDirections(result);
      computeRouteInformation(result);
    })
    .catch((e) => {
      alert("Could not display directions due to: " + e);
    });
}

function computeRouteInformation(result) {
  const route = result.routes[0];
  let total_distance = 0;
  let total_duration = 0;

  if (!route) {
    return;
  }

  const geocoded_waypoints = result.geocoded_waypoints;
  const start_form = document.getElementById('start');
  const end_form = document.getElementById('end');
  const waypoint_forms = document.getElementsByClassName("waypoint");

  for (let i = 0; i < route.legs.length; i++) {
    const routeSegment = i + 1;
    total_distance += route.legs[i].distance.value;
    total_duration += route.legs[i].duration.value;

    // 出発地、到着地の入力フォームへ正式住所を反映
    if (routeSegment == 1) {
      start_form.value = route.legs[i].start_address;
      end_form.value = route.legs[i].end_address;
    } else {
      if (i == 0) {
        start_form.value = route.legs[i].start_address;
      } else if (i == (route.legs.length - 1)){
        end_form.value = route.legs[i].end_address;
      };
    };
  };
  total_distance = total_distance / 1000;
  total_duration = Math.round(total_duration / 60);
  document.getElementById("total-distance").value = total_distance;
  document.getElementById("total-duration").value = total_duration;

  // 経由地の入力フォームへ正式住所を反映
  // geocoded_waypoints配列では最初の要素が出発地点のplaceId、最後の要素が到着地点のplaceIdとなっている
  for (let i = 0, j = 1; i < waypoint_forms.length, j < (geocoded_waypoints.length - 1); i++, j++) {
    if (waypoint_forms.item(i).value){
      const waypoint_place_id = geocoded_waypoints[j].place_id;
      geocoder.geocode({ placeId: waypoint_place_id })
        .then( ({results}) => {
          if (results[0]) {
            waypoint_forms.item(i).value = results[0].formatted_address;
          } else {
            window.alert("No waypoint results found");
          };
        })
        .catch((e) => window.alert("Geocoder failed due to: " + e));
    };
  };

  // 作成したルートのポリラインを保存
  polyline = result.routes[0].overview_polyline;
  document.getElementById("new-encorded-path").value = polyline;
};

function displayPolyline(polyline) {
  const encorded_path = google.maps.geometry.encoding.decodePath(polyline);

  poly = new google.maps.Polyline({
    path: encorded_path,
    geodesic: true,
    strokeWeight: 5,
    strokeColor: "#f01010",
    strokeOpacity: 0.6
  });
  poly.setMap(map);
}

window.initMap = initMap;
