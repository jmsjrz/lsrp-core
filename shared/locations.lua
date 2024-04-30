--- Table contenant les emplacements dans le jeu.
--- Chaque emplacement est représenté par une clé et une valeur.
--- La clé est le nom de l'emplacement et la valeur est un vecteur à quatre composantes (x, y, z, h).
--- Les composantes x, y et z représentent les coordonnées de l'emplacement dans le monde du jeu.
--- La composante h représente l'orientation de l'emplacement en degrés.
LSRPShared.Locations = {
    -- Emplacements des intérieurs du jeu de base
    aircraft_carrier_int = vector4(3081.0042, -4693.6875, 15.2623, 76.8169),
    apt_1_int = vector4(-1452.4602, -540.2056, 74.0443, 31.9129),
    apt_2_int = vector4(-912.7861, -365.2444, 114.2748, 110.0791),
    apt_3_int = vector4(-603.3033, 58.9509, 98.2002, 81.6158),
    apt_4_int = vector4(-784.6159, 323.849, 211.9972, 260.1097),
    apt_5_int = vector4(-31.1088, -595.1442, 80.0309, 238.7146),
    apt_6_int = vector4(-603.0135, 59.0137, -182.3809, 79.5818),
    apt_hi_1_int = vector4(-18.3525, -590.9888, 90.1148, 331.3955),
    apt_hi_2_int = vector4(-1450.2595, -525.3569, 56.929, 29.844),
    bahama_mamas_int = vector4(-1387.0503, -588.4022, 30.3195, 124.4977),
    biker_clubhouse_1_int = vector4(1121.1473, -3152.606, -37.0627, 354.0713),
    biker_clubhouse_2_int = vector4(997.1274, -3157.5261, -38.9071, 239.8958),
    casino_garage_int = vector4(1380.0403, 178.7124, -48.9942, 351.2701),
    casino_hotel_floor_5_int = vector4(2508.6404, -262.1918, -39.1218, 183.9682),
    casino_interior_int = vector4(1089.1294, 207.2294, -48.9997, 320.0139),
    casino_loading_bay_int = vector4(2519.0271, -279.1287, -64.7228, 273.2338),
    casino_nightclub_int = vector4(1578.2496, 253.7532, -46.0051, 174.0727),
    casino_offices_int = vector4(2485.0115, -250.7915, -55.1238, 270.4959),
    casino_security_int = vector4(2548.1143, -267.3465, -58.723, 192.4636),
    casino_vault_int = vector4(2506.9446, -238.5225, -70.7371, 268.6321),
    casino_vault_lobby_int = vector4(2465.6365, -278.9171, -70.6942, 264.7971),
    cocaine_lockup_int = vector4(1088.6353, -3187.8801, -38.9935, 178.8853),
    counterfeit_cash_int = vector4(1138.2513, -3198.7056, -39.6657, 66.1039),
    document_forgery_int = vector4(1173.4496, -3196.7759, -39.008, 77.9179),
    doomsday_facility_int = vector4(453.0641, 4820.2095, -58.9997, 87.7778),
    exec_apt_1_int = vector4(-786.7757, 315.4629, 217.6385, 269.4638),
    exec_apt_2_int = vector4(-773.9349, 342.1293, 196.6862, 87.2747),
    exec_apt_3_int = vector4(-787.0633, 315.7905, 187.9135, 276.2593),
    fib_floor_47_int = vector4(136.714, -765.5745, 234.152, 76.3983),
    fib_floor_49_int = vector4(136.2863, -765.8568, 242.1519, 79.0446),
    fib_top_floor_int = vector4(156.6616, -759.0523, 258.1518, 83.4114),
    franklins_house_int = vector4(-14.1716, -1440.7046, 31.1015, 2.7505),
    house_hi_1_int = vector4(-174.1817, 497.7469, 137.6537, 195.447),
    house_hi_2_int = vector4(342.0325, 437.7024, 149.3897, 125.2541),
    house_hi_3_int = vector4(373.5483, 423.4114, 145.9079, 162.7296),
    house_hi_4_int = vector4(-682.3972, 592.3556, 145.3927, 233.6731),
    house_hi_5_int = vector4(-758.5825, 619.0045, 144.1539, 118.2023),
    house_hi_6_int = vector4(-860.154, 690.9542, 152.8608, 192.5502),
    house_hi_7_int = vector4(117.227, 559.6552, 184.3049, 190.2912),
    house_low_1_int = vector4(266.0239, -1007.0026, -100.9048, 357.9751),
    house_mid_1_int = vector4(346.855, -1012.7548, -99.1963, 355.3892),
    iaa_facility_1_int = vector4(2154.9517, 2921.0366, -61.9025, 96.9736),
    iaa_facility_2_int = vector4(2154.6731, 2921.0784, -81.0755, 268.6461),
    lesters_factory_int = vector4(717.8725, -974.6326, 24.9142, 359.5224),
    lesters_house_int = vector4(1273.9886, -1719.4897, 54.7715, 11.6602),
    meth_lab_int = vector4(997.4726, -3200.6846, -36.3937, 307.2153),
    morgue_int = vector4(274.9287, -1361.0305, 24.5378, 48.8693),
    motel_room_int = vector4(151.379, -1007.7512, -99.0, 326.917),
    movie_theatre_int = vector4(-1437.0271, -243.3148, 16.8335, 200.8791),
    nightclub_1_int = vector4(-1569.494, -3016.9558, -74.4061, 359.8158),
    office_1_int = vector4(-140.6184, -619.2825, 168.8203, 183.2728),
    office_2_int = vector4(-77.2845, -828.4749, 243.3858, 330.7214),
    office_3_int = vector4(-1579.7123, -562.8762, 108.5229, 217.1494),
    office_4_int = vector4(-1394.6268, -479.7602, 72.0421, 273.3521),
    psychiatrist_office_int = vector4(-1902.1859, -572.3267, 19.0972, 106.6428),
    shell_1_int = vector4(404.9589, -957.7651, -99.0042, 1.7754),
    submarine_int = vector4(512.8119, 4881.4795, -62.5867, 359.146),
    uniondepository_int = vector4(5.8001, -708.6383, 16.131, 348.7656),
    weed_farm_int = vector4(1066.0164, -3183.4456, -39.1635, 96.9736),

    -- Emplacements inconnus/aléatoires/vanilla
    burgershot = vector4(-1199.0568, -882.4495, 13.3500, 209.1105),
    casino = vector4(923.2289, 47.3113, 81.1063, 237.6052),

    -- Emplacements de Gabz
    arcade = vector4(-1649.6089, -1083.9313, 13.1575, 46.4121),
    beanmachinelegion = vector4(116.16, -1022.99, 29.3, 0.0),
    bowling = vector4(761.5008, -777.7256, 26.3078, 90.5581),
    pizzaria = vector4(790.4561, -758.4601, 26.7424, 270.2329),
    catcafe = vector4(-580.8388, -1072.7872, 22.3296, 359.0078),
    carmeet = vector4(958.8237, -1699.6659, 29.5574, 71.2731),
    popsdiner = vector4(1595.9753, 6448.6421, 25.3170, 28.3026),
    harmony = vector4(1183.0693, 2648.5313, 37.8363, 194.0603),
    haters = vector4(-1117.1525, -1439.4297, 5.1075, 103.4411),
    hayes = vector4(-1435.7040, -445.7360, 35.5964, 220.1762),
    pdm = vector4(-48.2113, -1105.4769, 27.2634, 339.5899),
    bennys = vector4(-47.5289, -1042.6086, 28.3532, 247.9748),
    lamesaauto = vector4(720.4776, -1092.1934, 22.2866, 310.1469),
    lostmc = vector4(982.6339, -104.7095, 74.8488, 30.8738),
    pillbox = vector4(298.1153, -584.2825, 43.2609, 252.7553),
    mirrorparkhouse1 = vector4(945.9535, -652.9119, 58.0228, 90.5541),
    pacificbank = vector4(229.9529, 214.3890, 105.5561, 294.6791),
    paletoliquor = vector4(-154.2287, 6328.8682, 31.5665, 133.1992),
    paletogasstation = vector4(120.2420, 6625.4722, 31.9580, 36.5687),
    pinkcage = vector4(323.9055, -203.2524, 54.0866, 186.8505),
    ponsonbys1 = vector4(-165.2497, -304.3988, 38.07126, 0.0),
    ponsonbys2 = vector4(-1448.1, -236.8420, 48.15098, 0.0),
    ponsonbys3 = vector4(-709.8120, -150.6267, 35.75312, 0.0),
    rangerstation = vector4(387.3204, 790.1508, 187.6927, 4.7656),
    recordastudio = vector4(473.3006, -109.4360, 62.7418, 350.8488),
    suburban1 = vector4(124.9756, -217.6290, 55.81879, 0.0),
    suburban2 = vector4(617.4776, 2757.4810, 43.34935, 0.0),
    suburban3 = vector4(-1195.8690, -773.5746, 18.58485, 0.0),
    suburban4 = vector4(-3170.9670, 1049.9310, 22.12445, 0.0),
    triadrecords = vector4(-829.0061, -698.2049, 28.0583, 291.2052),
    tuner = vector4(157.5888, -3017.9968, 7.0400, 94.0695),
    vu = vector4(129.4555, -1299.6754, 29.2327, 27.6378),

    -- Emplacements de Patoche
    luxerydealership = vector4(-1273.22, -371.11, 36.64, 301.8),

    -- Emplacements de Unclejust
    digitalden = vector4(-656.28, -849.92, 24.51, 167.42),
    ifruitstore1 = vector4(-646.78, -288.17, 35.49, 297.73),
    ifruitstore2 = vector4(-778.7451, -598.2717, 30.2772, 181.0197)
}
