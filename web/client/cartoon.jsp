<%@ page import="dao.getConn" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: Yang
  Date: 2018/12/3
  Time: 20:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="../css/bootstrap.min.css" rel="stylesheet"/>
    <link href="../css/style.css" rel="stylesheet"/>
    <title>SuperGod的书店</title>
    <style>
        body{
            background-image: url("../images/头像.jpg");
            background-size: cover;
        }
        .head{
            text-align: center;
        }
        .item_head{
            margin-left: 18.25%;
            /*text-align: center;*/
        }
        .item_body{
            position: relative;
            left: 18.25%;
            width: 1200px;
            height: auto;
        }
        .item_body_book{
            background: white;
            float: left;
            width: 200px ;
            height: 250px;
        }
    </style>
</head>
<body>
<script src="../js/jquery.min.js" ></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/commons.js"></script>
<div class="head">
    <img src="../images/1.jpg">
</div>

<div class="item">
    <div class="item_head">
        <img src="../images/重磅推荐.jpg">
    </div>
    <div class="item_body">
        <%

            String sql = "select id,name,author,price,image,description,category_id from book" +
                    " where category_id= ?";
            String category_id = request.getParameter("category_id");
            Connection conn = new getConn().getConn();
            PreparedStatement pstat = conn.prepareStatement(sql);
            pstat.setString(1,category_id);
            ResultSet rs = pstat.executeQuery();
            while (rs.next()) {

        %>
        <div class="item_body_book">
            <div style="text-align: center">
                <a href="" class="btn btn-default" role="button" data-toggle="modal" data-target="#<%=rs.getString("name")%>"><img width="149px" height="149px" src=<%=rs.getString("image")%>></a>
            </div>
            <div style="text-align: center">
                <p><%=rs.getString("name")%></p>
                <p style="text-decoration: line-through">￥1000</p>
                <p style="color: red">￥<%=rs.getString("price")%></p>
            </div>
        </div>


        <div class="modal fade" id="<%=rs.getString("name")%>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="myModalLabel">书本详情    &nbsp;&nbsp;&nbsp;&nbsp;《<%=rs.getString("name")%>》</h4>
                    </div>
                    <div class="modal-body">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=rs.getString("description")%></div>
                    <div class="modal-footer">

                        <div align="left"><img src="<%=rs.getString("image")%>"></div>
                        <p>作者：<%=rs.getString("author")%></p>
                        <p style="color: red">售价：￥<%=rs.getString("price")%></p>
                        <button class="btn btn-primary" onclick="addBook(<%=rs.getString("id")%>)">加入购物车</button><button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal -->
        </div>
        <%
            }
            pstat.close();
            conn.close();
        %>
    </div>
</div>
<script language="JavaScript">
    function showBook(categoryID) {
        xmlHttp.onreadystatechange = function() {
            if (xmlHttp.readyState == 4) {
                if(xmlHttp.status == 200) {
                    var data = xmlHttp.responseText;
                    document.getElementById("book").innerHTML = data;
                }
            }
        };
        xmlHttp.open("GET", "client/getBook.jsp?id="+categoryID, true);
        xmlHttp.send();
    }

    function addBook(bookID) {
        xmlHttp.open("POST","/AddBookServlet?BookID=" + bookID,true);
        xmlHttp.onreadystatechange=function () {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200){
                alert("加入购物车成功")
            }
        };
        xmlHttp.send();
    }
</script>
</body>
</html>
