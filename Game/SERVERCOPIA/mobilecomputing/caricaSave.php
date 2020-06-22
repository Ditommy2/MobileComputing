<?php
$conn = new mysqli("localhost", "id13097986_supercafoni", "2QM{-&[Yfev|J=Jk", "id13097986_appmcdata") or die("Error connecting to database");

$uploaddir = '/var/www/uploads/';
$uploadfile = $uploaddir . basename($_FILES[0]['name']);

$fileName = $_POST['name'];
print($fileName);
$temp = explode('$$', $fileName);
$username = $temp[1];
$nomePartita = $temp[2];

$sql = "INSERT INTO Partita (Giocatore, FilePartita, nomePartita) VALUES ('$username','$file','$nomePartita')";

mysqli_query($conn,$sql) or die (mysqli_error($conn));

?>
