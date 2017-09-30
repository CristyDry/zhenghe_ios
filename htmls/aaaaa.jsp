<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><meta name="format-detection" content="telephone=no" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />

<style>
body { font: normal 100% Helvetica, Arial, sans-serif; }p {text-indent: 0em;}small { font-size: 0.875em; }  .main { float: left; width: 100%; } .leftBar { float: left; width: 25%; }  img { max-width: 100%; }object { max-width: 100%;}img { -ms-interpolation-mode: bicubic; }

</style>



    <script type="text/javascript">
       /*此方法给android 使用*/
  /*      function test(value){
            var oEvent=ev||event;
            var x=oEvent.clientX;
            var y=oEvent.clientY;
            var rs="{\"y\":"+y+",\"x\":"+x+",\"value\":"+value+"}";
          *//*  js 调用java 方法   jsObj.HtmlcallJava 是android 暴露出来的java 方法*//*
            window.jsObj.HtmlcallJava(rs);
        }
*/
  /* 此方法给ios调用     */
function test(value){
   // alert(1212);
    var oEvent=window.event;
    var x=oEvent.clientX;
    var y=oEvent.clientY;
    var rs="{\"y\":"+y+",\"x\":"+x+",\"value\":"+value+"}";
    //alert(rs);
    document.location = rs;
}

    </head><body><div id="small" class="main">content</div></body></html>
<body>
是开放源代码的<a href=\"javascript:void(0);\"  onclick=\"return test('免费软');\">___<\/a>件。可以到其官方网站上下载最新版本，本文使用1.0.10版
</body>

</html>" ;