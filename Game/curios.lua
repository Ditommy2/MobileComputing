local lunghezza =  display.contentWidth
local composer = require("composer")
local altezza=  lunghezza*(9/16)
local curios = {
curio1 = {
  nome="curio1",
  immagine = "Images/Icons/curios/treasureChest_close.png",
  messaggio = "interazione",
  funzione = (
    function(item, curio)
      if item.nome == "Images/Icons/icons3/029-key.png" then
        print("aperto")
        curio.immagine = "Images/Icons/curios/treasureChest_open.png"
        display.remove(curio)
        return true
      else
        print("tentativo di interazione fallito")
        return false
      end
    end
  ),
  sostitutivo = "curio2"
},
curio2 = {
  nome="curio2",
  immagine = "Images/Icons/curios/treasureChest_open.png",
  messaggio="interazione",
  funzione = (
  function(item, curio)
    print(curio.messaggio)
  end
)
}
}
return curios
