package com.ibm.cloudoe.samples;
import java.io.IOException;

import fileimporting.FileData;
import fileimporting.FileData;
import fileimporting.ReadFile;

import javax.ws.rs.GET;
import javax.ws.rs.Path;


@Path("/hello")
public class HelloResource {
	private static JSONArr
	@GET
	public String getInformation() {

		// 'VCAP_APPLICATION' is in JSON format, it contains useful information about a deployed application
		// String envApp = System.getenv("VCAP_APPLICATION");

		// 'VCAP_SERVICES' contains all the credentials of services bound to this application.
		// String envServices = System.getenv("VCAP_SERVICES");
		// JSONObject sysEnv = new JSONObject(System.getenv());
		
		return "Hi World!";
		
		
		  String inputData = "/../../../../../datafiles/inputdata.json";
		  try {
		   ReadFile file = new ReadFile(inputData);
		   String[] aryLines = file.OpenFile();
		   for (int i = 0; i < aryLines.length; i++ ) {
		   System.out.println( aryLines[ i ] ) ;
		   }
		  }
		  catch (IOException e) {
		   System.out.println(e.getMessage());
		  }
		  ReadFile file = new ReadFile(inputData);
		  String[] aryLines = file.OpenFile();
		  System.out.print(aryLines[0]);
		  for (int i = 0; i < aryLines.length; i++ ) {
		   System.out.println( aryLines[ i ] ) ;
		   }
		  
		  //we have data stored into aryLines
		  //now how can we get watson to take a look at it?
		  

	}
}