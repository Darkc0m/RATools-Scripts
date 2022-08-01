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

//  Gets current ingame timer with a value of 0x1 = 1 centisec
function getTimer() => rawData2Time(dword(tbyte(0x12E560) + 0x000150))

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

//  Returns true if on race gamemode
function isOnRaceMode() => dword(0x1A4CB4) == 0 || dword(0x1A4CB4) == 3

//  Returns true if on platform gamemode
function isOnPlatformMode() => dword(0x1A4CB4) == 1

//  Returns true if on puzzle gamemode
function isOnPuzzleMode() => dword(0x1A4CB4) == 2

//  Gets race index with provided params
function raceTrackIndex(track, enviroment, difficulty) => track + enviroment * 5 + difficulty * 15

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

//Race track achievements functions


//Race track achievements
//achievement(title, description, points, trigger)


//Leaderboard generic functions
function cancelLB() => inMenu() || !isRaceStarted()
function submitLB() => raceEnd() && !isRacePaused()
function timerLB() => measured(getTimer())


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
function platformTitleLB(track, difficulty) => "Platform" + Difficulty[difficulty] + (track + 1)
function platformDescriptionLB(track, difficulty) => "Beat " + platformTitleLB(track, difficulty)
function platformStartLB(track, difficulty) => isOnPlatformMode() && raceStart() && isInTrack(track, track, difficulty)
function retriesLB() => dword(tbyte(0x12E538) + 0x24B0)

//Platform Retries Leaderboard Functions
function platformRetriesTitleLB(track, difficulty) => platformTitleLB(track, difficulty) + " Retries"
function platformRetriesDescriptionLB(track, difficulty) => platformDescriptionLB(track, difficulty) + " with least amount of retries"

//Platform Time Leaderboard Functions
function platformTimeTitleLB(track, difficulty) => platformTitleLB(track, difficulty) + " Time"
function platformTimeDescriptionLB(track, difficulty) => platformDescriptionLB(track, difficulty) + " in least time without retrying"
function platformTimeCancelLB() => cancelLB() || retriesLB() > 0

//Platform Leaderboards
for d in range(0,4){
    for t in range(0,2){
        //Retries Leaderboard
        leaderboard(platformRetriesTitleLB(t, d), platformRetriesDescriptionLB(t, d), platformStartLB(t, d), cancelLB(), submitLB(), retriesLB(), lower_is_better=true)
        
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










