package com.correo.servelet;

import java.io.IOException;


import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Envio_Servelet_Adj
 */

public class Envio_Servelet_Adj extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Envio_Servelet_Adj() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	response.setContentType("text/html;charset=UTF-8");
		
		//OBTENEMOS TODOS LOS DATOS NECESARIOS 
	
	    String academia = request.getParameter("academia");//OBTENEMOS EL ID_ACADEMIA
	    String mes = request.getParameter("mes");
	    String ano = request.getParameter("ano");
	    
		String[] listacorreos;//OBTENEMOS LOS CORREOS
		listacorreos = request.getParameterValues("lista");
		String correo_ext = request.getParameter("correo");//OBTENEMOS CORREO EXTERNO
		
		//OBTENEMOS LOS DATOS DEL PRESIDENTE
		String correoP = request.getParameter("correoP");
		String nombreP = request.getParameter("nombreP");
		String apellido1P = request.getParameter("apellido1P");
		String apellido2P = request.getParameter("apellido2P");
		
		String[] listarutas;//OBTENEMOS LAS RUTAS
		listarutas = request.getParameterValues("listaR");
		int numr = listarutas.length;
		
		String[] nombre_ar;//OBTENEMOS LOS NOMBRES DE LOS ARCHIVOS  /////Datos para el mensaje
		nombre_ar = request.getParameterValues("listaN");
		
		String[] lista_ar;//LISTA DE LOS ARCHIVOS SELECCIONADOS
		lista_ar = request.getParameterValues("lista_ar");
		
        ////////////////////////////////////////////////////////////////Datos para el mensaje
		
		String[] minutas;//OBTENEMOS LOS ID DE LAS MINUTAS SELECCIONADAS DE CADA ARCHIVO
		minutas = request.getParameterValues("minutas");
		int minutas2 = minutas.length;
		
		String[] fechaM;//LAS FECHAS DE LAS MINUTAS SELECCIONADAS
		fechaM = request.getParameterValues("fechaM");
		
		String[] listaM;//LA LISTA DE LOS ID DE LAS MINUTAS SELECCIONADAS
		listaM = request.getParameterValues("listaM");
		int lista2 = listaM.length;
		
		String indice_ar = null;//CREAMOS LA LISTA DE LAS MINUTAS CON LOS ARCHIVOS
		
		if(lista2 == 1 && minutas2 == 1){
			
			indice_ar = "Minuta del "+fechaM[0]+": "+nombre_ar[0];
			
		}else if(lista2 == 1 && minutas2 > 1) {
			
			indice_ar = "Minuta del "+fechaM[0]+": "+nombre_ar[0];
			
			for(int i=1;i<minutas2;i++) {
				indice_ar = indice_ar+", "+nombre_ar[i];
			}
			
		}else if(lista2 > 1 && minutas2 > 1) {
			
			int i = 1;
			int a = 0;
			
			indice_ar = "Minuta del "+fechaM[0]+": "+nombre_ar[0];
			
			
			while(i<minutas2) {
				
				
				if(minutas[a].equals(minutas[i])) {
					
					indice_ar = indice_ar+", "+nombre_ar[i];
					i++;
					
				}else{
					
					
					indice_ar = indice_ar+". Minuta del "+fechaM[i]+": "+nombre_ar[i];
					i++;
					
				}
				a++;
				
			}
			
		}
		
	    
		
		//VALIDAMOS SI EL USUARIO SELECCIONO O ESCRIBIO ALGUN CORREO 
	    if(listacorreos == null && correo_ext == "") {
	    	
	    	request.setAttribute("academia", academia);
	    	request.setAttribute("lista_ar", lista_ar);
	    	request.setAttribute("listaM", listaM);
	    	request.setAttribute("mes", mes);
	    	request.setAttribute("ano", ano);
	    	
	    	RequestDispatcher rd;
	    	rd = request.getRequestDispatcher("/MVacio.jsp");
	    	rd.forward(request, response);
	    	
	    }else if(listacorreos == null){//SI EL USUARIO SOLO ESCRIBIO UN CORREO PERO NO SELECCIONO NINGUNO DE LA LISTA
        	
        	
        	try {	
        		//PROPIEDADES DEL CORREO 
        		Properties props = new Properties();
        		props.setProperty("mail.smtp.host","smtp.gmail.com");
        		props.setProperty("mail.smtp.starttls.enable","true");
        		props.setProperty("mail.smtp.port","587");
        		props.setProperty("mail.smtp.auth","true");
        		
        		Session session = Session.getDefaultInstance(props);
        		
        		//CORREO EMISOR
        		String emailE = "agenda.academias@gmail.com";
        		String passE = "Ac4f14g3nd4#_";
        		
        		//CONTENIDO DEL CORREO
        		String academiaN = request.getParameter("academiaN");
        		String asunto = "Documentacion Academia "+academiaN;
        		String mensaje = "Buen dia querido participante de la academia "+academiaN+" por este medio le hacemos llegar los documentos referentes a las siguientes minutas. "+indice_ar+". No es necesario que conteste este correo, si desea contactarnos envie un correo al presidente "+nombreP+" "+apellido1P+" "+apellido2P+" de la academia "+academiaN+" a esta direccion "+correoP+". Saludos cordiales.";
        		
        		//CONTRUIMOS EL MENSAJE
        		BodyPart texto = new MimeBodyPart();
        		texto.setContent(mensaje,"text/html");
        		
        		MimeMultipart multiparte = new MimeMultipart();
        		
        		//UNIMOS LAS PARTES DEL MENSAJE
        		for(int i=0;i<numr;i++) {
        				
        		BodyPart adjunto = new MimeBodyPart();
        		adjunto.setDataHandler(new DataHandler(new FileDataSource(listarutas[i])));
        		adjunto.setFileName(nombre_ar[i]);
        		multiparte.addBodyPart(adjunto);
        		
        		}
        		
        		multiparte.addBodyPart(texto);
   		
        		//CORREO RECEPTOR
        		MimeMessage message = new MimeMessage(session);
        		message.setFrom(new InternetAddress(emailE));
        	    
        		
        		message.addRecipient(Message.RecipientType.TO,new InternetAddress(correo_ext));
        		message.setSubject(asunto);
        		message.setContent(multiparte);
        		
        		//ENVIAR CORREO
        		Transport t = session.getTransport("smtp");
        		t.connect(emailE,passE);
        		t.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
        		t.close();
        		
        
        		
        		}catch (AddressException ex) {
        			Logger.getLogger(Envio_Servelet_Adj.class.getName()).log(Level.SEVERE,null, ex);
        		}catch (MessagingException ex) {
        			Logger.getLogger(Envio_Servelet_Adj.class.getName()).log(Level.SEVERE,null, ex);
        		}
        	
        	RequestDispatcher rd;
	    	rd = request.getRequestDispatcher("/MCorrecto.jsp");
	    	rd.forward(request, response);
        	
        }else if(correo_ext == "") {//SI EL USUARIO SELECCIONO ALGUNO DE LA LISTA PERO NO ESCRIBIO NINGUN CORREO
        	
        	
        	int numero = listacorreos.length;
        	
        	try {	
        		//PROPIEDADES DEL CORREO 
        		Properties props = new Properties();
        		props.setProperty("mail.smtp.host","smtp.gmail.com");
        		props.setProperty("mail.smtp.starttls.enable","true");
        		props.setProperty("mail.smtp.port","587");
        		props.setProperty("mail.smtp.auth","true");
        		
        		Session session = Session.getDefaultInstance(props);
        		
        		//CORREO EMISOR
        		String emailE = "agenda.academias@gmail.com";
        		String passE = "Ac4f14g3nd4#_";
        		
        		//CONTENIDO DEL CORREO
        		String academiaN = request.getParameter("academiaN");
        		String asunto = "Documentacion Academia "+academiaN;
        		String mensaje = "Buen dia querido participante de la academia "+academiaN+" por este medio le hacemos llegar los documentos referentes a las siguientes minutas. "+indice_ar+". No es necesario que conteste este correo, si desea contactarnos envie un correo al presidente "+nombreP+" "+apellido1P+" "+apellido2P+" de la academia "+academiaN+" a esta direccion "+correoP+". Saludos cordiales.";
        		
        		//CONTRUIMOS EL MENSAJE
        		BodyPart texto = new MimeBodyPart();
        		texto.setContent(mensaje,"text/html");
        		
        		MimeMultipart multiparte = new MimeMultipart();
        		
        		//UNIMOS LAS PARTES DEL MENSAJE
        		for(int i=0;i<numr;i++) {
        				
        		BodyPart adjunto = new MimeBodyPart();
        		adjunto.setDataHandler(new DataHandler(new FileDataSource(listarutas[i])));
        		adjunto.setFileName(nombre_ar[i]);
        		multiparte.addBodyPart(adjunto);
        		
        		}
        		
        		multiparte.addBodyPart(texto);
   		
        		//CORREO RECEPTOR
        		MimeMessage message = new MimeMessage(session);
        		message.setFrom(new InternetAddress(emailE));
        		
        		Address[] receptores = new Address[numero];
        		int i = 0;
        		
        		while(i<numero) {
        			receptores[i] = new InternetAddress(listacorreos[i]);
        			i++;
        		}
        		
        		message.addRecipients(Message.RecipientType.TO, receptores);
        		message.setSubject(asunto);
        		message.setContent(multiparte);
        		
        		//ENVIAR CORREO
        		Transport t = session.getTransport("smtp");
        		t.connect(emailE,passE);
        		t.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
        		t.close();
        		
        		
        		}catch (AddressException ex) {
        			Logger.getLogger(Envio_Servelet_Adj.class.getName()).log(Level.SEVERE,null, ex);
        		}catch (MessagingException ex) {
        			Logger.getLogger(Envio_Servelet_Adj.class.getName()).log(Level.SEVERE,null, ex);
        		}
        	
        	RequestDispatcher rd;
	    	rd = request.getRequestDispatcher("/MCorrecto.jsp");
	    	rd.forward(request, response);
        	
        }else {//SI EL USUARIO SELECCIONO Y ESCRIBIO ALGUN CORREO
		
		     //lista correos y correo_ext =! null
		     int numero = listacorreos.length;
		     int numero1 = numero;
		     numero++;
		
		     //AÑADIMOS CORREO EXTERNO
		     String[] listacorreos1 = new String[numero];
		
		    for(int j=0;j<numero1;j++) {
			   listacorreos1[j] = listacorreos[j];
		    }
		
		    listacorreos1[numero1] = correo_ext;
		
		    try {	
		    //PROPIEDADES DEL CORREO 
		    Properties props = new Properties();
		    props.setProperty("mail.smtp.host","smtp.gmail.com");
		    props.setProperty("mail.smtp.starttls.enable","true");
		    props.setProperty("mail.smtp.port","587");
		    props.setProperty("mail.smtp.auth","true");
		
		    Session session = Session.getDefaultInstance(props);
		
    		//CORREO EMISOR
    		String emailE = "agenda.academias@gmail.com";
    		String passE = "Ac4f14g3nd4#_";
    		
    		//CONTENIDO DEL CORREO
    		String academiaN = request.getParameter("academiaN");
    		String asunto = "Documentacion Academia "+academiaN;
    		String mensaje = "Buen dia querido participante de la academia "+academiaN+" por este medio le hacemos llegar los documentos referentes a las siguientes minutas. "+indice_ar+". No es necesario que conteste este correo, si desea contactarnos envie un correo al presidente "+nombreP+" "+apellido1P+" "+apellido2P+" de la academia "+academiaN+" a esta direccion "+correoP+". Saludos cordiales.";
    		
    		//CONTRUIMOS EL MENSAJE
    		BodyPart texto = new MimeBodyPart();
    		texto.setContent(mensaje,"text/html");
    		
    		MimeMultipart multiparte = new MimeMultipart();
    		
    		//UNIMOS LAS PARTES DEL MENSAJE
    		for(int i=0;i<numr;i++) {
    				
    		BodyPart adjunto = new MimeBodyPart();
    		adjunto.setDataHandler(new DataHandler(new FileDataSource(listarutas[i])));
    		adjunto.setFileName(nombre_ar[i]);
    		multiparte.addBodyPart(adjunto);
    		
    		}
    		
    		multiparte.addBodyPart(texto);
		
		    //CORREO RECEPTOR
		    MimeMessage message = new MimeMessage(session);
		    message.setFrom(new InternetAddress(emailE));
		
		    Address[] receptores = new Address[numero];
		    
		    int i = 0;
		    while(i<numero) {
			    receptores[i] = new InternetAddress(listacorreos1[i]);
			    i++;
		    }
		
		    message.addRecipients(Message.RecipientType.TO, receptores);
		    message.setSubject(asunto);
		    message.setContent(multiparte);
		
		    //ENVIAR CORREO
		    Transport t = session.getTransport("smtp");
		    t.connect(emailE,passE);
		    t.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
		    t.close();
		
		
		    }catch (AddressException ex) {
			    Logger.getLogger(Envio_Servelet_Adj.class.getName()).log(Level.SEVERE,null, ex);
		    }catch (MessagingException ex) {
			    Logger.getLogger(Envio_Servelet_Adj.class.getName()).log(Level.SEVERE,null, ex);
		    }
		
		
		
		    RequestDispatcher rd;
	    	rd = request.getRequestDispatcher("/MCorrecto.jsp");
	    	rd.forward(request, response);
		
        }
	}

}
