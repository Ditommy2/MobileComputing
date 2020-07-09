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
      local itemInterface = require("itemsInterface")
      if item.nome == "029-key.png" then
        print("aperto")
        curio.immagine = "Images/Icons/curios/treasureChest_open.png"
        table.insert(composer.getVariable( "stanzaCorrente" ).oggetti, curio.oggetto)
        local datiOggetto = itemInterface[curio.oggetto]
        local oggetto = display.newImageRect(datiOggetto.location..datiOggetto.nome, 70, 70)
        oggetto.x=curio.x-20
        oggetto.y = curio.y
        oggetto.id = 11
        oggetto.curio = curio
        oggetto.activateFunction = datiOggetto.activateFunction
        oggetto.nome=datiOggetto.nome
        local interfaceConfig = require("interfaceConfig")
        oggetto:addEventListener("touch", interfaceConfig.dragItem)
        composer.getVariable("mainGroup"):insert(oggetto)
        oggetto:toBack()

        display.remove(curio)
        return true
      else
        print("tentativo di interazione fallito")
        return false
      end
    end
  ),
  sostitutivo = "curio2",
  oggettiPossibili = {"anelloDifesa"}
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
