Most MikroTik devices are pretty Router/Switch level and despite the fact that they have a proxy service it's not usable for HTTPS/SNI/etc.
With MikroTik the only option is to use some external service or device.
The only real working solution I can recommend is some level of proxy or content filtering aware SSL deep inspection device/software.
(The solution is for desktops and as for mobile devices you will need to test first to make sure it fit your needs)

I wrote an example for a filtering service which is based on Fortinet/RedWood/Squid/Checkpoint/others and customized url categorizing.
I am using RedWood in production and have used Squid for a very long time but it lacks support for HTTP2 so there for RedWood.
The example service and the sources(GoLang and python ontop of docker compose) can be seen at:
https://github.com/elico/yt-classification-service-example

Technically speaking what you will need to define in the proxy or appliance if it can decrypt SSL is a policy which will include the relevant YouTube and other services url patterns.
For YouTube to work eventually you will need to allow their video CDN network which is under the domain *.googlevideo.com.
It is pretty safe to just allow all of the subdomains since google will require you to access their "Web portal"(technically speaking) urls like: `http://*.youtube.com/watch?v={video_id}...` Once you have the list of urls you want to allow on the youtube.com domain you will need to decide on the general policy which is either allow or deny all videos.
To block all videos you will need to eventually block the pattern `http://*.youtube.com/watch?v=*`.
In case you want to block also youtube thumbnail images and video snippets you will need to add another patterns to the setup.
Another piece which is not covered in the code is YouTube APIs which can provide to the end user "googlevideo.com" links.
One such a service name is: LiteTube which embeds the googlevideo.com urls inside the html of the page.
I am not aware of someone else then me that have implemented a prediction of the relevant googlevideo.com links for a video and allow only these.
However I have not published this code yet, I do expect big appliances and cloud services companies to implement this without my help..

If you are familiar with regex and bash enough you would be able to learn the relevant patterns from another script/code I wrote for the CheckPoint embedded NGFW 1500 series which is based on R80.20 at:
https://github.com/elico/checkpoint-vid-filtering-managment

Probably the relevant REGEX for this purpose are:

{{{
(^|.*\.)youtube\.com/embed/##VID##
(^|.*\.)youtube\.com/watch\?v=##VID##
(^|.*\.)ytimg\.com/.*/##VID##/
(^|.*\.)youtu\.be/.*##VID##.*
}}}

Please pay attention that the url query parameters position can be changed per request so you might need to tweak the regex if you will have someone trying to override these restrictions.

I don't know the scenario but I always recommend on educating first before the issues comes if possible. This is what why I wrote this long response.

I have been working on public white lists of YouTube videos not everyone shares the same ideals of me so it's very hard to whitelist and expect everyone to agree with this.

If you or anyone wants to implement squid with ssl bump and have a service that does the same you might want to look at the sources this ruby service I wrote at:
https://github.com/elico/squid-external-matchers/blob/master/youtube-id-matcher.rb
