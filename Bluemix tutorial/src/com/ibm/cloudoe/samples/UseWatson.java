package com.ibm.cloudoe.samples;
import java.io.IOException;

import fileimporting.FileData;
import fileimporting.FileData;
import fileimporting.ReadFile;

import javax.ws.rs.GET;
import javax.ws.rs.Path;


@Path("/hello")
public class UseWatson {

	@GET
	public String getInformation() throws IOException {

		// 'VCAP_APPLICATION' is in JSON format, it contains useful information about a deployed application
		// String envApp = System.getenv("VCAP_APPLICATION");

		// 'VCAP_SERVICES' contains all the credentials of services bound to this application.
		// String envServices = System.getenv("VCAP_SERVICES");
		// JSONObject sysEnv = new JSONObject(System.getenv());
		
		//return "Hi World!";
		
		
		  String inputData = "/../../../../../datafiles/inputdata.json";
		  String[] actualDataArray = FileData.getData(inputData);
		  
		  
		  
		  //we have data stored into actualDataArray
		  //now how can we get watson to take a look at it?
		  return "Hi, World!";

	}
}