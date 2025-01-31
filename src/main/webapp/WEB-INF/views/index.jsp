<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: humin
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<html>
<head>

    <script src='https://code.jquery.com/jquery-3.3.1.min.js'></script>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>豆瓣电影1S</title>
    <script type="text/javascript">


        // 豆瓣V2 API url apiKey
        var url_douban = "https://api.douban.com";
        var apikey_douban = "apikey=0b2bdeda43b5688921839c8ecb20399b";

        var currentUser=<%=session.getAttribute("currentUser")%>;

        $(document).ready(function () {

            //-------------------------
            console.log("session currentUser: ");
            console.log(currentUser);

            // getUserSession();
            getNewMovies();
            
        });

        // ajax search 智能提醒----------------------------- start

        var xmlhttp;
        // 异步获取用户输入的信息
        function getMoreNames() {
            var name = document.getElementById("keyword");
            if (name.value == "") {
                clearName();
                return;
            }
            xmlhttp = newAjax();
            // var url="search?name="+escape(name.value);
            var url = "searchTips?keyword=" + name.value;
            // xmlhttp.responseType='json';
            // true 异步
            xmlhttp.open("GET", url, true);
            // 调用回调方法
            xmlhttp.onreadystatechange = callback;
            xmlhttp.send();
        }

        //通用获取xmlhttp方法
        function newAjax() {
            try {
                return new XMLHttpRequest();
            } catch (e) {
            }
            try {
                return new ActiveXObject('Msxml2.XMLHTTP.6.0');
            } catch (e) {
            }
            try {
                return new ActiveXObject('Msxml2.XMLHTTP.3.0');
            } catch (e) {
            }
            try {
                return new ActiveXObject('Msxml2.XMLHTTP');
            } catch (e) {
            }
            try {
                return new ActiveXObject('Microsoft.XMLHTTP');
            } catch (e) {
            }
            return false;
        }


        // 回调方法
        function callback() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                var result = JSON.parse(xmlhttp.responseText);
                showTips(result.data);
            }
        }

        // 设置tips展示
        function showTips(json) {
            clearName();
            setLocation();
            for (var i = 0; i < json.length; i++) {

                var tr = document.createElement("tr");
                var tdForName = document.createElement("td");
                var tdForRate = document.createElement("td");

                tdForName.setAttribute("border", 0);
                tdForName.setAttribute("size", "40");
                tdForName.setAttribute("align", "left");

                tdForRate.setAttribute("border", 0);
                tdForRate.setAttribute("size", "10");
                tdForRate.setAttribute("align", "right");

                tdForName.onmouseover = function () {
                    this.className = 'mouseOver';
                };
                tdForName.onmouseout = function () {
                    this.className = 'mouseOut';
                };
                tdForName.onmousedown = function () {
                    //鼠标点击关联数据，跳转
                    window.open(url = "subject/" + this.children[0].id);
                };
                var show_name = document.createTextNode(json[i]["name"]);
                show_name;
                tdForName.appendChild(show_name);

                var show_rate = document.createTextNode(json[i]["rate"]);
                tdForRate.appendChild(show_rate);

                tr.appendChild(tdForName);
                tr.appendChild(tdForRate);

                // 用于在onmousedowm中获取到当前tdForName所对应的 URL，通过a.id传递movieId
                var a = document.createElement("a");
                a.id = json[i]["movieId"];
                tdForName.appendChild(a);

                document.getElementById("searchTips_table_tbody").appendChild(tr);
            }

        }

        function clearName() {
            var searchTipsTableTbody = document.getElementById("searchTips_table_tbody");
            // 清除 tr
            for (var i = searchTipsTableTbody.childNodes.length - 1; i >= 0; i--) {
                searchTipsTableTbody.removeChild(searchTipsTableTbody.childNodes[i]);
            }
            document.getElementById("searchTips").style.border = "";
        }

        //设置关联内容的位置
        function setLocation() {

            //关联位置显示位置与输入框
            var name = document.getElementById("keyword");
            var width = name.offsetWidth - 2;  //input width
            var left = name["offsetLeft"]; //距左边框的距离
            var top = name["offsetTop"] + name.height; //到顶部的距离

            //获得显示数据的div
            var searchTips = document.getElementById("searchTips");
            searchTips.style.border = "white 1px solid";
            searchTips.style.left = left + "px";
            searchTips.style.top = top + "px";
            searchTips.style.width = width + "px";
            document.getElementById("searchTips_table").width = width + "px";
        }

        //失去焦点，清除数据
        function nameLossFocus() {
            clearName();
        }

        //获得焦点，获取数据
        function nameGetFocus() {
            getMoreNames();
        }

        // ajax search 智能提醒----------------------------- end

        // search 获取电影列表
        function searchByAlias() {
            var url = "search.jsp";
            $.ajax({
                url: url,
                data: $("#movieSearch").serialize(),
                type: "POST",
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    displaySearchResult(data);
                }
            });
        }
        
        // 获取douban API 最新上映电影
        function getNewMovies() {
            $.ajax({
                type: "GET",
                dataType: "jsonp",
                url: url_douban + "/v2/movie/in_theaters?" + apikey_douban,
                headers: {
                    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
                    "Accept-Encoding": "gzip, deflate",
                    "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
                    "Cache-Control": "max-age=0",
                    "Connection": "keep-alive",
                    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
                },
                success:function (result) {
                    // ===============================================================
                    console.log("douban API in_theaters movie:");
                    console.log(result);
                }
            });
        }
        
        // // 获取用户信息
        // function getUserSession() {
        //     $.ajax({
        //        type:"GET",
        //        url:"/index",
        //        datatype:"json",
        //        success:function (result) {
        //            // ===============================================================
        //            console.log("user Session :");
        //            console.log(result);
        //        }
        //     });
        // }


    </script>

</head>
<body>


<%--电影基本情况搜索，ajax 搜索框智能提醒--%>
<form name="search" id="search" method="get" action="/search">
    <table>
        <tr>
            Search
            <td><input id="keyword" name="keyword" type="text" size="50" placeholder="请输入电影名"
                       autocomplete="off" onkeyup="getMoreNames()" onblur="nameLossFocus()" onfocus="nameGetFocus()">
            </td>
            <td><input type="submit" value="search"></td>
        </tr>
    </table>
    <div id="searchTips">
        <table id="searchTips_table" border="0" cellspacing="0" cellpadding="0">
            <tbody id="searchTips_table_tbody">
            <%--searchTips智能提醒的地方--%>
            </tbody>
        </table>
    </div>
</form>

<br/>


<a href="http://localhost:8080/login">登录界面</a>


</body>
</html>
