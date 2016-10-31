<#import "/spring.ftl" as spring />

<html>
<head>
    <title>Grant access</title>
</head>
<body>
<h2>Grant access</h2>

<p>The application <b>${clientApp.name}</b> would like the ability to read and update your data on TeamHub.</p>

<form action="<@spring.url "/oauth/authorize" />" method="post">
    <input name="oauth_token" value="${oauth_token}" type="hidden" />
    <p><button type="submit">Authorize</button></p>
</form>
</body>
</html>