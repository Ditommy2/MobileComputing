<?php
$con = mysqli_connect('localhost','id13097986_supercafoni','2QM{-&[Yfev|J=Jk', 'id13097986_appmcdata') or die("Error connecting to database");;

$File = $_FILES['userfile'];

$jsonString = file_get_contents($file);
$data = json_decode($jsonString, true);


$sql = "INSERT INTO Partita (nomePartita, Giocatore, FilePartita) VALUES ('$idfile','$ext','$File')";


mysqli_query($con,$sql) or die (mysqli_error($con));

?>
