<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 07.03.2017
  Time: 10:25
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="from" uri="http://www.springframework.org/tags/form" %>
<%@ page session="false" %>
<html>
<head>
    <title>Users Page</title>

    <style type="text/css">
        .tg {
            border-collapse: collapse;
            border-spacing: 0;
            border-color: #ccc;
        }

        .tg td {
            font-family: Arial, sans-serif;
            font-size: 14px;
            padding: 10px 5px;
            border-style: solid;
            border-width: 1px;
            overflow: hidden;
            word-break: normal;
            border-color: #ccc;
            color: #333;
            background-color: #fff;
        }

        .tg th {
            font-family: Arial, sans-serif;
            font-size: 14px;
            font-weight: normal;
            padding: 10px 5px;
            border-style: solid;
            border-width: 1px;
            overflow: hidden;
            word-break: normal;
            border-color: #ccc;
            color: #333;
            background-color: #f0f0f0;
        }

        .tg .tg-4eph {
            background-color: #f9f9f9
        }
    </style>
</head>
<body>
<a href="../../index.jsp">Back to main menu</a>

<br/>
<br/>
<form:form action="/search" method="get" modelAttribute="user">
    <c:if test="${empty searchedUsers}"><input type="text" name="searchedName" id="searchedName" value="">
    <input type="submit" value="Search">
    </c:if>
    <c:if test="${not empty searchedUsers}">
        <h1>Search results:</h1>
        <table class="tg">
            <tr>
                <th width="20">ID</th>
                <th width="60">Name</th>
                <th width="30">Age</th>
                <th width="20">Is Admin</th>
                <th width="140">Created Date</th>
                <th width="30">Edit</th>
                <th width="30">Delete</th>
            </tr>
            <c:forEach items="${searchedUsers}" var="user">
                <tr>
                    <td>${user.id}</td>
                    <td><a href="<c:url value="/userdata/${user.id}"/>">${user.name}</a></td>
                    <td>${user.age}</td>
                    <td>${user.admin}</td>
                    <td>${user.createdDate.toLocaleString()}</td>
                    <td><a href="<c:url value='/edit/${user.id}&${listUsers.page+1}&${searchedName}'/>">Edit</a></td>
                    <td><a href="<c:url value='/remove/${user.id}&${listUsers.page+1}'/>">Delete</a></td>
                </tr>
            </c:forEach>
        </table>
        <a href="<c:url value="/users"/>">Back to user list</a>
    </c:if>
</form:form>

<c:if test="${empty searchedUsers}"><h1>User list</h1></c:if>
<c:if test="${!empty listUsers}">
    <table class="tg">
        <tr>
            <th width="20">ID</th>
            <th width="60">Name</th>
            <th width="30">Age</th>
            <th width="20">Is Admin</th>
            <th width="140">Created Date</th>
            <th width="30">Edit</th>
            <th width="30">Delete</th>
        </tr>
        <c:forEach items="${listUsers.pageList}" var="user">
        <tr>
            <td>${user.id}</td>
            <td><a href="<c:url value="/userdata/${user.id}"/>">${user.name}</a></td>
            <td>${user.age}</td>
            <td>${user.admin}</td>
            <td>${user.createdDate.toLocaleString()}</td>
            <td><a href="<c:url value='/edit/${user.id}&${listUsers.page+1}'/>">Edit</a></td>
            <td><a href="<c:url value='/remove/${user.id}&${listUsers.page+1}'/>">Delete</a></td>
        </tr>
        </c:forEach>
    </table>
</c:if>
<div id="pagination">
    <c:url value="/users" var="prev">
        <c:param name="page" value="${page-1}"/>
    </c:url>
    <c:if test="${page > 1}">
        <a href="<c:out value="${prev}" />" class="pn prev">Prev</a>
    </c:if>

    <c:forEach begin="1" end="${maxPages}" step="1" varStatus="i">
        <c:choose>
            <c:when test="${page == i.index}">
                <span>${i.index}</span>
            </c:when>
            <c:otherwise>
                <c:url value="/users" var="url">
                    <c:param name="page" value="${i.index}"/>
                </c:url>
                <a href='<c:out value="${url}" />'>${i.index}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>
    <c:url value="/users" var="next">
        <c:param name="page" value="${page + 1}"/>
    </c:url>
    <c:if test="${page + 1 <= maxPages}">
        <a href='<c:out value="${next}" />' class="pn next">Next</a>
    </c:if>
</div>


<h1> Add/Edit user</h1>

<c:url var="addAction" value="/users/add&${listUsers.page+1}"/>
    <form:form action="${addAction}" modelAttribute="user">
        <table>
            <c:if test="${!empty user.name}">
                <tr>
                    <td>
                        <form:label path="id">
                            <spring:message text="ID"/>
                        </form:label>
                    </td>
                    <td>
                        <form:input path="id" readonly="true" size="8" disabled="true"/>
                        <form:hidden path="id"/>
                    </td>
                </tr>
            </c:if>
            <tr>
                <td>
                    <form:label path="name">
                        <spring:message text="Name"/>
                    </form:label>
                </td>
                <td>
                    <form:input path="name"/>
                </td>
            </tr>
            <tr>
                <td>
                    <form:label path="age">
                        <spring:message text="Age"/>
                    </form:label>
                </td>
                <td>
                    <form:input path="age"/>
                </td>
            </tr>
            <tr>
                <td>
                    <form:label path="admin">
                        <spring:message text="Is Admin?"/>
                    </form:label>
                </td>
                <td>
                    Yes<form:radiobutton path="admin" value="true"/>
                    No<form:radiobutton path="admin" value="false"/>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <c:if test="${!empty user.name}">
                        <input type="submit"
                               value="<spring:message text="Edit User"/>"/>
                    </c:if>
                    <c:if test="${empty user.name}">
                        <input type="submit"
                               value="<spring:message text="Add User"/>"/>
                    </c:if>
                </td>
            </tr>
        </table>
    </form:form>
</body>
</html>
