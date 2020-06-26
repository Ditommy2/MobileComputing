<?php
if (!function_exists('http_response_code'))
{
  function http_response_code($newcode = NULL)
  {
      static $code = 200;
      if($newcode !== NULL)
      {
          header('X-PHP-Response-Code: '.$newcode, true, $newcode);
          if(!headers_sent())
              $code = $newcode;
      }
      return $code;
  }
}

    $filename = basename($_SERVER["HTTP_FILENAME"]);
    $filetype = $_SERVER["CONTENT_TYPE"];

/* PUT data comes in on the stdin stream */
   $putdata = fopen("php://input", "r");

   if ($putdata) {
        /* Open a file for writing */
        $tmpfname = tempnam("upload", "myapp");
        $fp = fopen($tmpfname, "w");
        if ($fp) {
            /* Read the data 1 KB at a time and write to the file */
            while ($data = fread($putdata, 1024)) {
                fwrite($fp, $data);
            }

            $conn = new mysqli("localhost", "id13097986_supercafoni", "2QM{-&[Yfev|J=Jk", "id13097986_appmcdata") or die("Error connecting to database");
            $sql = "INSERT INTO Salvataggio (ChiaveSalvataggio, Salvataggio) VALUES ('" . $filename . "', '" . $fp . "')";
            mysqli_query($conn,$sql) or die (mysqli_error($conn));
            $app = explode("$$", $filename);
            $app1 = explode(".", $app[1]);
            $username = $app1[0];
            $sql = "UPDATE Utente SET fk_salvataggi = '" . $filename . "' where username = '" . $username . "'";
            mysqli_query($conn,$sql) or die (mysqli_error($conn));




            /* Close the streams */
            fclose($fp);
            fclose($putdata);
            $result = rename($tmpfname, "upload/" . $filename);
            if ($result) {
                http_response_code(201);
                echo("File Created " . $filename);
            } else {
                http_response_code(403);
                echo("Renaming file to upload/" . $filename . " failed.");
            }
        } else {
            http_response_code(403);
            echo("Could not open tmp file " . $tmpfname);
        }
    }
    else {
        http_response_code(403);
        echo("Could not read upload stream.");
    }
?>
