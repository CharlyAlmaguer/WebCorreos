<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@page import="java.sql.*" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Menu_minuta</title>
<link rel="stylesheet" type="text/css" href="estilos.css">
</head>
<body>
<%
String academia = request.getParameter("academia");
String mes = request.getParameter("mes"); 
String ano = request.getParameter("ano");

//Conexion con la base de datos
Connection con;
String url="jdbc:mysql://localhost:8889/Agenda2";//<--CAMBIAR POR LA BASE CORRECTA
String Driver="com.mysql.jdbc.Driver";
String user="root";//CAMBIAR USUARIO
String clave="root";//CAMBIAR CONTRASEÑA
Class.forName(Driver);
con = DriverManager.getConnection(url,user,clave);

//Obtenemos los datos de la base
PreparedStatement ps,ps1,ps2;
ResultSet rs,rs1,rs2;

ps=con.prepareStatement(//OBTENEMOS LAS MINUTAS DISPONIBLES
"SELECT DISTINCT m.creada, m.idMinuta FROM minuta m, documentominuta d WHERE m.idMinuta=d.idMinuta AND m.idAcademia="+academia+" AND MONTH(m.creada) = "+mes+" AND YEAR(m.creada) = "+ano);
rs=ps.executeQuery();

ps1=con.prepareStatement(//OBTENEMOS EL NOMBRE DE LA ACADEMIA
"SELECT academia FROM academia WHERE idAcademia="+academia);
rs1=ps1.executeQuery();

ps2=con.prepareStatement(
"SELECT DISTINCT m.creada, m.idMinuta FROM minuta m, documentominuta d WHERE m.idMinuta=d.idMinuta AND m.idAcademia="+academia+" AND MONTH(m.creada) = "+mes+" AND YEAR(m.creada) = "+ano);
rs2=ps2.executeQuery();

if(rs2.next() != false){
%>

<form action="Menu_archivos.jsp" method="POST">

<h2>Minuta</h2>

<% 
while(rs1.next()){//Sacamos el nombre de la academia 
%>
	<h6><%=rs1.getString("academia")%></h6>
<% 
break;
}

String mes1 = mes;

switch(mes1) {

     case "01":
	    mes1 = "Enero";
	    break;
     case "02":
	    mes1 = "Febrero";
	    break;
     case "03":
	    mes1 = "Marzo";
	    break;
     case "04":
	    mes1 = "Abril";
	    break;
     case "05":
	    mes1 = "Mayo";
	    break;
     case "06":
	    mes1 = "Junio";
	    break;
     case "07":
	    mes1 = "Julio";
	    break;
     case "08":
	    mes1 = "Agosto";
	    break;
     case "09":
	    mes1 = "Septiembre";
	    break;
     case "10":
	    mes1 = "Octubre";
	    break;
     case "11":
	    mes1 = "Noviembre";
	    break;
     case "12":
	    mes1 = "Diciembre";
	    break;
     default:
	    mes1 = "Error en mes";
	    break;
}
%>

<h3>Seleccionar:</h3>

<table>
<%
 while(rs.next()){//LISTAMOS LAS MINUTAS DE ACUERDO AL AÑO Y MES SELECCIONADO, Y QUE TENGAN DOCUMENTOS
 	 
%>
<tr>
<td colspan="2">
<input type="checkbox" name="listaM" value="<%=rs.getString("idMinuta")%>" id="listaM">
<%= rs.getString("creada").substring(8,10)+" de "+mes1+" del "+ano %>
</td>
</tr>
<%} %>
</table>

<input type="hidden" name="academia" value="<%=academia%>">
<input type="hidden" name="mes" value="<%=mes%>">
<input type="hidden" name="ano" value="<%=ano%>">
<input type="hidden" name="mes2" value="<%=mes1%>">

<input type="submit" id="botonA" value="Aceptar">

</form>

<%}else{ //EN CASO DE QUE NO HAYA MINUTAS DISPONIBLES%>

	<form action="Menu_fecha.jsp" method="POST" id="FMensaje">

	<h2>Mensaje</h2>

	<table>
	<tr>
	<td>
	<h5>No hay minutas para esta fecha</h5>
	</td>
	</tr>
	</table>
	<input type="submit" id="botonA" value="Aceptar">
	</form>
	
<%}%>

</body>
</html>