package fileimporting;
import java.io.IOException;
public class FileData {
 
 public static void main(String[ ] args) throws IOException {
  String inputData = "datafiles/inputdata.json";
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
