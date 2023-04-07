<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@page import="java.sql.*" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Menu_archivos</title>
<link rel="stylesheet" type="text/css" href="estilos.css">
</head>
<body>
<%
String academia = request.getParameter("academia");

String[] listaminutas;//idMinutas
listaminutas = request.getParameterValues("listaM");

String[] listafechas;//fechas de las minutas
listafechas = request.getParameterValues("fechaM");

String mes = request.getParameter("mes2");

String ano = request.getParameter("ano");

if(listaminutas != null){//Verificamos que haya seleccionado al menos una opcion

int num = listaminutas.length;

String idMinutas = null;

if(num==1){
	
idMinutas = listaminutas[0];

}else{
	
idMinutas = listaminutas[0]+",";

	for(int i=1;i<num;i++){//Creamos el arreglo para la consulta
		
		if(i != num-1){
			idMinutas = idMinutas+listaminutas[i]+",";
		}else{
			idMinutas = idMinutas+listaminutas[i];
		}
		
	}
	
}
//Conexion con la base de datos
Connection con;
String url="jdbc:mysql://localhost:8889/Agenda2";//<--CAMBIAR LA BASE CORRECTA
String Driver="com.mysql.jdbc.Driver";
String user="root";//CAMBIAR USUARIO
String clave="root";//CAMBIAR CONTRASEÑA
Class.forName(Driver);
con = DriverManager.getConnection(url,user,clave);

//Obtenemos los datos de la base
PreparedStatement ps,ps1;
ResultSet rs,rs1;

ps=con.prepareStatement(//Academia
"SELECT academia FROM academia WHERE idAcademia="+academia);
rs=ps.executeQuery();


ps1=con.prepareStatement(//lista de archivos
"SELECT nombre, idDocumentoMinuta FROM documentominuta WHERE idMinuta IN("+idMinutas+")");
rs1=ps1.executeQuery();
%>

<form action="Menu_correo.jsp" method="POST">

<h2>Archivos</h2>

<% 
while(rs.next()){//Sacamos el nombre de la academia 
%>
	<h6><%=rs.getString("academia")%></h6>
<% 
break;
}%>

<h3>Seleccionar:</h3>

<table>
<%
 while(rs1.next()){//LISTAMOS LOS ARCHIVOS EXISTENTES SEGUN LAS MINUTAS SELECCIONADAS
 	 
%>
<tr>
<td colspan="2">
<input type="checkbox" name="listaAr" value="<%=rs1.getString("idDocumentoMinuta")%>" id="listaAr">
<%= rs1.getString("nombre")%>
</td>
</tr>
<%} %>

</table>

<input type="hidden" name="academia" value="<%=academia%>">
<input type="hidden" name="mes" value="<%=mes%>">
<input type="hidden" name="ano" value="<%=ano%>">

<% for(int i=0;i<num;i++){%>
	<input type="hidden" name="listaM" value="<%=listaminutas[i]%>">
<%}%>
  

<input type="submit" id="botonA" value="Aceptar">

</form>

<%}else{//MENSAJE POR SI NO SELECCIONO NINGUNA MINUTA
	
	String mes2 = request.getParameter("mes");
	
%>
<form action="Menu_minuta.jsp" method="POST" id="FMensaje">

	<h2>Mensaje</h2>

	<table>
	<tr>
	<td>
	<h5>Seleccione al menos una opcion</h5>
	</td>
	</tr>
	</table>
	
	<input type="hidden" name="academia" value="<%=academia%>">
	<input type="hidden" name="mes" value="<%=mes2%>">
    <input type="hidden" name="ano" value="<%=ano%>">
	
	<input type="submit" id="botonA" value="Aceptar">
	</form>
	
<%} %>
</body>
</html>