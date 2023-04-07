<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVacio</title>
<link rel="stylesheet" type="text/css" href="estilos.css">

</head>
<body>

<!--Mensaje de alerta si el usuario no seleccion y/o escribe algun correo-->
<% 
String academia = (String)request.getAttribute("academia");
String mes = (String)request.getAttribute("mes");
String ano = (String)request.getAttribute("ano");

String[] lista_ar;
lista_ar = (String[])request.getAttribute("lista_ar");
int num = lista_ar.length;

String[] listaM;
listaM = (String[])request.getAttribute("listaM");
int numM = listaM.length;

%>



<form action="Menu_correo.jsp" method="POST" id="FMensaje">

<h2>Mensaje</h2>

<table>
<tr>
<td>
<h5>Por favor selecciona y/o escribe algun correo</h5>
</td>
</tr>
</table>

<input type="hidden" name="academia" value="<%=academia%>">
<input type="hidden" name="mes" value="<%=mes%>">
<input type="hidden" name="ano" value="<%=ano%>">

<% for(int i=0;i<num;i++){%>
	<input type="hidden" name="listaAr" value="<%=lista_ar[i]%>">
<%}

   for(int i=0;i<numM;i++){%>
   <input type="hidden" name="listaM" value="<%=listaM[i]%>">
<%}%>

<input type="submit" id="botonA" value="Aceptar">
</form>



</body>
</html>