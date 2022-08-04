// TrackMania DS
// #ID = 18333

// $12E538: [24-bit + 0x24B0] - [32-bit] Platform Retries
// $12E560: [24-bit + 0x60] - [32-bit] Race Countdown
//          ---------------------------------------------------------------
//          [24-bit + 0x94] - [32-bit] Checkpoint Time
//          ---------------------------------------------------------------
//          [24-bit + 0x150] - [32-bit] Race Timer
//          ---------------------------------------------------------------
//          [24-bit + 0x154] - [8-bit] Race has started:
//          
//          - 0x00: Has started
//          - 0x01: Has not started
//          ---------------------------------------------------------------
//          [24-bit + 0x160] - [8-bit] Is game paused:
//
//          - 0x00: Paused
//          - 0x01: Not paused
//          ---------------------------------------------------------------
//          [24-bit + 0x161] - [8-bit] Race has ended:
//          
//          - 0x00: Has ended
//          - 0x01: Has not ended
// $1A4CB4: [32-bit] Solo Gamemode:
//          
//          - 0x00: Race
//          - 0x01: Platform
//          - 0x02: Puzzle
//          - 0x03: Quick Race
//          - 0x04: Custom
// $227BB8: [32-bit] Enviroment:
//          
//          - 0x00: Stadium
//          - 0x01: Desert
//          - 0x02: Rally
// $227BC0: [32-bit] Difficulty:
//          
//          - 0x00: Practice
//          - 0x01: Easy
//          - 0x02: Medium
//          - 0x03: Hard
//          - 0x04: Extreme
//          - 0x05: Bonus
// $227BC4: [32-bit] Track (Ranges from 0x00 to 0x04)


//Helper functions
//  Converts from ingame time representation to a value of 0x1 = 1 centisec
function rawData2Time(rawData) => rawData * 0.024414

//  Converts from a value of 0x1 = 1 centisec to ingame time representation
function time2RawData(time) => time * 40.96

//  Gets current ingame timer 
function getTimer() => dword(tbyte(0x12E560) + 0x150)

//  Gets number of retries in current track
function getRetries() => dword(tbyte(0x12E538) + 0x24B0)

//  Returns true the frame a race starts
function raceStart() => prev(byte(tbyte(0x12E560) + 0x154)) == 1 && byte(tbyte(0x12E560) + 0x154) == 0

//  Returns true the frame a race ends
function raceEnd() => prev(byte(tbyte(0x12E560) + 0x161)) == 1 && byte(tbyte(0x12E560) + 0x161) == 0

//  Returns true if race has started
function isRaceStarted() => byte(tbyte(0x12E560) + 0x154) == 0

// Returns true if race is paused
function isRacePaused() => byte(tbyte(0x12E560) + 0x160) == 0

//  Returns true if player is on track with provided params
function isInTrack(track, enviroment, difficulty) => dword(0x227BC4) == track && dword(0x227BB8) == enviroment && dword(0x227BC0) == difficulty

//  Returns true if player is on menu
function inMenu() => tbyte(0x12E560) == 0

//  Returns current savefile index
function getFileIndex() => byte(0x221914)

//  Returns true if on race gamemode
function isOnRaceMode() => dword(0x1A4CB4) == 0 || dword(0x1A4CB4) == 3

//  Returns true if on platform gamemode
function isOnPlatformMode() => dword(0x1A4CB4) == 1

//  Returns true if on puzzle gamemode
function isOnPuzzleMode() => dword(0x1A4CB4) == 2

//  Gets race index with provided params
function raceIndex(track, enviroment, difficulty) => track + enviroment * 5 + difficulty * 15

//  Gets puzzle index with provided params
function puzzleIndex(track, difficulty) => track + difficulty * 3

//Dictionaries
Enviroments = {
    0: "Stadium",
    1: "Desert",
    2: "Rally"
}

Difficulty = {
    0: "A",
    1: "B",
    2: "C",
    3: "D",
    4: "E",
    5: "F"
}

//Medal addresses
Medals = {
    "Race": {
        "Gold": [0x220F5C, 0x225EA4, 0x226AFC],
        "Silver": [0x220F60, 0x225EA8, 0x226B00],
        "Bronze": [0x220F64, 0x225EAC, 0x226B04],
        "Author": [0x220F68, 0x225EB0, 0x226B08]
    },
    "Puzzle": {
        "Gold": [0x220F6C, 0x225EB4, 0x226B0C],
        "Silver": [0x220F70, 0x225EB8, 0x226B10],
        "Bronze": [0x220F74, 0x225EBC, 0x226B14]
    },
    "Platform": {
        "Gold": [0x220F7C, 0x225EC4, 0x226B1C],
        "Silver": [0x220F80, 0x225EC8, 0x226B20],
        "Bronze": [0x220F84, 0x225ECC, 0x226B24]
    }
}

//Shop addresses
Shop = {
    "Skins":{
        "Stadium":{
            "Address": [0x223CDC, 0x225CE4, 0x22657C],
            "Count": 10
        },
        "Desert":{
            "Address": [0x223CEC, 0x225CF4, 0x22658C],
            "Count": 10
        },
        "Rally":{
            "Address": [0x223CFC, 0x225D04, 0x22659C],
            "Count": 10
        }
    },
    "Blocks":{
        "Stadium":{
            "Address": [0x223BE6, 0x225BEE, 0x226486],
            "Count": 45
        },
        "Desert":{
            "Address": [0x223C26, 0x225C2E, 0x2264C6],
            "Count": 34
        },
        "Rally":{
            "Address": [0x223C66, 0x225C6E, 0x226506],
            "Count": 27
        }
    },
    "Tracks":{
        "Stadium":{
            "Address": [0x223CA6, 0x225CAE, 0x226546],
            "Count": 5
        },
        "Desert":{
            "Address": [0x223CAB, 0x225CB3, 0x22654B],
            "Count": 5
        },
        "Rally":{
            "Address": [0x223CB0, 0x225CB8, 0x226550],
            "Count": 5
        }
    }
}

RaceGoldTime = {
    0: 1753,
    1: 2281,
    2: 2017,
    3: 2123,
    4: 2637,
    5: 1889,
    6: 2184,
    7: 2186,
    8: 2271,
    9: 2033,
    10: 1696,
    11: 1638,
    12: 2211,
    13: 1844,
    14: 1939,
    15: 6218,
    16: 2327,
    17: 3899,
    18: 1812,
    19: 3413,
    20: 2460,
    21: 2792,
    22: 2988,
    23: 2657,
    24: 5319,
    25: 2709,
    26: 1990,
    27: 7312,
    28: 2194,
    29: 3976,
    30: 10963,
    31: 5028,
    32: 8428,
    33: 9074,
    34: 4550,
    35: 3745,
    36: 4341,
    37: 3282,
    38: 3946,
    39: 6811,
    40: 2491,
    41: 3507,
    42: 6313,
    43: 6700,
    44: 5229,
    45: 6443,
    46: 6018,
    47: 3527,
    48: 4610,
    49: 5920,
    50: 2637,
    51: 5586,
    52: 2787,
    53: 2973,
    54: 2561,
    55: 11475,
    56: 4500,
    57: 2973,
    58: 10636,
    59: 3858,
    60: 6009,
    61: 6557,
    62: 6871,
    63: 6379,
    64: 9222,
    65: 2090,
    66: 4108,
    67: 2642,
    68: 3159,
    69: 9775,
    70: 7054,
    71: 8280,
    72: 3547,
    73: 12575,
    74: 14820,
    75: 2971,
    76: 2357,
    77: 3243,
    78: 2860,
    79: 4098,
    80: 5991,
    81: 5989,
    82: 2209,
    83: 5677,
    84: 3584,
    85: 8061,
    86: 2732,
    87: 2910,
    88: 4517,
    89: 3737
}

RaceAuthorTime = {
    0: 1617,
    1: 1901,
    2: 1876,
    3: 2120,
    4: 2511,
    5: 1772,
    6: 2070,
    7: 2012,
    8: 2268,
    9: 1976,
    10: 1539,
    11: 1466,
    12: 1997,
    13: 1841,
    14: 1758,
    15: 5284,
    16: 2100,
    17: 3594,
    18: 1667,
    19: 3086,
    20: 2387,
    21: 2739,
    22: 2917,
    23: 2542,
    24: 4655,
    25: 1909,
    26: 1622,
    27: 6466,
    28: 1914,
    29: 3675,
    30: 9679,
    31: 4322,
    32: 7459,
    33: 8221,
    34: 4257,
    35: 3415,
    36: 4175,
    37: 2985,
    38: 3815,
    39: 6081,
    40: 2230,
    41: 2962,
    42: 5459,
    43: 6131,
    44: 4627,
    45: 6158,
    46: 5495,
    47: 3334,
    48: 4330,
    49: 5872,
    50: 2490,
    51: 5228,
    52: 2585,
    53: 2651,
    54: 2270,
    55: 10580,
    56: 3988,
    57: 2633,
    58: 9516,
    59: 3486,
    60: 5743,
    61: 6286,
    62: 6493,
    63: 6101,
    64: 9085,
    65: 2025,
    66: 3628,
    67: 2469,
    68: 2972,
    69: 8900,
    70: 6339,
    71: 7378,
    72: 3277,
    73: 11635,
    74: 14369,
    75: 2964,
    76: 2127,
    77: 2985,
    78: 2573,
    79: 3953,
    80: 5590,
    81: 5515,
    82: 1982,
    83: 5434,
    84: 3498,
    85: 6632,
    86: 2447,
    87: 2638,
    88: 4230,
    89: 3473
}

RaceGoldTimeText = {
    0: "0:17:53",
    1: "0:22:81",
    2: "0:20:17",
    3: "0:21:23",
    4: "0:26:37",
    5: "0:18:89",
    6: "0:21:84",
    7: "0:21:86",
    8: "0:22:71",
    9: "0:20:33",
    10: "0:16:96",
    11: "0:16:38",
    12: "0:22:11",
    13: "0:18:44",
    14: "0:19:39",
    15: "1:02:18",
    16: "0:23:27",
    17: "0:38:99",
    18: "0:18:12",
    19: "0:34:13",
    20: "0:24:60",
    21: "0:27:92",
    22: "0:29:88",
    23: "0:26:57",
    24: "0:53:19",
    25: "0:27:09",
    26: "0:19:90",
    27: "1:13:12",
    28: "0:21:94",
    29: "0:39:76",
    30: "1:49:63",
    31: "0:50:28",
    32: "1:24:28",
    33: "1:30:74",
    34: "0:45:50",
    35: "0:37:45",
    36: "0:43:41",
    37: "0:32:82",
    38: "0:39:46",
    39: "1:08:11",
    40: "0:24:91",
    41: "0:35:07",
    42: "1:03:13",
    43: "1:07:00",
    44: "0:52:29",
    45: "1:04:43",
    46: "1:00:18",
    47: "0:35:27",
    48: "0:46:10",
    49: "0:59:20",
    50: "0:26:37",
    51: "0:55:86",
    52: "0:27:87",
    53: "0:29:73",
    54: "0:25:61",
    55: "1:54:75",
    56: "0:45:00",
    57: "0:29:73",
    58: "1:46:36",
    59: "0:38:58",
    60: "1:00:09",
    61: "1:05:57",
    62: "1:08:71",
    63: "1:03:79",
    64: "1:32:22",
    65: "0:20:90",
    66: "0:41:08",
    67: "0:26:42",
    68: "0:31:59",
    69: "1:37:75",
    70: "1:10:54",
    71: "1:22:80",
    72: "0:35:47",
    73: "2:05:75",
    74: "2:28:20",
    75: "0:29:71",
    76: "0:23:57",
    77: "0:32:43",
    78: "0:28:60",
    79: "0:40:98",
    80: "0:59:91",
    81: "0:59:89",
    82: "0:22:09",
    83: "0:56:77",
    84: "0:35:84",
    85: "1:20:61",
    86: "0:27:32",
    87: "0:29:10",
    88: "0:45:17",
    89: "0:37:37"
}

RaceAuthorTimeText = {
    0: "0:16:17",
    1: "0:19:01",
    2: "0:18:76",
    3: "0:21:20",
    4: "0:25:11",
    5: "0:17:72",
    6: "0:20:70",
    7: "0:20:12",
    8: "0:22:68",
    9: "0:19:76",
    10: "0:15:39",
    11: "0:14:66",
    12: "0:19:97",
    13: "0:18:41",
    14: "0:17:58",
    15: "0:52:84",
    16: "0:21:00",
    17: "0:35:94",
    18: "0:16:67",
    19: "0:30:86",
    20: "0:23:87",
    21: "0:27:39",
    22: "0:29:17",
    23: "0:25:42",
    24: "0:46:55",
    25: "0:19:09",
    26: "0:16:22",
    27: "1:04:66",
    28: "0:19:14",
    29: "0:36:75",
    30: "1:36:79",
    31: "0:43:22",
    32: "1:14:59",
    33: "1:22:21",
    34: "0:42:57",
    35: "0:34:15",
    36: "0:41:75",
    37: "0:29:85",
    38: "0:38:15",
    39: "1:00:81",
    40: "0:22:30",
    41: "0:29:62",
    42: "0:54:59",
    43: "1:01:31",
    44: "0:46:27",
    45: "1:01:58",
    46: "0:54:95",
    47: "0:33:34",
    48: "0:43:30",
    49: "0:58:72",
    50: "0:24:90",
    51: "0:52:28",
    52: "0:25:85",
    53: "0:26:51",
    54: "0:22:70",
    55: "1:45:80",
    56: "0:39:88",
    57: "0:26:33",
    58: "1:35:16",
    59: "0:34:86",
    60: "0:57:43",
    61: "1:02:86",
    62: "1:04:93",
    63: "1:01:01",
    64: "1:30:85",
    65: "0:20:25",
    66: "0:36:28",
    67: "0:24:69",
    68: "0:29:72",
    69: "1:29:00",
    70: "1:03:39",
    71: "1:13:78",
    72: "0:32:77",
    73: "1:56:35",
    74: "2:23:69",
    75: "0:29:64",
    76: "0:21:27",
    77: "0:29:85",
    78: "0:25:73",
    79: "0:39:53",
    80: "0:55:90",
    81: "0:55:15",
    82: "0:19:82",
    83: "0:54:34",
    84: "0:34:98",
    85: "1:06:32",
    86: "0:24:47",
    87: "0:26:38",
    88: "0:42:30",
    89: "0:34:73"
}

PuzzleGoldTimeText = {
    0: "0:07:00",
    1: "0:07:00",
    2: "0:12:00",
    3: "0:14:50",
    4: "0:20:00",
    5: "0:22:00",
    6: "0:30:00",
    7: "0:40:00",
    8: "0:35:00",
    9: "0:40:00",
    10: "0:35:00",
    11: "0:32:00",
    12: "0:40:00",
    13: "0:35:00",
    14: "0:32:00"
}

PuzzleGoldTime = {
    0: 0700,
    1: 0700,
    2: 1200,
    3: 1450,
    4: 2000,
    5: 2200,
    6: 3000,
    7: 4000,
    8: 3500,
    9: 4000,
    10: 3500,
    11: 3200,
    12: 4000,
    13: 3500,
    14: 3200
}

function raceTitle(track, enviroment, difficulty) => Enviroments[enviroment] + Difficulty[difficulty] + (track + 1)
function platformTitle(track, difficulty) => "Platform" + Difficulty[difficulty] + (track + 1)
function puzzleTitle(track, difficulty) => "Puzzle" + Difficulty[difficulty] + (track + 1)
function raceEndTrigger(track, env, diff) => isInTrack(track, env, diff) && raceEnd() && !isRacePaused()

//Progression achievement functions
//  For protection measures (backing up another profile with everything unlocked)
function sameSaveFile() => getFileIndex() == prev(getFileIndex())

//  Track Unlock functions
function trackUnlockFile(mode, file, bronze, silver, gold){
    before = prev(dword(Medals[mode]["Bronze"][file])) < bronze || prev(dword(Medals[mode]["Silver"][file])) < silver || prev(dword(Medals[mode]["Gold"][file])) < gold
    now = dword(Medals[mode]["Bronze"][file]) >= bronze && dword(Medals[mode]["Silver"][file]) >= silver && dword(Medals[mode]["Gold"][file]) >= gold
    return before && now
}

function trackUnlockTrigger(mode, bronze, silver, gold){
    triggered = false
    for file in range(0,2){
        triggered = triggered || trackUnlockFile(mode, file, bronze, silver, gold) && getFileIndex() == file
    }
    
    return triggered && sameSaveFile()
}

//  Completionist functions
function modeCompletionFile(mode, file, medal, amount){
    return prev(dword(Medals[mode][medal][file])) == amount - 1 && measured(dword(Medals[mode][medal][file]) == amount, getFileIndex() == file, format="percent")
}

function modeCompletionTrigger(mode, medal, amount){
    triggered = false
    for file in range(0,2){
        triggered = triggered || modeCompletionFile(mode, file, medal, amount)
    }
    
    return triggered && sameSaveFile()
}

//  Shop functions
function prevBoughtItems(env, file){
    bought = env["Count"]
    for item in range(0, env["Count"] - 1){
       bought = bought - prev(byte(env["Address"][file] + item))
    }
    return bought
}

function boughtItems(env, file){
    bought = env["Count"]
    for item in range(0, env["Count"] - 1){
        bought = bought - byte(env["Address"][file] + item)
    }
    return bought
}

function boughtFunctionFile(item, file){
    totalCount = 0
    beforeCount = 0
    nowCount = 0
    for env in Shop[item]{
        totalCount = totalCount + Shop[item][env]["Count"]
        beforeCount = beforeCount + prevBoughtItems(Shop[item][env], file)
        nowCount = nowCount + boughtItems(Shop[item][env], file)
    }
    
    before = beforeCount == totalCount - 1
    now = nowCount == totalCount && getFileIndex() == file
    
    return before && now
}

function boughtFunction(item){
    triggered = false
    for file in range(0,2){
        triggered = triggered || boughtFunctionFile(item, file)
    }
    
    return triggered && sameSaveFile()
}

//Progression achievements
//  Race mode
achievement("Trackmania Rookie", "Unlock Easy Races", 5, trackUnlockTrigger("Race", 10, 5, 0))
achievement("Trackmania Amateur", "Unlock Medium Races", 5, trackUnlockTrigger("Race", 20, 10, 5))
achievement("Trackmania Veteran", "Unlock Hard Races", 5, trackUnlockTrigger("Race", 45, 35, 25))
achievement("Trackmania Expert", "Unlock Extreme Races", 5, trackUnlockTrigger("Race", 60, 50, 45))
achievement("Trackmania Master", "Unlock Bonus Races", 5, trackUnlockTrigger("Race", 0, 0, 75))
achievement("Trackmania Legend", "Get all Gold medals in race mode", 50, modeCompletionTrigger("Race", "Gold", 90))
achievement("Trackmania God", "Get all Author medals in race mode", 100, modeCompletionTrigger("Race", "Author", 90))

//  Platform mode
achievement("Trackmania Plat 1", "Unlock Easy Platforms", 5, trackUnlockTrigger("Platform", 2, 0, 0))
achievement("Trackmania Plat 2", "Unlock Medium Platforms", 5, trackUnlockTrigger("Platform", 4, 3, 1))
achievement("Trackmania Plat 3", "Unlock Hard Platforms", 5, trackUnlockTrigger("Platform", 9, 6, 3))
achievement("Trackmania Plat 4", "Unlock Extreme Platforms", 5, trackUnlockTrigger("Platform", 12, 10, 8))
achievement("Trackmania Plat all", "Get all Gold medals in Platform mode", 25, modeCompletionTrigger("Platform", "Gold", 15))

//  Puzzle mode
achievement("Trackmania Puz 1", "Unlock Easy Puzzles", 5, trackUnlockTrigger("Puzzle", 3, 0, 0))
achievement("Trackmania Puz 2", "Unlock Medium Puzzles", 5, trackUnlockTrigger("Puzzle", 6, 3, 0))
achievement("Trackmania Puz 3", "Unlock Hard Puzzles", 5, trackUnlockTrigger("Puzzle", 9, 6, 3))
achievement("Trackmania Puz 4", "Unlock Extreme Puzzles", 5, trackUnlockTrigger("Puzzle", 12, 9, 6))
achievement("Trackmania Puz All", "Get all Gold medals in Puzzle mode", 25, modeCompletionTrigger("Puzzle", "Gold", 15))

//  Shop
achievement("Skins", "Buy all skins in the shop", 5, boughtFunction("Skins"))
achievement("Blocks", "Buy all blocks in the shop", 5, boughtFunction("Blocks"))
achievement("Tracks", "Buy all tracks in the shop", 5, boughtFunction("Tracks"))


//Race achievement functions
function raceTitleGold(track, env, diff) => raceTitle(track, env, diff) + " Gold"
function raceTitleAuthor(track, env, diff) => raceTitle(track, env, diff) + " Author"
function raceDescriptionGold(track, env, diff) => "Finish " + raceTitle(track, env, diff) + " in less than " + RaceGoldTimeText[raceIndex(track, env, diff)]
function raceDescriptionAuthor(track, env, diff) => "Finish " + raceTitle(track, env, diff) + " in less than " + RaceAuthorTimeText[raceIndex(track, env, diff)]
function raceTimeLowerThanGold(track, env, diff) => getTimer() < time2RawData(RaceGoldTime[raceIndex(track, env, diff)])
function raceTimeLowerThanAuthor(track, env, diff) => getTimer() < time2RawData(RaceAuthorTime[raceIndex(track, env, diff)])
function raceGoldMedalTrigger(track, env, diff) => isOnRaceMode() && raceEndTrigger(track, env, diff) && raceTimeLowerThanGold(track, env, diff)
function raceAuthorMedalTrigger(track, env, diff) => isOnRaceMode() && raceEndTrigger(track, env, diff) && raceTimeLowerThanAuthor(track, env, diff)

//Race achievements
for d in range(0,5){
    for e in range(0,2){
        for t in range(0,4){
            //Gold medals
            achievement(raceTitleGold(t, e, d), raceDescriptionGold(t, e, d), 5, raceGoldMedalTrigger(t, e, d))
            
            //Author medal
            achievement(raceTitleAuthor(t, e, d), raceDescriptionAuthor(t, e, d), 5, raceAuthorMedalTrigger(t, e, d))
        }
    }
}


//Platform achievement functions
function platformTitleGold(track, diff) => platformTitle(track, diff) + " Gold"
function platformDescriptionGold(track, diff) => "Finish " + platformTitle(track, diff) + " with 0 retries"
function platformZeroRetries() => 0 == getRetries()
function platformGoldMedalTrigger(track, diff) => isOnPlatformMode() && raceEndTrigger(track, track, diff) && platformZeroRetries()

//Platform achievements
for d in range(0,4){
    for t in range(0,2){
        achievement(platformTitleGold(t, d), platformDescriptionGold(t, d), 5, platformGoldMedalTrigger(t, d))
    }
}

//Puzzle achievement functions
function puzzleTitleGold(track, diff) => puzzleTitle(track, diff) + " Gold"
function puzzleDescriptionGold(track, diff) => "Finish " + puzzleTitle(track, diff) + " in less than " + PuzzleGoldTimeText[puzzleIndex(track, diff)]
function puzzleTimeLowerThanGold(track, diff) => getTimer() < time2RawData(PuzzleGoldTime[puzzleIndex(track, diff)])
function puzzleGoldMedalTrigger(track, diff) => isOnPuzzleMode() && raceEndTrigger(track, track, diff) && puzzleTimeLowerThanGold(track, diff)

//Puzzle achievement functions
for d in range(0,4){
    for t in range(0,2){
        achievement(puzzleTitleGold(t, d), puzzleDescriptionGold(t, d), 5, puzzleGoldMedalTrigger(t, d))
    }
}


//Leaderboard generic functions
function cancelLB() => inMenu() || !isRaceStarted()
function submitLB() => raceEnd() && !isRacePaused()
function timerLB() => measured(rawData2Time(getTimer()))


//Race Leaderboard Functions
function raceTitleLB(track, enviroment, difficulty) => Enviroments[enviroment] + Difficulty[difficulty] + (track + 1)
function raceDescriptionLB(track, enviroment, difficulty) => "Beat " + raceTitleLB(track, enviroment, difficulty) + " in least time"
function raceStartLB(track, enviroment, difficulty) => isOnRaceMode() && raceStart() && isInTrack(track, enviroment, difficulty)

//Race Leaderboards
for d in range(0,5){
    for e in range(0,2){
        for t in range(0,4){
            leaderboard(raceTitleLB(t, e, d), raceDescriptionLB(t, e, d), raceStartLB(t, e, d), cancelLB(), submitLB(), timerLB(), format="MILLISECS", lower_is_better=true)
        }
    }
}


//Platform Leaderboard Functions
function platformDescriptionLB(track, difficulty) => "Beat " + platformTitle(track, difficulty)
function platformStartLB(track, difficulty) => isOnPlatformMode() && raceStart() && isInTrack(track, track, difficulty)

//Platform Retries Leaderboard Functions
function platformRetriesTitleLB(track, difficulty) => platformTitle(track, difficulty) + " Retries"
function platformRetriesDescriptionLB(track, difficulty) => platformDescriptionLB(track, difficulty) + " with least amount of retries"

//Platform Time Leaderboard Functions
function platformTimeTitleLB(track, difficulty) => platformTitle(track, difficulty) + " Time"
function platformTimeDescriptionLB(track, difficulty) => platformDescriptionLB(track, difficulty) + " in least time without retrying"
function platformTimeCancelLB() => cancelLB() || getRetries() > 0

//Platform Leaderboards
for d in range(0,4){
    for t in range(0,2){
        //Retries Leaderboard
        leaderboard(platformRetriesTitleLB(t, d), platformRetriesDescriptionLB(t, d), platformStartLB(t, d), cancelLB(), submitLB(), getRetries(), lower_is_better=true)
        
        //Time Leaderboard
        leaderboard(platformTimeTitleLB(t, d), platformTimeDescriptionLB(t, d), platformStartLB(t, d), platformTimeCancelLB(), submitLB(), timerLB(), format="MILLISECS", lower_is_better=true)
    }
}


//Puzzle Leaderboard Functions
function puzzleTitleLB(track, difficulty) => "Puzzle" + Difficulty[difficulty] + (track + 1)
function puzzleDescriptionLB(track, difficulty) => "Beat " + puzzleTitleLB(track, difficulty) + " in least time"
function puzzleStartLB(track, difficulty) => isOnPuzzleMode() && raceStart() && isInTrack(track, track, difficulty)

//Puzzle Leaderboards
for d in range(0,4){
    for t in range(0,2){
        leaderboard(puzzleTitleLB(t, d), puzzleDescriptionLB(t, d), puzzleStartLB(t, d), cancelLB(), submitLB(), timerLB(), format="MILLISECS", lower_is_better=true)
    }
}










