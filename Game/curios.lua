local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local curios = {
curio1 = {
  immagine = "Images/Icons/curios/treasureChest_close.png",
  messaggio = "interazione",
  funzione = (
    function(item, curio)
      if item.nome == "Images/Icons/icons3/029-key.png" then
        print("aperto")
        curio.immagine = "Images/Icons/curios/treasureChest_open.png"
        display.remove(curio)
        local createdCurio = display.newImageRect("Images/Icons/curios/treasureChest_open.png", 100, 175)
        createdCurio.x =lunghezza * 0.7
        createdCurio.y =altezza-390
        return true
      else
        print("tentativo di interazione fallito")
        return false
      end
    end
   )
}
}
return curios
