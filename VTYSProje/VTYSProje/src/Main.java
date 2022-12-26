package edu.sau.vys.vys1;
import java.sql.*;
import java.util.*;
public class Main {
    public static void main(String[] args)
    {
        try
        {   /***** Bağlantı kurulumu *****/
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/ProjeFuadG",
                    "postgres", "lamia");
            if (conn != null)
                System.out.println("Veritabanına bağlandı!");
            else
                System.out.println("Bağlantı girişimi başarısız!");

            System.out.println("Yapmak istediğiniz islemi: (arama/silme/ekleme/guncelleme");
            Scanner sc= new Scanner(System.in);
            int islem = sc.nextInt();

            if(islem == 1)
            {
                System.out.println("aramak istediğiniz personelin kodunu giriniz: ");
                Scanner sc1= new Scanner(System.in);
                String persoNumara = sc1.nextLine();
                String sql = "SELECT * FROM personelbul('" +persoNumara + "')";

                System.out.println(sql);
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                conn.close();

                String musteri= null;
                    musteri = rs.getString("IsimSoyisim");
                    System.out.print("numarasi girilen personelin ismi: "+ musteri);
                    rs.close();
                    stmt.close();

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}