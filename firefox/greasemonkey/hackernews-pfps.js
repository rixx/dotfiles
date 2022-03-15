// ==UserScript==
// @name     hackernews-pfps
// @include  https://news.ycombinator.com/*
// @version  1
// ==/UserScript==

// via https://news.ycombinator.com/item?id=30668137

for(u of document.querySelectorAll('.hnuser, #me'))for(u.prepend(c=document.createElement('canvas')),x=c.getContext('2d'),c.width=18,c.height=14,s=u.innerText,r=1,i=28+s.length;i--;i<28?r>>>29>X*X/3+Y/2&&x.fillRect(6+2*X,2*Y,2,2)&x.fillRect(6-2*X,2*Y,2,2):r+=s.charCodeAt(i-28,x.fillStyle='#'+(r>>8&0xFFFFFF).toString(16)))r^=r<<13,r^=r>>>17,r^=r<<5,X=i&3,Y=i>>2
