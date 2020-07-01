local nemici ={

  nemico1={   --OK
    immagine ="Images/Enemies/FallenAngel1/Idle.png",
    vita = 50000,
    danno = 100,
    armatura = 10,
    velocita = math.random(1, 10),
    width=117,
    height=157,
    frames=37,
    sequences =
    {
        {
            name = "idle",
            start = 1,
            count = 37,
            time = 600,
            loopCount = 0,
            loopDirection = "forward"
        }
    },
  },

  nemico2={   --OK
    immagine ="Images/Enemies/FallenAngel2/Idle.png",
    vita = 9,
    danno = 3,
    armatura = 0,
    velocita = 3,
    width=117,
    height=147,
    frames=37,
    sequences =
    {
        {
            name = "idle",
            start = 1,
            count = 37,
            time = 600,
            loopCount = 0,
            loopDirection = "forward"
        }
    },
  },

  nemico3={   --OK
    immagine ="Images/Enemies/FallenAngel3/Idle.png",
    vita = 9,
    danno = 3,
    armatura = 0,
    velocita = 3,
    width=119,
    height=166,
    frames=36,
    sequences =
    {
        {
            name = "idle",
            start = 1,
            count = 36,
            time = 600,
            loopCount = 0,
            loopDirection = "forward"
        }
    },
  },

  nemico4={   --OK
    immagine ="Images/Enemies/IceGolem/Idle.png",
    vita = 9,
    danno = 3,
    armatura = 0,
    velocita = 3,
    width=104,
    height=138,
    frames=37,
    sequences =
    {
        {
            name = "idle",
            start = 1,
            count = 37,
            time = 600,
            loopCount = 0,
            loopDirection = "forward"
        }
    },
  },

  nemico5={   --OK
    immagine ="Images/Enemies/EarthGolem/Idle.png",
    vita = 9,
    danno = 3,
    armatura = 0,
    velocita = 3,
    width=101,
    height=146,
    frames=36,
    sequences =
    {
        {
            name = "idle",
            start = 1,
            count = 36,
            time = 600,
            loopCount = 0,
            loopDirection = "forward"
        }
    },
  },

  nemico6={   --OK
    immagine ="Images/Enemies/MagmaGolem/Idle.png",
    vita = 9,
    danno = 3,
    armatura = 0,
    velocita = 3,
    width=98,
    height=134,
    frames=37,
    sequences =
    {
        {
            name = "idle",
            start = 1,
            count = 37,
            time = 600,
            loopCount = 0,
            loopDirection = "forward"
        }
    },
  },

  nemico7={   --Tremolicchia                                --DA QUI IN GIU' DEVONO ESSERE SISTEMATI
    immagine ="Images/Enemies/StoneGolem/Idle.png",         --GLI ALTRI FUNZIONANO
    vita = 9,
    danno = 3,
    armatura = 0,
    velocita = 3,
    width=180,
    height=146,
    frames=30,
    sequences =
    {
        {
            name = "idle",
            start = 1,
            count = 30,
            time = 500,
            loopCount = 0,
            loopDirection = "forward"
        }
    },
  },

  nemico8={
    immagine ="Images/Enemies/MudGolem/Idle.png",
    vita = 9,
    danno = 3,
    armatura = 0,
    velocita = 3,
    width=182,
    height=146,
    frames=25,
    sequences =
    {
        {
            name = "idle",
            start = 1,
            count = 25,
            time = 600,
            loopCount = 0,
            loopDirection = "forward"
        }
    },
  },
  -- nemico9={
  --   immagine ="Images/Enemies/WoodGolem/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=150,
  --   height=122,
  -- },
  -- nemico10={
  --   immagine ="Images/Enemies/Goblin/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=119,
  --   height=160,
  -- },
  -- nemico11={
  --   immagine ="Images/Enemies/Ogre/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=119,
  --   height=160,
  -- },
  -- nemico12={
  --   immagine ="Images/Enemies/Orco/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=119,
  --   height=160,
  -- },
  -- nemico13={
  --   immagine ="Images/Enemies/ReaperMan1/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=119,
  --   height=160,
  -- },
  -- nemico14={
  --   immagine ="Images/Enemies/ReaperMan2/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=119,
  --   height=160,
  -- },
  -- nemico15={
  --   immagine ="Images/Enemies/ReaperMan3/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=119,
  --   height=160,
  -- },
  -- nemico16={
  --   immagine ="Images/Enemies/Satiro1/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=129,
  --   height=131,
  -- },
  -- nemico17={
  --   immagine ="Images/Enemies/Satiro2/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=129,
  --   height=131,
  -- },
  -- nemico18={
  --   immagine ="Images/Enemies/Satiro3/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=129,
  --   height=131,
  -- },
  -- nemico19={
  --   immagine ="Images/Enemies/Troll1/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=193,
  --   height=133,
  -- },
  -- nemico20={
  --   immagine ="Images/Enemies/Troll2/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=193,
  --   height=133,
  -- },
  -- nemico21={
  --   immagine ="Images/Enemies/Troll3/Idle.png",
  --   vita = 9,
  --   danno = 3,
  --   armatura = 0,
  --   velocita = 3,
  --   width=193,
  --   height=133,
  -- }
}
return nemici
