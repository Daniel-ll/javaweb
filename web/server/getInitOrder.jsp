<%@ page import="dao.getUser" %>
<%@ page import="dao.orderUtil" %>
<%@ page import="model.order" %>
<%@ page import="model.orderItem" %>
<%@ page import="model.user" %>
<%@ page import="model.userOrders" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %><%--
  Created by IntelliJ IDEA.
  User: 16051
  Date: 2018/11/28
  Time: 21:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>initOrders</title>
    <link href="../css/bootstrap.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/server.css">
    <style>
        button {
            -webkit-transition-duration: 0.4s; /* Safari */
            transition-duration: 0.4s;
            background-color: white;
            color: black;
            border: 2px solid #4CAF50; /* Green */
        }

        button:hover {
            background-color: #4CAF50; /* Green */
            color: white;
        }

    </style>
</head>
<body onload="initAJAX()">
<script src="../js/commons.js"></script>
<div class="modal-body">
    <form class="form-group" action="getInitOrder.jsp" method="post">
        <fieldset>
            <legend>初始订单查询</legend>
            <div class="form-group">
                <label>用户名：</label>
                <input name="search" class="form-control" type="search" placeholder="中文、英文、数字包括下划线" required pattern="^[\u4E00-\u9FA5A-Za-z0-9_]+$">
            </div>
            <div>
                <input type="submit" value="查 询" >
            </div>

        </fieldset>
    </form>
</div>
<%
    request.setCharacterEncoding("utf-8");
    String search=request.getParameter("search");
    if (search!=null){
        user user=new getUser().getUser(search);
        if (user!=null){
            userOrders userOrders=new orderUtil().getUserOrders(Integer.parseInt(user.getId()),-1);
            if (userOrders!=null){
                ArrayList<order> orderArrayList=userOrders.getOrderArrayList();
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                int num=0;
%>
<div id="table1">
<table  border="1" width="100%">
    <caption><h2>初始订单</h2></caption>
    <tr>
        <th>用户ID</th>
        <th>用户名</th>
        <th>订单个数</th>
        <th>总金额</th>
    </tr>
    <tr>
        <td><%=user.getId()%></td>
        <td><%=user.getUsername()%></td>
        <td><%=userOrders.getOrderArrayList().size()%></td>
        <td><%=userOrders.getPrice()%></td>
    </tr>
</table>

<%
                for (order order:orderArrayList
                     ) {
                    num++;
 %>
<table class="hovertable" border="1" width="100%">
    <tr>
        <th>订单号</th>
        <th>订单时间</th>
        <th>订单金额</th>
        <th>订单状态</th>
    </tr>
    <tr>
        <td><%=order.getId()%></td>
        <td><%=sdf.format(order.getDate())%></td>
        <td><%=order.getPrice()%></td>
        <td id="th<%=num%>">
        初始&nbsp;<button onclick="sendRequest(<%=order.getId()%>,<%=num%>)">修改状态</button></td>
    </tr>
</table>
<table  width="100%" border="1">
    <tr>
        <th>子订单号</th>
        <th>书本序号</th>
        <th>书名</th>
        <th>类型</th>
        <th>数量</th>
        <th>单价</th>
        <th>子订单金额</th>
    </tr>
<%
                    ArrayList<orderItem> orderItemArrayList=order.getOrderItemArrayList();
                    for (orderItem orderItem:orderItemArrayList
                         ) {
                        %>
<tr>
    <td><%=orderItem.getId()%></td>
    <td><%=orderItem.getBook().getId()%></td>
    <td><%=orderItem.getBook().getName()%></td>
    <td><%=orderItem.getBook().getCategory_name()%></td>
    <td><%=orderItem.getQuantity()%></td>
    <td><%=orderItem.getBook().getPrice()%></td>
    <td><%=orderItem.getPrice()%></td>
</tr>
<%
                    }
                    %>
</table>

    <%
                 }
            }
        }
    }
%>
</div>
</body>
<script language="JavaScript">

    function sendRequest(id,th) {

        xmlHttp.open("POST", "/changeStateServlet?id="+id,true);
        xmlHttp.send();
        xmlHttp.onreadystatechange = function() {
            if (xmlHttp.readyState == 4) {
                if(xmlHttp.status == 200) {
                    var th1 = document.getElementById("th"+th);
                    while (th1.hasChildNodes()) {
                        th1.removeChild(th1.firstChild);
                    }
                    th1.innerHTML = "已完成";
                    var data=xmlHttp.responseText;
                    window.alert(data);

                }else {
                    window.alert("修改失败");
                }
            }
        };

    }


</script>
<script src="../js/bgDataQuery.js"></script>
</html>
