<%
	# generated by biojs-galaxy

    default_title = "{{ name }} of '" + hda.name + "'"
    info = hda.name
    if hda.info:
        info += ' : ' + hda.info

    # Use root for resource loading.
    root = h.url_for( '/' )
%>
## ----------------------------------------------------------------------------

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${title or default_title} | ${visualization_display_name}</title>

{{#js}}
${h.javascript_link( root + 'plugins/visualizations/{{name}}/static/{{.}}' )}
{{/js}}
{{#css}}
${h.stylesheet_link( root + 'plugins/visualizations/{{name}}/static/{{.}}' )}
{{/css}}

</head>

## ----------------------------------------------------------------------------
<body>
<div>
    <h2>${title or default_title}</h2>
</div>

<div id="galaxyContainer"></div>

<script type="text/javascript">
	var galaxy = {};
    galaxy.config  = ${h.dumps( config )};
    galaxy.meta = ${h.dumps( trans.security.encode_dict_ids( hda.to_dict() ), indent=2 )};
    galaxy.dataType = galaxy.meta.data_type;

    galaxy.title   = "${title or default_title}";
    galaxy.jsonURL = "${root}api/datasets/"+galaxy.config.dataset_id+"?data_type=raw_data&provider=base";
    galaxy.url = "${root}api/histories/"+galaxy.config.dataset_id+"/contents/" +galaxy.config.dataset_id+ "/display";
    galaxy.el = document.getElementById("galaxyContainer");
    galaxy.relativeURL = "${root}/plugins/visualizations/{{name}}";

    // tiny xhr library from https://github.com/toddmotto/atomic

	var xhr = function(){
		var exports = {};

    	var parse = function (req) {
    	  var result;
    	  try {
    	    result = JSON.parse(req.responseText);
    	  } catch (e) {
    	    result = req.responseText;
    	  }
    	  return [result, req];
    	};
  
    	var xhr = function (type, url, data) {
    	  var methods = {
    	    success: function () {},
    	    error: function () {}
    	  };
    	  var XHR = window.XMLHttpRequest || ActiveXObject;
    	  var request = new XHR('MSXML2.XMLHTTP.3.0');
    	  request.open(type, url, true);
    	  request.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    	  request.onreadystatechange = function () {
    	    if (request.readyState === 4) {
    	      if (request.status >= 200 && request.status < 300) {
    	        methods.success.apply(methods, parse(request));
    	      } else {
    	        methods.error.apply(methods, parse(request));
    	      }
    	    }
    	  };
    	  request.send(data);
    	  var callbacks = {
    	    success: function (callback) {
    	      methods.success = callback;
    	      return callbacks;
    	    },
    	    error: function (callback) {
    	      methods.error = callback;
    	      return callbacks;
    	    }
    	  };
  
    	  return callbacks;
    	};
  
    	exports['get'] = function (src) {
    	  return xhr('GET', src);
    	};
  
    	exports['put'] = function (url, data) {
    	  return xhr('PUT', url, data);
    	};
  
    	exports['post'] = function (url, data) {
    	  return xhr('POST', url, data);
    	};
  
    	exports['delete'] = function (url) {
    	  return xhr('DELETE', url);
    	};

    	return exports;
    }();
    galaxy.xhr = xhr;

    galaxy.getData = function(cb){
		var req = galaxy.xhr.get(galaxy.url);
		req.success(cb);
		req.error(function(data, xhr){
			// TODO: more elegant error handling
			galaxy.el = "Error happened. " + JSON.parse(data);
		});
    }

	{{ & jsContent }}

</script>

</body>
</html>
