<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="java.sql.*" %>

<!DOCTYPE html>
<html>

<script type="text/javascript">

function validaDatos(){
	
var mes = document.getElementById("mes");
var ano = document.getElementById("ano");

const fecha = new Date();
const ano_actual = fecha.getFullYear();//OBTENEMOS EL AÑO ACTUAL
const mes_actual = fecha.getMonth()+1;//OBTENEMOS EL MES ACTUAL

if(mes.value == "" && ano.value == ""){
	alert("Selecciona las opciones por favor");
	return false;
    }else if(mes.value == ""){
	   alert("Selecciona un mes por favor");
	   return false;
    }else if(ano.value == ""){
	   alert("Selecciona un año por favor");
	   return false;
    }else if(ano.value == ano_actual && mes.value > mes_actual){//VERIFICAMOS QUE LA FECHA SEA VALIDA
    	alert("Fecha invalida");
    	return false;
    }
  return true;
}

</script>

<head>
<meta charset="UTF-8">
<title>Menu_fecha</title>
<link rel="stylesheet" type="text/css" href="estilos.css">
</head>
<body>
<%
//String academia = request.getAttribute("academia").toString();//Obtenemos el idAcademia de la sesion

String academia = "225";//idAcademia, este es un valor de prueba unicamente 

//Conexion con la base de datos
Connection con;
String url="jdbc:mysql://localhost:8889/Agenda2";//<---CAMBIAR POR LA BASE CORRECTA
String Driver="com.mysql.jdbc.Driver";
String user="root";//CAMBIAR USUARIO DE LA BASE 
String clave="root";//CAMBIAR LA CONTRASEÑA DE LA BASE
Class.forName(Driver);
con = DriverManager.getConnection(url,user,clave);

//Obtenemos los datos de la base
PreparedStatement ps;
ResultSet rs;
ps=con.prepareStatement(
"SELECT academia FROM academia WHERE idAcademia="+academia );
rs=ps.executeQuery();
%>

<form action="Menu_minuta.jsp" method="POST" onsubmit="return validaDatos();">

<h2>Minuta</h2>

<% 
while(rs.next()){//Sacamos el nombre de la academia 
%>
	<h6><%=rs.getString("academia")%></h6>
<% 
break;
}%>

<table>
<tr>
<td>
<h3>Seleccionar mes:</h3>

<select id="mes" name="mes">
 <option value="" disabled selected>--seleccionar</option>
<option value="01">Enero</option>
<option value="02">Febrero</option>
<option value="03">Marzo</option>
<option value="04">Abril</option>
<option value="05">Mayo</option>
<option value="06">Junio</option>
<option value="07">Julio</option>
<option value="08">Agosto</option>
<option value="09">Septiembre</option>
<option value="10">Octubre</option>
<option value="11">Noviembre</option>
<option value="12">Diciembre</option>
</select>
</td>
<td>
<h3>Seleccionar año:</h3>

<select id="ano" name="ano">
 <option value="" disabled selected>--seleccionar</option>
<option value="2021">2021</option>
<option value="2020">2020</option>
<option value="2019">2019</option>
<option value="2018">2018</option>
<option value="2017">2017</option>
<option value="2016">2016</option>
<option value="2015">2015</option>
</select>
</td>
</tr>
</table>

<input type="hidden" name="academia" value="<%=academia%>">

<input type="submit" id="botonA" value="Aceptar">

</form>


</body>
</html>