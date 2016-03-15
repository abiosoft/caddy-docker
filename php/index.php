<!DOCTYPE html>
<html>
<head>
<title>Caddy</title>
<style>
    body {
        text-align: center;
        font-family: Tahoma, Geneva, Verdana, sans-serif;
    }
</style>
</head>
<body>
<h1>Caddy web server.</h1>
<p>If you see PHP info below, Caddy with PHP container works.</p>

<p>More instructions about this image is <a href="//github.com/abiosoft/caddy-docker/blob/master/README.md" target="_blank">here</a>.<p>
<p>More instructions about Caddy is <a href="//caddyserver.com/docs" target="_blank">here</a>.<p>
<?php 
    phpinfo() 
?>
</body>
</html>