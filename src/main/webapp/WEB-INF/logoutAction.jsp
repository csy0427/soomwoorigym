<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%session.removeAttribute("admin_id"); %>
	<%
	session.removeAttribute("loginSS");
	%>
	<script>
		alert("로그아웃되었습니다.");
		location.href = "index";
		//history.go(-1);
	</script>
</body>
</html>