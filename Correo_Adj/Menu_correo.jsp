<%@page import="java.sql.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
          
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Menu_correo</title>
<link rel="stylesheet" type="text/css" href="estilos.css">

</head>
<body>
<%
String academia = request.getParameter("academia");

String mes = request.getParameter("mes");

String ano = request.getParameter("ano");

String[] lista_ar;//OBTENEMOS LA LISTA DE LOS archivos seleccionados
lista_ar = request.getParameterValues("listaAr");

String[] listaminutas;//idMinutas
listaminutas = request.getParameterValues("listaM");

if(lista_ar != null){//CHECAMOS QUE HAYA SELECCIONADO MINIMO UN ARCHIVO
	
int numr = lista_ar.length;


String archivos = null;

if(numr==1){
	
archivos = lista_ar[0];

}else{
	
archivos = lista_ar[0]+",";

	for(int i=1;i<numr;i++){//Creamos el arreglo para la consulta
		
		if(i != numr-1){
			archivos = archivos+lista_ar[i]+",";
		}else{
			archivos = archivos+lista_ar[i];
		}
		
	}
	
}




//Conexion con la base de datos
Connection con;
String url="jdbc:mysql://localhost:8889/Agenda2";//<--Se debe de cambiar el puerto y el nombre de la base destino
String Driver="com.mysql.jdbc.Driver";
String user="root";//<--Cambiar usuario de conexion
String clave="root";//<--Cambiar contraseña de usuario
Class.forName(Driver);
con = DriverManager.getConnection(url,user,clave);

PreparedStatement ps,ps1,ps2,ps3,ps4;
ResultSet rs,rs1,rs2,rs3,rs4;
 	
	//Obtenemos los datos de la base
	ps=con.prepareStatement(//OBTENEMOS LOS DATOS DE LOS PARTICIPANTES
	"SELECT p.nombre, p.apellido1, p.apellido2, p.correo1, a.academia FROM persona p,academia a,personaacademia pa WHERE pa.idAcademia=a.idAcademia AND pa.idPersona=p.idPersona AND pa.idAcademia="+academia);
	rs=ps.executeQuery();

	ps1=con.prepareStatement(//NOMBRE DE LA ACADEMIA
	"SELECT academia FROM academia a WHERE idAcademia = "+academia );
	rs1=ps1.executeQuery();
	
	ps2=con.prepareStatement(//NUMERO DE PARTICIPANTES
    "SELECT idPersona FROM personaacademia WHERE idAcademia = "+academia);
	rs2=ps2.executeQuery();
	
	ps3=con.prepareStatement(//OBTENEMOS LOS DATOS DEL PRESIDENTE 
	"SELECT correo1, nombre, apellido1, apellido2 FROM persona p, personaacademia pa WHERE pa.idPersona=p.idPersona AND pa.rol = 1 AND pa.idAcademia = "+academia);
	rs3=ps3.executeQuery();
	
	ps4=con.prepareStatement(//OBTENEMOS LOS DATOS DE LOS ARCHIVOS SELECCIONADOS
	"SELECT d.nombre, d.idMinuta, d.ruta, m.creada FROM documentominuta d, minuta m WHERE m.idMinuta=d.idMinuta AND idDocumentoMinuta IN("+archivos+")");
	rs4=ps4.executeQuery();
	
	
if(rs2.next() != false){//Comprobamos que la academia si tenga participantes 

int numm = listaminutas.length;
%>


<form action="Envio_Servelet_Adj" method="POST">

<h2>CORREO</h2>
<% 
while(rs1.next()){//Sacamo el nombre de la academia 
%>
	<h6><%=rs1.getString("academia")%></h6>
<% 
break;
}%>

<h3>Para:</h3>

<table>
<%
 while(rs.next()){//Listamos los participantes de la academia
%>
<tr>
<td colspan="2">
<input type="checkbox" name="lista" value="<%=rs.getString("p.correo1")%>" id="lista" checked>
<%= rs.getString("p.nombre") %>
<%= rs.getString("p.apellido1") %>
<%= rs.getString("p.apellido2") %>
<input type="hidden" name="academiaN" value="<%=rs.getString("a.academia")%>">
</td>
</tr>
<%} %>
</table>

<%while(rs3.next()){//Obtenemos los datos del presidente de la academia%>

	<input type="hidden" name="correoP" value="<%=rs3.getString("correo1")%>">
	<input type="hidden" name="nombreP" value="<%=rs3.getString("nombre")%>">
	<input type="hidden" name="apellido1P" value="<%=rs3.getString("apellido1")%>">
	<input type="hidden" name="apellido2P" value="<%=rs3.getString("apellido2")%>">
	
<%
break;
}

while(rs4.next()){%>
	<input type="hidden" name="listaR" value="<%=rs4.getString("d.ruta")%>">
	<input type="hidden" name="listaN" value="<%=rs4.getString("d.nombre")%>">
	<input type="hidden" name="minutas" value="<%=rs4.getString("d.idMinuta")%>">
	<input type="hidden" name="fechaM" value="<%=rs4.getString("m.creada").substring(8,10)+" de "+mes+" del "+ano %>">
<%}%>

<% for(int i=0;i<numm;i++){%>
	<input type="hidden" name="listaM" value="<%=listaminutas[i]%>">
 <%}for(int i=0;i<numr;i++){%>
<input type="hidden" name="lista_ar" value="<%=lista_ar[i]%>">
<%}%>


<input type="hidden" name="academia" value="<%=academia%>">
<input type="hidden" name="mes" value="<%=mes%>">
<input type="hidden" name="ano" value="<%=ano%>">

<h4>Agregar correo:</h4>

<input type="email" name="correo" id="correo" placeholder="ejemplo@dominio.com">

<a href="Menu_fecha.jsp"><input type="button" id="botonC" value="Cancelar"></a><!--Se debe de cambiar por el menu de agendas-->

<input type="submit" id="botonE" value="ENVIAR">

</form>

<%}else{ //En caso de no tener participantes mandamos el mensaje%>

	<form action="Menu_fecha.jsp" method="POST" id="FMensaje"><!--Se debe de cambiar por la pagina o menu de agendas action=-->

	<h2>Mensaje</h2>

	<table>
	<tr>
	<td>
	<h5>No existen participantes de esta academia</h5>
	</td>
	</tr>
	</table>
	<input type="submit" id="botonA" value="Aceptar">
	</form>
	
<%}

}else{//Mandamos mensaje por si no selecciono ningun archivo

//String[] listaminutas = request.getParameterValues("listaM");
int numm = listaminutas.length;

%>
<form action="Menu_archivos.jsp" method="POST" id="FMensaje">

	<h2>Mensaje</h2>

	<table>
	<tr>
	<td>
	<h5>Seleccione al menos una opcion</h5>
	</td>
	</tr>
	</table>
	
	<input type="hidden" name="academia" value="<%=academia%>">
	
	<% for(int i=0;i<numm;i++){%>
	<input type="hidden" name="listaM" value="<%=listaminutas[i]%>">
    <%}%>
	<input type="submit" id="botonA" value="Aceptar">
	
	</form>
	
<%}%>

</body>
</html>