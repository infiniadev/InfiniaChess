{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLConst;

interface

uses Classes;

type
  TOfferType = (otMatch, otResume, otSeek);

  TUserRights = record
    SelfProfile: Boolean; // rights to edit photo and notes of himself
    AchievementsVisible: Boolean;
    Messages: Boolean;
    PGNLibrary: Boolean;
    AchievementsActive: Boolean;
    SavingGames: Boolean;
  end;


const
{ RatedTypes }
RATED_TYPES: array[0..5] of string = ('Standard', 'Blitz', 'Bullet', 'Crazy House', 'Fischer Random', 'Losers');

{ Make sure that these arrays are in alignment with the TGameResult type
   found in CLServer.CLConst }
RESULTCODES: array [0..13] of string =
  ('-', '*', '*', '1/2-1/2', '0-1', '1-0', '0-1', '1-0',
  '1/2-1/2', '1/2-1/2', '0-1', '1-0', '0-1', '1-0');

{ General }
DAT_VERSION = 6;
CLIENT_VERSION = '1.5.1';
CHESSLINK_WEB = 'http://www.perpetualchess.com';

//CHESSLINK_PORT = 1025;
//CHESSLINK_SERVER = '127.0.0.1';
//CHESSLINK_SERVER = '67.192.255.154';
CHESSLINK_SERVER = '65.60.190.184';    //New
CHESSLINK_PORT = 15125;
CHESSLINK_PORT_MM = 1025;

{ Time }
MSecs = 1000;
MSecsPerMinute = 60000;
SecsPerDay = 86400;

{ Notify State Constants }
NOTIFY_OFFLINE = 0;
NOTIFY_ONLINE = 1;

{ fCLMain }
QRY_LOGOFF = 'Logoff from the server?';
QRY_SEND_RESUME_REQUEST = 'Send resume request to %s?';

{ Sounds }
SI_SIGNEDIN = 0;
SI_DISCONNECT = 1;
SI_CHALLENGE = 2;
SI_GAMESTART = 3;
SI_CHECK = 4;
SI_OFFER = 5;
SI_ILLEGAL = 6;
SI_LEGAL = 7;
SI_GAMERESULT = 8;
SI_TELL = 9;
SI_MESSAGE = 10;
SI_INVITE = 11;
SI_ARRIVED = 12;
SI_LEFT = 13;
SI_PLAYER_ARRIVED = 14;

{ Cursors }
crIEHand = 1;

{ These are the commands the server supports (sorted alphabitcally) }
CMD_STR_ABORT = '/abort'; { Uses Primary }
CMD_STR_ACCEPT = '/accept';
CMD_STR_ACK_FLAG = #16; { Intended to be sent by client in response to DP_FLAG }
CMD_STR_ACK_PING = #6;
CMD_STR_ADJOURN = '/adjourn';
CMD_STR_ARROW = '/arrow';
CMD_STR_BACK = '/back'; { Uses Primary }
CMD_STR_BYE = '/bye';
CMD_STR_CENSOR_ADD = '/+censor';
CMD_STR_CENSOR_REMOVE = '/-censor';
CMD_STR_CIRCLE = '/circle';
CMD_STR_CLEAR_MARKERS = '/clearmarkers'; { Uses Primary }
CMD_STR_CREATE_ROOM = '/createroom';
CMD_STR_DECLINE = '/decline';
CMD_STR_DELETE_MESSAGE = '/deletemessage';
CMD_STR_DEMOBOARD = '/demoboard';
CMD_STR_DISABLE = '/disable';
CMD_STR_DRAW = '/draw'; { Uses Primary }
CMD_STR_ENTER = '/enter';
CMD_STR_EXIT = '/exit';
CMD_STR_FEN = '/fen'; { Uses Primary }
CMD_STR_FLAG = '/flag'; { Uses Primary }
CMD_STR_FORWARD = '/forward'; { Uses Primary }
CMD_STR_INCLUDE = '/include'; { Uses Primary }
CMD_STR_INVITE ='/invite';
CMD_STR_KIBITZ = '/kibitz'; { Uses Primary }
CMD_STR_LIBRARY_ADD = '/+library';
CMD_STR_LIBRARY_REMOVE = '/-library';
CMD_STR_LOAD = '/load';
CMD_STR_LOCK = '/lock'; { Uses Primary }
CMD_STR_LOGIN = '/login';
CMD_STR_MATCH = '/match';
CMD_STR_MESSAGE = '/message';
CMD_STR_MORETIME = '/moretime'; { Uses Primary }
CMD_STR_MOVE = '/move';
CMD_STR_NOTIFY_ADD = '/+notify';
CMD_STR_NOTIFY_REMOVE = '/-notify';
CMD_STR_NUKE = '/nuke';
CMD_STR_OBSERVE = '/observe';
CMD_STR_PING = '/ping';
CMD_STR_PRIMARY = '/primary';
CMD_STR_PROFILE = '/profile';
CMD_STR_QUIT = '/quit'; { Uses Primary }
CMD_STR_REGISTER = '/register';
CMD_STR_RESIGN = '/resign'; { Uses Primary }
CMD_STR_RESUME = '/resume';
CMD_STR_REVERT = '/revert'; { Uses Primary }
CMD_STR_SAY = '/say';
CMD_STR_SEEK = '/seek';
CMD_STR_SET = '/set';
CMD_STR_SET_ALL = '/setall';
CMD_STR_SHOUT = '/shout';
CMD_STR_TAKEBACK = '/takeback'; { Uses Primary }
CMD_STR_TELL = '/tell';
CMD_STR_UNARROW = '/unarrow';
CMD_STR_UNCIRCLE = '/uncircle';
CMD_STR_UNLOCK = '/unlock'; { Uses Primary }
CMD_STR_UNOFFER = '/unoffer';
CMD_STR_VARS = '/vars';
CMD_STR_WHISPER = '/whisper'; { Uses Primary }
CMD_STR_ZERO_TIME = #15;
CMD_STR_FOLLOW = '/follow';
CMD_STR_UNFOLLOW = '/unfollow';
CMD_STR_EVENT_CREATE = '/event_create';
CMD_STR_EVENT_JOIN = '/event_join';
CMD_STR_EVENT_START = '/event_start';
CMD_STR_EVENT_TELL = '/event_tell';
CMD_STR_EVENT_LEAVE = '/event_leave';
CMD_STR_EVENT_OBSERVE = '/event_observe';
CMD_STR_EVENT_DELETE = '/event_delete';
CMD_STR_ODDS_ADD = '/odds_add';
CMD_STR_ODDS_CLEAR = '/odds_clear';
CMD_STR_EVENT_PARAMS = '/event_params';
CMD_STR_EVENT_PAUSE = '/event_pause';
CMD_STR_EVENT_RESUME = '/event_resume';
CMD_STR_EVENT_SHOUT = '/event_shout';
CMD_STR_EVENT_MEMBER = '/event_member';
CMD_STR_EVENT_ABANDON = '/event_abandon';
CMD_STR_EVENT_FORFEIT = '/event_forfeit';
CMD_STR_EVENT_GAME_ACCEPT = '/event_game_accept';
CMD_STR_EVENT_GAME_ABORT = '/event_game_abort';
CMD_STR_EVENT_CREATE_END = '/event_create_end';
CMD_STR_EVENT_CONG = '/event_cong';
CMD_STR_AUTH_KEY = '/auth_key';
CMD_STR_EMAIL_CHANGE = '/email_change';
CMD_STR_AUTH_KEY_REQ = '/auth_key_req';
CMD_STR_KEY_CONFIRM = '/key_confirm';
CMD_STR_PASS_FORGOT = '/pass_forgot';
CMD_STR_PHOTO_SEND = '/photo_send';
CMD_STR_CHATLOG = '/chatlog';
CMD_STR_CHANGE_PASSWORD = '/changepassword';
CMD_STR_ADULT = '/adult';
CMD_STR_STAT = '/stat';
CMD_STR_GOTOCLUB = '/gotoclub';
CMD_STR_GETCLUBMEMBERS = '/getclubmembers';
CMD_STR_CLUBSTATUS = '/clubstatus';
CMD_STR_CLUBOPTIONS = '/cluboptions';
CMD_STR_CLUBINFO = '/clubinfo';
CMD_STR_CLUBPHOTO = '/clubphoto';
CMD_STR_GAMESEARCH = '/gamesearch';
CMD_STR_EVENT_TICKETS_BEGIN = '/event_tickets_begin';
CMD_STR_EVENT_TICKET = '/event_ticket';
CMD_STR_EVENT_TICKETS_END = '/event_tickets_end';
CMD_STR_EVENT_GAME_OBSERVE = '/event_game_observe';
CMD_STR_SCORE = '/score';
CMD_STR_DELETEROOM = '/deleteroom';
CMD_STR_DELETEPROFILEPHOTO = '/deleteprofilephoto';
CMD_STR_SETPROFILENOTES = '/setprofilenotes';
CMD_STR_NOTES = '/notes';
CMD_STR_MESSAGESEARCH = '/messagesearch';
CMD_STR_MESSAGE_STATE = '/messagestate';
CMD_STR_MESSAGE_RETRIEVE = '/messageretrieve';
CMD_STR_CLIENTERROR = '/clienterror';
CMD_STR_ADMINGREETINGS = '/admingreetings';
CMD_STR_MESSAGEGROUP = '/messagegroup';
CMD_STR_MUTE = '/mute';
CMD_STR_BAN = '/ban';
CMD_STR_UNMUTE = '/unmute';
CMD_STR_LECTURE_CREATE = '/lecture_create';
CMD_STR_CLUB = '/club';
CMD_STR_CLUB_REMOVE = '/-club';
CMD_STR_EVENT_FINISH = '/event_finish';
CMD_STR_BANHISTORY = '/banhistory';
CMD_STR_PROFILE_ACH = '/profile_ach';
CMD_STR_TRANSACTION_STATE = '/transaction_state';
CMD_STR_TRANSACTION = '/transaction';
CMD_STR_PM_EXIT = '/pm_exit';
CMD_STR_REQUEST_USER_INFO = '/request_user_info';
CMD_STR_SKIP_UPDATE = '/skip_update';

CMM_INITIALIZE = 'cmm001';
CMM_PHOTO = 'cmm002';
CMM_GET_ALL_PHOTO = 'cmm003';

DPM_INITIALIZED = 1;
DPM_PHOTO = 2;

{ CLServer DP Delimiteres }
DP_START = #20;
DP_DELIMITER = #21;
DP_END = #22;

{ CLServer DP Definitions. Ensure that these match the CSConst.pas
  file for the Chesslink Server project. }

{ DP_SERVER_MESSAGE: DP#, ErrorLevel, Message }
DP_SERVER_MSG = 0;
{ DP_PING: DP# }
DP_PING = 6;
{ DP_COMMAND_COMPLETE: DP#, CMD# }
DP_COMMAND_COMPLETE = 10;

{ DP_DIALOG: DP#, Title, Message, Buttons, Flags }
DP_DIALOG = 20;

{ DP_CONNECTION_REFUSED: DP# }
DP_CONNECTION_REFUSED = 100;
{ DP_BYE: DP# }
DP_BYE = 101;
{ DP_CONNECTED: DP# }
DP_CONNECTED = 102;
{ DP_LOGIN: DP#, Login, Title }
DP_LOGIN = 103;
{ DP_LOGIN_ERROR: DP#, ErrorNumber, ErrorDescription }
DP_LOGIN_RESULT = 104;
DP_CODE_LOGIN_SUCCESS = 0;
DP_CODE_LOGIN_LOGGEDIN = -1;
DP_CODE_LOGIN_INVALID = -2;
DP_CODE_LOGIN_DISABLED = -3;
DP_CODE_LOGIN_BADCLIENT = -4;
DP_CODE_LOGIN_BANNEDCLIENT = -5;
DP_CODE_LOGIN_CLIENT_LOGGEDIN = -6;
DP_CODE_LOGIN_UNBANNEDCLIENT = -7;
DP_CODE_LOGIN_AUTH_KEY = -8;
DP_CODE_LOGIN_DBERROR = -10;
{ DP_REGISTER: DP# ResultCode, ResultMSG, Login, Password }
DP_REGISTER = 105;
{ These codes match the proc_Register procedure in the CLServer DB. }
DP_CODE_REGISTER_SUCCESS = 0;
DP_CODE_REGISTER_BAD_LOGIN = -1;
DP_CODE_REGISTER_BAS_PASSWORD = -2;
DP_CODE_REGISTER_LOGIN_TAKEN = -3;
DP_CODE_REGISTER_INAPPROPRIATE = -4;
DP_CODE_REGISTER_CLIENT_BANNED = -5;
DP_CODE_REGISTER_BAD_CLIENT = -6;
DP_CODE_REGISTER_LOGGEDIN = -7;
DP_CODE_REGISTER_BAD_PARM = -8;

{ DP_LOGOFF: DP#, LoginID, Login, Title }
DP_LOGOFF = 110;
{ DP_LOGIN_STATE: DP#, LoginID, Login, Title }
DP_LOGIN_STATE = 111;
{ DP_LOGIN_BEGIN: DP# }
DP_LOGIN_BEGIN = 112;
{ DP_LOGIN2: DP#, LoginID, Login, Title }
DP_LOGIN2 = 113;
{ DP_LOGIN_END: DP#}
DP_LOGIN_END = 114;
DP_LOGIN_INFO = 115;

{ DP_SETTINGS: DP# Autoflag, Open, RemoveOffers, InitialTime, IncTime, Color,
  Rated, RatedType, MaxRating, MinRating }
DP_SETTINGS = 200;
{ DP_OPTION: DP# OptionSet }
DP_OPTION = 205;

{ DP_NOTIFY_REMOVE: DP#, LoginID, Login, Title, NotifyType }
DP_NOTIFY_REMOVE = 301;
{ DP_NOTIFY: DP#, LoginID, Login, Title, State }
DP_NOTIFY = 302;
{ DP_NOTIFY_BEGIN: DP# }
DP_NOTIFY_BEGIN = 304;
{ DP_NOTIFY_END: DP# }
DP_NOTIFY_END = 305;

{ DP_MESSAGE: DP#, MessageID, Sender, Title, Date, Subject, Body }
DP_MESSAGE = 401;
{ DP_MESSAGE_DELETE: DP#, MessageID }
DP_MESSAGE_DELETE = 402;
{ DP_KIBITZ: DP#, GameNumber, From, Title, Message }
DP_KIBITZ = 403;
{ DP_SAY: DP#, GameNumber, From, Title, Message }
DP_SAY = 404;
{ DP_SHOUT: DP#, From, Title, Message }
DP_SHOUT = 405;
{DP_TELL_LOGIN: DP#, (from)LoginID, (from)Login, (from) Title,
(reciprocate)LoginID, (reciprocate)Login, (reciprocate)Title, Message }
DP_TELL_LOGIN = 406;
{ DP_TELL_ROOM: DP#, RoomNumber, From, Title, Message }
DP_TELL_ROOM = 407;
{ DP_WHISPER: DP#, GameNumber, From, Title, Message }
DP_WHISPER = 408;

{ DP_ROOM_DEF: DP#, RoomNumber, Description, Creator, Limit, Count }
DP_ROOM_DEF = 500;
{ DP_ROOM_DESTROYED: DP#, RoomNumber }
DP_ROOM_DESTROYED = 501;
{ DP_ROOM_I_ENTER: DP#, RoomNumber, Description }
DP_ROOM_I_ENTER = 503;
{ DP_ROOM_I_EXIT: DP#, RoomNumber, Description }
DP_ROOM_I_EXIT = 504;
{ DP_ROOM_DEF_BEGIN: DP# }
DP_ROOM_DEF_BEGIN = 505;
{ DP_ROOM_DEF_END: DP# }
DP_ROOM_DEF_END = 506;
{DP_ROOM_EXIT: DP#, RoomNumber, LoginID, Login, Title }
DP_ROOM_EXIT = 507;
{DP_ROOM_ENTER: DP#, RoomNumber, LoginID, Login, Title }
DP_ROOM_ENTER = 508;
{ DP_ROOM_BEGIN: DP#, RoomNumber }
DP_ROOM_SET_BEGIN = 509;
{ DP_ROOM_END: DP#, RoomNumber }
DP_ROOM_SET_END = 510;

DP_RATING2 = 610;

{ DP_MATCH: DP#, OfferNumber, Color, InitialTime, IncTime, Issuer, Title
  Provisional, Rated, Rating, RatedType }
DP_MATCH = 700;
{ DP_SEEK: DP#, OfferNumber, Color, InitialTime, IncTime, Issuer, Title,
  Provisional, Rated, Rating, RatedType }
DP_SEEK = 701;
{ DP_UNOFFER: DP#, Offer }
DP_UNOFFER = 702;

{ DP_PROFILE_GAME: DP#, LoginID, Login, Title, ProfileGameType, GameNumber/ID,
  WhiteName, WhiteTitle, WhiteRating, WhiteMSec,
  BlackName, BlackTitle, BlackRating, BlackMSec,
  RatedType, InitialMSec, IncMSec, Rated, GameResult, ECO, Date, LoggedIn }
DP_PROFILE_GAME = 808;
DP_PROFILE_GAMETYPE_RECENT = 0;
DP_PROFILE_GAMETYPE_LIBRARY = 1;
DP_PROFILE_GAMETYPE_ADJOURNED = 2;
DP_PROFILE_GAMETYPE_CURRENT = 3;
{ DP_PROFILE_NOTES: DP#, LoginID, LoginHandle, Title, Note }
DP_PROFILE_NOTE = 810;
{ DP_PROFILE_PING: DP#, LoginID, Login, Title, AvgPingMSec, PingCount, IdleMSec }
DP_PROFILE_PING = 812;
{ DP_PROFILE_RATING: DP#, LoginID, Login, Title, RatedType, Rating, Provisional,
  RatedWins, RatedLoses, RatedDraws, UnratedWins, UnratedLoses, UnratedDraws,
  EP, Best, Date, RatedName, RatedName }
DP_PROFILE_RATING = 813;
{ DP_PROFILE_BEGIN: DP#, LoginID, Login, Title }
DP_PROFILE_BEGIN = 820;
{ DP_PROFILE_BEGIN: DP#, LoginID, Login, Title }
DP_PROFILE_END = 821;

{ DP_GAME_MSG: DP#, GameNumber, ErrorLevel, Message }
DP_GAME_MSG = 900;
{ DP_SHOW_GAME: DP#, GameNumber }
DP_SHOW_GAME = 901;
{ DP_GAME_BORN: DP#, GameNumber, Site, Event, Round, Date,
  WhiteName, WhiteTitle, WhiteRating,
  BlackName, BlackTitle, BlackRating,
  InitialMSec, IncMSec, GameMode (0=gmLive, 1=gmExamine),
  PlayerInGame (0=no 1=yes), RatedType, Rated, Locked }
DP_GAME_BORN = 902;
{ DP_FEN: DP#, GameNumber, FEN }
DP_FEN = 903;
{ DP_GAME_RESULT: DP#, GameNumber, ResultCode }
DP_GAME_RESULT = 904;
DP_CODE_NO_RESULT = 0;
DP_CODE_ABORTED = 1;
DP_CODE_ADJOURNED = 2;
DP_CODE_DRAW = 3;
DP_CODE_WHITE_RESIGNS = 4;
DP_CODE_BLACK_RESIGNS = 5;
DP_CODE_WHITE_CHECKMATED = 6;
DP_CODE_BLACK_CHECKMATED = 7;
DP_CODE_WHITE_STALEMATED = 8;
DP_CODE_BLACK_STALEMATED = 9;
DP_CODE_WHITE_FORFEITS_TIME = 10;
DP_CODE_BLACK_FORFEITS_TIME = 11;
DP_CODE_WHITE_FORFEITS_NETWORK = 12;
DP_CODE_BLACK_FORFEITS_NETWORK = 13;
DP_MSG_NO_RESULT = 'No result';
DP_MSG_ABORTED = 'Game aborted';
DP_MSG_ADJOURNED = 'Game adjourned';
DP_MSG_DRAW = 'Game drawn';
DP_MSG_WHITE_RESIGNS = 'White resigns';
DP_MSG_BLACK_RESIGNS = 'Black resigns';
DP_MSG_WHITE_CHECKMATED = 'White checkmated';
DP_MSG_BLACK_CHECKMATED = 'Black checkmated';
DP_MSG_WHITE_STALEMATED = 'White stalemated';
DP_MSG_BLACK_STALEMATED = 'Black stalemated';
DP_MSG_WHITE_FORFEITS_TIME = 'White forfeits on time';
DP_MSG_BLACK_FORFEITS_TIME = 'Black forfeits on time';
DP_MSG_WHITE_FORFEITS_NETWORK = 'White forfeits on disconnect / excessive lag';
DP_MSG_BLACK_FORFEITS_NETWORK = 'Black forfeits on disconnect / excessive lag';
{ Result Message array. }
RESULTMSGS: array[0..13] of string =
  (DP_MSG_NO_RESULT, DP_MSG_ABORTED, DP_MSG_ADJOURNED, DP_MSG_DRAW,
  DP_MSG_WHITE_RESIGNS, DP_MSG_BLACK_RESIGNS,
  DP_MSG_WHITE_CHECKMATED, DP_MSG_BLACK_CHECKMATED,
  DP_MSG_WHITE_STALEMATED, DP_MSG_BLACK_STALEMATED,
  DP_MSG_WHITE_FORFEITS_TIME, DP_MSG_BLACK_FORFEITS_TIME,
  DP_MSG_WHITE_FORFEITS_NETWORK, DP_MSG_BLACK_FORFEITS_NETWORK);

{ DP_GAME_PERISH: DP#, GameNumber }
DP_GAME_PERISH = 905;
{ DP_MOVE_LIST_BEGIN: DP#, GameNumber, NumberOfMovesToFollow }
DP_MOVE_BEGIN = 906;
{ DP_MOVE: DP#, GameNumber, FromSqr, ToSqr, Param, PGN }
DP_MOVE = 907;
{ DP_MOVE_LIST_END: DP#, GameNumber }
DP_MOVE_END = 908;
{ DP_ILLEGAL_MOVE: DP#, GameNumber, ReasonMessage }
DP_ILLEGAL_MOVE = 909;
DP_MSG_NOT_YOUR_MOVE = 'It is not your move';
DP_MSG_ILLEGAL_MOVE = 'Illegal move';
{ DP_MSEC: DP#, GameNumber, WhiteMSec, BlackMSec }
DP_MSEC = 910;
{ DP_FLAG: DP#, GameNumber }
DP_FLAG = 911;
{ DP_DRAW: DP#, GameNumber, PlayerRequestingDraw, Title }
DP_DRAW = 912;
{ DP_ABORT_OFFER: DP#, GameNumber, PlayerRequestingAbort, Title }
DP_ABORT = 913;
{ DP_ADJOURN: DP#, GameNumber, PlayerRequestingAdjourn, Title }
DP_ADJOURN = 914;
{ DP_ARROW: DP# GameNumber, FromSqr, ToSqr }
DP_ARROW = 915;
{ DP_UNARROW: DP# GameNumber, FromSqr, ToSqr }
DP_UNARROW = 916;
{ DP_CIRCLE: DP# GameNumber, Sqr }
DP_CIRCLE = 917;
{ DP_UNCIRCLE: DP# GameNumber, Sqr }
DP_UNCIRCLE = 918;
{ DP_CLEAR_MARKERS: DP# GameNumber, FromSqr, ToSqr }
DP_CLEAR_MARKERS = 919;
{ DP_TAKEBACK_REQUEST: DP#, GameNumber TakebackCount PlayerRequestingTakeback, Title }
DP_TAKEBACK_REQUEST = 920;
{ DP_TAKEBACK: DP# GameNumber TakebackCount }
DP_TAKEBACK = 921;
{ DP_PRIMARY: DP# GameNumber }
DP_PRIMARY = 922;

{ DP_LIBRARY_ADD: DP#, GameID }
DP_LIBRARY_ADD = 926;
{ DP_LIBRARY_REMOVE: DP#, GameID }
DP_LIBRARY_REMOVE = 927;

{ DP_GAME_PERISH2: DP#, GameNumber }
DP_GAME_PERISH2 = 929;
{ DP_GAME_BEGIN: DP#  }
DP_GAME_BEGIN = 930;
{ DP_GAME: DP#, GameNumber/ID,
  WhiteName, WhiteTitle, WhiteRating,
  BlackName, BlackTitle, BlackRating,
  RatedType, InitialMSec, IncMSec, Rated, ResultCode }
DP_GAME = 931;
{ DP_GAMES_END: DP# }
DP_GAME_END = 932;
{ DP_GAME_LOCK: DP#, GameNumber/ID, Locked (1=yes, 0=no)}
DP_GAME_LOCK = 933;

{ DP_UNOBSERVER: DP#, GameNumber, LoginID, Login, Title }
DP_UNOBSERVER = 934;
{ DP_OBSERVER: DP#, GameNumber, LoginID, Login, Title }
DP_OBSERVER = 935;
{ DP_OBSERVER_BEGIN: DP#, GameNumber }
DP_OBSERVER_BEGIN = 936;
{ DP_OBSERVER_END: DP#, GameNumber }
DP_OBSERVER_END = 937;

{ DP_MORETIME_REQUEST: DP# GameNumber, Secs, PlayerRequestingMoreTime, Title}
DP_MORETIME_REQUEST = 950;

{ DP_INCLUDED: DP#, GameNumber, Color }
DP_INCLUDED = 955;

DP_FOLLOW_START = 960;
DP_FOLLOW_END = 970;

DP_EVENT_CREATED = 971;
DP_EVENT_JOINED = 972;
DP_EVENT_STARTED = 973;
DP_EVENT_TELL = 974;
DP_EVENT_LEADER_LOCATION = 975;
DP_EVENT_FINISHED = 976;
DP_EVENT_DELETED = 977;
DP_ODDS_ADD = 978;
DP_EVENT_STATISTIC = 979;
DP_EVENT_ODDS_ADD = 980;
DP_EVENT_KING = 981;
DP_EVENT_QUEUE_TAIL = 982;
DP_EVENT_LEFT = 983;
DP_EVENT_MEMBER = 984;
DP_EVENT_ABANDON = 985;
DP_EVENT_QUEUE_CLEAR = 986;
DP_EVENT_QUEUE_ADD = 987;
DP_EVENT_MEMBERS_START = 988;
DP_EVENT_MEMBERS_END = 989;
DP_EVENT_REGLGAMES_START = 990;
DP_EVENT_REGLGAME_ADD = 991;
DP_EVENT_REGLGAMES_END = 992;
DP_EVENT_REGLGAME_UPDATE = 993;
DP_EVENT_REGLAMENT = 994;
DP_EVENT_ACCEPT_REQUEST = 995;

DP_AUTH_KEY_RESULT = 996;
DP_AUTH_KEY_REQ_RESULT = 997;
DP_PASS_FORGOT_RES = 998;
DP_PHOTO = 999;
DP_PROFILE_DATA = 1000;
DP_BEGINNING_STAT = 1001;
DP_CHATLOG_START = 1002;
DP_CHATLOG = 1003;
DP_CHATLOG_END = 1004;
DP_CHATLOG_PAGE = 1005;
DP_MM_INVITE = 1006;
DP_PING_VALUE = 1007;
DP_ADULT = 1008;

DP_STATTYPE_BEGIN = 1009;
DP_STATTYPE = 1010;
DP_STATTYPE_END = 1011;

DP_STAT_BEGIN = 1012;
DP_STAT = 1013;
DP_STAT_END = 1014;

DP_EVENT_GAMES_BEGIN = 1015;
DP_EVENT_GAMES_END = 1016;

DP_CLUB_BEGIN = 1017;
DP_CLUB = 1018;
DP_CLUB_END = 1019;

DP_SEEKS_CLEAR = 1020;
DP_EVENTS_CLEAR = 1021;

DP_CLUB_MEMBERS_BEGIN = 1022;
DP_CLUB_MEMBER = 1023;
DP_CLUB_MEMBERS_END = 1024;

DP_CLUB_CHANGED = 1025;
DP_CLUB_STATUS = 1026;
DP_CLUB_INFO = 1027;
DP_CLUB_PHOTO = 1028;
DP_CLUB_OPTIONS = 1029;

DP_USER_PING_VALUE = 1030;
DP_PROFILE_PAGES = 1031;
DP_PROFILE_RECENT_CLEAR = 1032;

DP_EVENT_TICKETS_BEGIN = 1033;
DP_EVENT_TICKET = 1034;
DP_EVENT_TICKETS_END = 1035;

DP_GAME_SCORE = 1036;
DP_PROFILE_CHATREADER = 1037;
DP_NOTES = 1038;
DP_RIGHTS = 1039;
DP_SERVER_TIME = 1040;
DP_MESSAGE2 = 1041;
DP_MESSAGE_PAGES = 1042;
DP_MESSAGE_CLEAR = 1043;
DP_IMAGE = 1044;
// access levels
DP_AL_START = 1045;
DP_AL_LEVEL = 1046;
DP_AL_TYPE = 1047;
DP_AL_LINK = 1048;
DP_AL_FINISH = 1049;

DP_NEWUSER_GREATED = 1050;
DP_TIMEODDSLIMIT_CLEAR = 1051;
DP_TIMEODDSLIMIT = 1052;
DP_GAME_ODDS = 1053;
DP_CLIENT_UPDATE = 1054;

DP_ACH_CLEAR = 1055;
DP_ACH_GROUP = 1056;
DP_ACHIEVEMENT = 1057;
DP_ACH_USER = 1058;
DP_ACH_USER_INFO = 1059;
DP_ACH_USER_INFO_CLEAR = 1060;
DP_ACH_FINISHED = 1061;
DP_ACH_SEND_END = 1062;

DP_SERVER_WARNING = 1063;

DP_MEMBERSHIPTYPE_BEGIN = 1064;
DP_MEMBERSHIPTYPE = 1065;

DP_PROFILE_PAYMENT_BEGIN = 1066;
DP_PROFILE_PAYMENT = 1067;
DP_PROFILE_PAYMENT_END = 1068;

DP_URL_OPEN = 1069;
DP_ROLES = 1070;
DP_PROFILE_PAY_DATA = 1071;
DP_SPECIAL_OFFER = 1072;
DP_ONLINE_STATUS = 1073;
DP_PM_EXIT = 1074;
DP_AUTOUPDATE = 1075;
DP_GAME_QUIT = 1076;

SW_TRIAL_MEMBERSHIP = '0';
SW_END_MEMBERSHIP = '1';


{DP_BAN = 980;
DP_UNBAN = 981;}

LOAD_DIR = 'load\'; // folder for autoupdate

PIECE_BASIC_SIZE = 90;

DEFAULT_LOG_NAME = 'perpetualchess.log';
LOGGING = FALSE;

MOVE_STYLE_DD = 0;
MOVE_STYLE_CC = 1;

PREMOVE_SQUARE = 0;
PREMOVE_ARROW = 1;
PREMOVE_BOTH = 2;

PREMOVE_MAX_COUNT = 4;

DEBUGGING = false;
//NO_IO = true;

DefFramesColor = $C8C8C8; //$9ED7E0;// $E0D79E;
DefEventColor = $C8C8C8; //$9ED7E0;// $E0D79E;
DefNotifyColor = $C8C8C8; //$AEAEF7; //$FFDFDF;
DefDefaultBackgroundColor = $C8C8C8; //$8DADD8; //$D8AD8D;
DefBoardBackgroundColor = $C8C8C8; //$B3D9FF; //$FF8D9D;
DefSeekBulletColor = $8080FF; //$FF8080;
DefSeekBlitzColor = $80FFFF; //$FFFF80;
DefSeekStandardColor = $80FF80; //$80FF80;
DefSeekLoosersColor = $8000FF; //$FF0080;
DefSeekFisherColor = $FFFF00; //$00FFFF;
DefSeekCrazyColor = $FF8080; //$8080FF;
DefSeekTitleCColor = $8000FF; //$FF0080;
DefSimulCurrentGameColor = $30C030;
DefSimulLeaderGameColor = $FF2000;

{== warm colors ==
clFrames = 9ED7E0
clNotify = AEAEF7
clDefaultBackground = 8DADD8
clBoardBackground = B3D9FF
clEvent = 9ED7E0
clBullet = 8080FF
clBlitz = 80FFFF
clStandard = 80FF80
clLoosers = 8000FF
clFisher = FFFF00
clCrazy = FF8080
clTitleC = 8000FF
clSimulCurrentGame = 30C030
clSimulLeaderGame = FF2000}

PIECES_TRANSPARENT_COLOR = $FFFFFF;

FILTER_CHILD_STARTNUM = 10000;

NO_EVENT_MODE = FALSE;

TEMP_IMAGE_FILE = 'temp.bmp';

ERROR_LOG_DIR = 'errors\';

MM_LOG_DIR = 'log\mm\';
PORT_MM_DEFAULT = 1026;

DEVICE_NONE = 'None';

MSG_VIDEO_DEVICE_NOT_DEFINED = 'Define video input device first (Options - Multimedia)';

TEMP_DIR = 'temp\';
TEMP_AVI_DIR = 'temp\avi\';

//ADULT_ROOM_NUMBER = 3;

SOUND_COUNT = 16;

SOUND_CLOCK_NUMBER = 15;

LAG_YELLOW = 500;
LAG_RED = 1000;

ERRORS_SENDING = TRUE;
ERRORS_SAVING = FALSE;

AUTOUPDATE_FILE_NAME = 'ic_full.exe';

var
  IS_BANNED: Boolean = FALSE;

  MAIN_DIR: string;
  SL_DP_CODES: TStringList;

  ArrowCircleColors: string =
    'black,blue,dkgray,fuchsia,gray,green,lime,ltgray,maroon,navy,olive,purple,red,silver,teal,white,yellow';

  ERROR_LOG_FILENAME: string;

  VIDEO_BROADCASTING: Boolean;

  CURRENT_PASSWORD: string;

  SPECIAL_OFFER: string = 'Special offer!!! Limited! First 200 members will get 18 months instead of 12!\nOnly 198 remains!';

implementation

end.



