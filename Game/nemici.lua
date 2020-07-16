local nemici ={

  nemico1={   --OK
    immagine ="Images/Enemies/FallenAngel1/Idle.png",
    attack ="Images/Enemies/FallenAngel1/slashing.png",
    suono = "spada",
    life= 900,
    damage= 70,
    armor= 6,
    speed= 3,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=117,
      height=157,
      frames=37,
    },
    sheet_attack =
    {
      width=191,
      height=173,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 37,
      time = 600,
      loopCount = 0,
      loopDirection = "forward",
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico2={   --OK
    immagine ="Images/Enemies/FallenAngel2/Idle.png",
    attack ="Images/Enemies/FallenAngel2/slashing.png",
    suono = "spada",
    life= 900,
    damage= 70,
    armor= 6,
    speed= 3,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=117,
      height=147,
      frames=37,
    },
    sheet_attack =
    {
      width=195,
      height=177,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 37,
      time = 600,
      loopCount = 0,
      loopDirection = "forward",
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico3={   --OK
    immagine ="Images/Enemies/FallenAngel3/Idle.png",
    attack ="Images/Enemies/FallenAngel3/slashing.png",
    suono = "spada",
    life= 900,
    damage= 70,
    armor= 6,
    speed= 3,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=119,
      height=167,
      frames=37,
    },
    sheet_attack =
    {
      width=196,
      height=181,
      frames=25,
    },
    idleOptions=
    {
        start = 1,
        count = 36,
        time = 600,
        loopCount = 0,
        loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico4={   --OK
    immagine ="Images/Enemies/IceGolem/Idle.png",
    attack ="Images/Enemies/IceGolem/slashing.png",
    suono = "spada",
    life= 700,
    damage= 50,
    armor= 7,
    speed= 3,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=104,
      height=138,
      frames=37,
    },
    sheet_attack =
    {
      width=163,
      height=150,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 37,
      time = 600,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico5={   --OK
    immagine ="Images/Enemies/EarthGolem/Idle.png",
    attack ="Images/Enemies/EarthGolem/slashing.png",
    suono = "mazza",
    life= 700,
    damage= 50,
    armor= 7,
    speed= 3,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=99,
      height=145,
      frames=37,
    },
    sheet_attack =
    {
      width=164,
      height=158,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 37,
      time = 600,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico6={   --OK
    immagine ="Images/Enemies/MagmaGolem/Idle.png",
    attack ="Images/Enemies/MagmaGolem/slashing.png",
    suono = "spada",
    life= 700,
    damage= 50,
    armor= 7,
    speed= 3,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=98,
      height=134,
      frames=37,
    },
    sheet_attack =
    {
      width=162,
      height=144,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 37,
      time = 600,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico7={   --OK
    immagine ="Images/Enemies/StoneGolem/Idle.png",
    attack ="Images/Enemies/StoneGolem/slashing.png",
    suono = "mazza",
    life= 1200,
    damage=75,
    armor= 5,
    speed= 2,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=180,
      height=146,
      frames=26,
    },
    sheet_attack =
    {
      width=213,
      height=183,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 26,
      time = 400,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico8={   --OK
    immagine ="Images/Enemies/MudGolem/Idle.png",
    attack ="Images/Enemies/MudGolem/slashing.png",
    suono = "accetta",
    life= 1200,
    damage=75,
    armor= 5,
    speed= 2,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=182,
      height=146,
      frames=26,
    },
    sheet_attack =
    {
      width=217,
      height=185,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 26,
      time = 400,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico9={   --OK
    immagine ="Images/Enemies/WoodGolem/Idle.png",
    attack ="Images/Enemies/WoodGolem/slashing.png",
    suono = "mazza",
    life= 1200,
    damage=75,
    armor= 5,
    speed= 2,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=180,
      height=145,
      frames=26,
    },
    sheet_attack =
    {
      width=213,
      height=182,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 26,
      time = 400,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico10={    --OK
    immagine ="Images/Enemies/Goblin/Idle.png",
    attack ="Images/Enemies/Goblin/slashing.png",
    suono = "accetta",
    life= 500,
    damage=50,
    armor= 7,
    speed= 4,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=101,
      height=134,
      frames=40,
    },
    sheet_attack =
    {
      width=171,
      height=147,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 40,
      time = 600,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico11={    --OK
    immagine ="Images/Enemies/Ogre/Idle.png",
    attack ="Images/Enemies/Ogre/slashing.png",
    suono = "accetta",
    life= 1400,
    damage=80,
    armor= 5,
    speed= 2,
    points= 1000,
    drop = {
      "pozioneVita",
      "chiaveForziere",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=119,
      height=168,
      frames=40,
    },
    sheet_attack =
    {
      width=203,
      height=181,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 40,
      time = 600,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico12={    --OK
    immagine ="Images/Enemies/Orco/Idle.png",
    attack ="Images/Enemies/Orco/slashing.png",
    suono = "mazza",
    life= 1600,
    damage=90,
    armor= 4,
    speed= 2,
    points= 1000,
    drop = {
      "pozioneVita",
      "chiaveForziere",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=144,
      height=211,
      frames=36,
    },
    sheet_attack =
    {
      width=244,
      height=226,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 36,
      time = 600,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico13={    --OK
    immagine ="Images/Enemies/ReaperMan1/Idle.png",
    attack ="Images/Enemies/ReaperMan1/slashing.png",
    suono = "spada",
    life= 1000,
    damage=70,
    armor= 6,
    speed= 3,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=128,
      height=161,
      frames=35,
    },
    sheet_attack =
    {
      width=189,
      height=173,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 35,
      time = 600,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico14={    --OK
    immagine ="Images/Enemies/ReaperMan2/Idle.png",
    attack ="Images/Enemies/ReaperMan2/slashing.png",
    suono = "spada",
    life= 1000,
    damage=70,
    armor= 6,
    speed= 3,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=126,
      height=161,
      frames=35,
    },
    sheet_attack =
    {
      width=190,
      height=173,
      frames=25,
    },

    idleOptions=
    {
      start = 1,
      count = 35,
      time = 600,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },

  },

  nemico15={  --OK
    immagine ="Images/Enemies/ReaperMan3/Idle.png",
    attack ="Images/Enemies/ReaperMan3/slashing.png",
    suono = "spada",
    life= 1000,
    damage=70,
    armor= 6,
    speed= 3,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=127,
      height=160,
      frames=36,
    },
    sheet_attack =
    {
      width=190,
      height=171,
      frames=25,
    },

    idleOptions=
    {
      start = 1,
      count = 36,
      time = 600,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },

  },

  nemico16={    --OK
    immagine ="Images/Enemies/Satiro1/Idle.png",
    attack ="Images/Enemies/Satiro1/slashing.png",
    suono = "mazza",
    life= 300,
    damage=40,
    armor= 8,
    speed= 5,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=122,
      height=123,
      frames=25,
    },
    sheet_attack =
    {
      width=154,
      height=133,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico17={    --OK
    immagine ="Images/Enemies/Satiro2/Idle.png",
    attack ="Images/Enemies/Satiro2/slashing.png",
    suono = "spada",
    life= 300,
    damage=40,
    armor= 8,
    speed= 5,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=133,
      height=121,
      frames=25,
    },
    sheet_attack =
    {
      width=166,
      height=134,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico18={    --OK
    immagine ="Images/Enemies/Satiro3/Idle.png",
    attack ="Images/Enemies/Satiro3/slashing.png",
    suono = "accetta",
    life= 300,
    damage=40,
    armor= 8,
    speed= 5,
    points= 1000,
    drop = {
      "pozioneVita",
      "cibo",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=141,
      height=122,
      frames=25,
    },
    sheet_attack =
    {
      width=169,
      height=138,
      frames=25,
    },
    idleOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 25,
      time = 400,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico19={    --OK
    immagine ="Images/Enemies/Troll1/Idle.png",
    attack ="Images/Enemies/Troll1/slashing.png",
    suono = "mazza",
    life= 2000,
    damage=100,
    armor= 3,
    speed= 1,
    points= 1000,
    drop = {
      "pozioneVita",
      "chiaveForziere",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=271,
      height=186,
      frames=60,
    },
    sheet_attack =
    {
      width=346,
      height=302,
      frames=60,
    },
    idleOptions=
    {
      start = 1,
      count = 60,
      time = 1000,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 60,
      time = 1000,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico20={    --OK
    immagine ="Images/Enemies/Troll2/Idle.png",
    attack ="Images/Enemies/Troll2/slashing.png",
    suono = "mazza",
    life= 2000,
    damage=100,
    armor= 3,
    speed= 1,
    points= 1000,
    drop = {
      "pozioneVita",
      "chiaveForziere",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=264,
      height=183,
      frames=60,
    },
    sheet_attack =
    {
      width=334,
      height=290,
      frames=60,
    },
    idleOptions=
    {
      start = 1,
      count = 60,
      time = 1000,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 60,
      time = 1000,
      loopCount = 1,
      loopDirection = "forward",
    },
  },

  nemico21={    --OK
    immagine ="Images/Enemies/Troll3/Idle.png",
    attack ="Images/Enemies/Troll3/slashing.png",
    suono = "mazza",
    life= 2000,
    damage=100,
    armor= 3,
    speed= 1,
    points= 1000,
    drop = {
      "pozioneVita",
      "chiaveForziere",
    },
    mossa1={
      damage=1,
      hitChance=5,
      effect = {target = "armor", value = -2},
      critChance = 5
    },
    mossa2={
      damage=0.7,
      hitChance=5,
      effect = {target = "damage", value = -5},
      critChance = 5
    },
    mossa3={
      damage=0.8,
      hitChance=5,
      effect = {target = "life", value = -200},
      critChance = 6
    },
    mossa4={
      damage=0.9,
      hitChance=5,
      effect = {target = "stunned", value = 2},
      critChance = 5
    },
    sheet_idle =
    {
      width=258,
      height=187,
      frames=60,
    },
    sheet_attack =
    {
      width=334,
      height=293,
      frames=60,
    },
    idleOptions=
    {
      start = 1,
      count = 60,
      time = 1000,
      loopCount = 0,
      loopDirection = "forward"
    },
    attackOptions=
    {
      start = 1,
      count = 60,
      time = 1000,
      loopCount = 1,
      loopDirection = "forward",
    },
  },
}
return nemici
