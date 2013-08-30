{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSConst;

interface

uses Classes, syncobjs;

type
  TOfferType = (otMatch, otResume, otSeek);
  TRatedType = (rtStandard, rtBlitz, rtBullet, rtCrazy, rtFischer, rtLoser);
  TPhotoType = (phtClub,phtUser);
  TBanType = (banNone, banBan, banMute, banEvent, banNuke, banProfile);
  TLaunchMode = (lncService, lncApplication);

const
{ RatedTypes }
RATED_TYPES: array[0..5] of string = ('Standard', 'Blitz', 'Bullet', 'Crazy House', 'Fischer Random', 'Losers');

{ General Constants }
CHESSLINK_SERVER = 'InfiniaChess.com';
MAX_LOGIN_LENGTH = 15;
MAX_PWD_LENGTH = 15;
MAX_EMAIL_LENGTH = 100;
MAX_MAC_LENGTH = 50;

//DB_PROVIDER = 'Provider=SQLOLEDB.1;Password="Nf6=Q";Persist Security Info=True;User ID=clsa;Initial Catalog=CLServer;Data Source=Uris';

{ Socket Constants }
MAX_LEN = 8192;
MAX_LEN_MM = 65536;


{ Time Constants }
{ Timeout threshold in milliseconds for a client to respond to a DP_FLAG or
  reconnect after a uninitial disconnect. If exceeded then the client may
  forfeit the game based on lag. }
NET_TIMEOUT: Integer = 90000;
EVENT_TIMEOUT: Integer = 60000;
MSECS = 1000;
MSECS_PER_MINUTE = 60000;
MAX_MINUTES = 999;
MAX_SECS = 999;
MIN_SECS = -999;

{ Command Constants }
{ These are the commands the server supports (sorted alphabitcally) }
CMD_STR_ABORT = '/abort'; { Uses Primary }
CMD_STR_ACCEPT = '/accept';
CMD_STR_ADDRESS = '/address';
CMD_STR_ACK_FLAG = #16; { Intended to be sent by client in response to DP_FLAG }
CMD_STR_ACK_PING = #6;
CMD_STR_ADJOURN = '/adjourn';
CMD_STR_ARROW = '/arrow';
CMD_STR_BACK = '/back'; { Uses Primary }
CMD_STR_BAN = '/ban';
CMD_STR_BANHISTORY = '/banhistory';
CMD_STR_BYE = '/bye';
CMD_STR_CENSOR_ADD = '/+censor';
CMD_STR_CENSOR_REMOVE = '/-censor';
CMD_STR_CHANGE_TITLE = '/changetitle';
CMD_STR_CIRCLE = '/circle';
CMD_STR_CLEAR_MARKERS = '/clearmarkers'; { Uses Primary }
CMD_STR_CLOSE_SOCKET = '/closesocket';
CMD_STR_CREATE_ROOM = '/createroom';
CMD_STR_DECLINE = '/decline';
CMD_STR_DELETE_MESSAGE = '/deletemessage';
CMD_STR_DEMOBOARD = '/demoboard';
CMD_STR_DISABLE = '/disable';
CMD_STR_DRAW = '/draw'; { Uses Primary }
CMD_STR_ENABLE = '/enable';
CMD_STR_ENTER = '/enter';
CMD_STR_EXIT = '/exit';
CMD_STR_FEN = '/fen'; { Uses Primary }
CMD_STR_FOLLOW = '/follow';
CMD_STR_FLAG = '/flag'; { Uses Primary }
CMD_STR_FORWARD = '/forward'; { Uses Primary }
CMD_STR_INCLUDE = '/include'; { Uses Primary }
CMD_STR_INVITE ='/invite';
CMD_STR_KIBITZ = '/kibitz'; { Uses Primary }
CMD_STR_LIBRARY_ADD = '/+library';
CMD_STR_LIBRARY_REMOVE = '/-library';
CMD_STR_LOAD = '/load';
CMD_STR_LOCK = '/lock'; { Uses Primary }
// CMD_STR_LOG = '/log'; obsolete
CMD_STR_LOGIN = '/login';
CMD_STR_LOGINERRORS = '/loginerrors';
CMD_STR_LOGINHISTORY = '/loginhistory';
CMD_STR_MATCH = '/match';
CMD_STR_MESSAGE = '/message';
CMD_STR_MESUPER = '/mesuper';
CMD_STR_MORETIME = '/moretime'; { Uses Primary }
CMD_STR_MOVE = '/move';
CMD_STR_MUTE = '/mute';
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
CMD_STR_SETRATING = '/setrating';
CMD_STR_SHOUT = '/shout';
CMD_STR_TAKEBACK = '/takeback'; { Uses Primary }
CMD_STR_TELL = '/tell';
CMD_STR_TIME = '/time';
CMD_STR_TWINS = '/twins';
CMD_STR_UNARROW = '/unarrow';
CMD_STR_UNCIRCLE = '/uncircle';
CMD_STR_UNBAN = '/unban';
CMD_STR_UNFOLLOW = '/unfollow';
CMD_STR_UNLOCK = '/unlock'; { Uses Primary }
CMD_STR_UNMUTE = '/unmute';
CMD_STR_UNOFFER = '/unoffer';
CMD_STR_VARS = '/vars';
CMD_STR_WHISPER = '/whisper'; { Uses Primary }
CMD_STR_ZERO_TIME = #15;
CMD_STR_COMMANDS = '/commands';
CMD_STR_COMMAND_ADD = '/+command';
CMD_STR_COMMAND_CHANGE = '/commandlevel';
CMD_STR_ROLES = '/roles';
CMD_STR_ROLE_ADD = '/+role';
CMD_STR_ROLE_REMOVE = '/-role';
CMD_STR_ROLE_RELEASE = '/release';
CMD_STR_ALLOW = '/allow';
CMD_STR_REJECT = '/reject';
CMD_STR_EMPLOY = '/employ';
CMD_STR_DISMISS = '/dismiss';
CMD_STR_MEMBERS = '/members';
CMD_STR_SETVAR = '/setvar';
CMD_STR_READVARS = '/readvars';
CMD_STR_CHEATS = '/cheats';
CMD_STR_FOLLOWS = '/follows';
CMD_STR_ADDCOMMANDTITLE = '/+titlecommand';
CMD_STR_REMOVECOMMANDTITLE = '/-titlecommand';
CMD_STR_TITLECOMMANDS = '/titlecommands';
CMD_STR_EVENT_CREATE = '/event_create';
CMD_STR_EVENT_JOIN = '/event_join';
CMD_STR_EVENT_START = '/event_start';
CMD_STR_EVENT_TELL = '/event_tell';
CMD_STR_EVENT_LEAVE = '/event_leave';
CMD_STR_EVENT_OBSERVE = '/event_observe';
CMD_STR_EVENT_DELETE = '/event_delete';
CMD_STR_ODDS_ADD = '/odds_add';
CMD_STR_ODDS_CLEAR = '/odds_clear';
CMD_STR_FLUSHLOG = '/flushlog';
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
CMD_STR_EMAIL_RECONNECT = '/email_reconnect';
CMD_STR_EMAIL_SEND = '/email_send';
CMD_STR_AUTH_KEY_REQ = '/auth_key_req';
CMD_STR_KEY_CONFIRM = '/key_confirm';
CMD_STR_PASS_FORGOT = '/pass_forgot';
CMD_STR_EVENT_BAN = '/event_ban';
CMD_STR_EVENT_UNBAN = '/event_unban';
CMD_STR_EVENT_KICKOUT = '/event_kickout';
CMD_STR_PHOTO_SEND = '/photo_send';
CMD_STR_TIMESTAT = '/timestat';
CMD_STR_CLEARTIMESTAT = '/cleartimestat';
CMD_STR_CHATLOG = '/chatlog';
CMD_STR_ADJOURN_ALL = '/adjourn_all';
CMD_STR_MM = '/mm';
CMD_STR_CHANGE_PASSWORD = '/changepassword';
CMD_STR_ADULT = '/adult';
CMD_STR_STAT = '/stat';
CMD_STR_READ_STAT_TYPES = '/readstattypes';
CMD_STR_WIN = '/win';
CMD_STR_DISCONNECT = '/disconnect';
CMD_STR_SHOWGREETINGS = '/showgreetings';
CMD_STR_SETGREETINGS = '/setgreetings';
CMD_STR_CLUBS = '/clubs';
CMD_STR_CLUB = '/club';
CMD_STR_CLUB_REMOVE = '/-club';
CMD_STR_SETUSERCLUB = '/setuserclub';
CMD_STR_EVENT_CLUB = '/event_club';
CMD_STR_CLUB_MEMBERS = '/clubmembers';
CMD_STR_USER_CLUB = '/userclub';
CMD_STR_GOTOCLUB = '/gotoclub';
CMD_STR_CLUBSTATUS = '/clubstatus';
CMD_STR_GETCLUBMEMBERS = '/getclubmembers';
CMD_STR_CLUBOPTIONS = '/cluboptions';
CMD_STR_CLUBINFO = '/clubinfo';
CMD_STR_CLUBPHOTO = '/clubphoto';
CMD_STR_GAMESEARCH = '/gamesearch';
CMD_STR_EVENT_TICKETS_BEGIN = '/event_tickets_begin';
CMD_STR_EVENT_TICKET = '/event_ticket';
CMD_STR_EVENT_TICKETS_END = '/event_tickets_end';
CMD_STR_EVENT_GAME_OBSERVE = '/event_game_observe';
CMD_STR_SETADMINLEVEL = '/setadminlevel';
CMD_STR_ADMINLEVEL = '/adminlevel';
CMD_STR_ADMINS = '/admins';
CMD_STR_SCORE = '/score';
CMD_STR_NAMES = '/names';
CMD_STR_ADDRESSHISTORY = '/addresshistory';
CMD_STR_MODE = '/mode';
CMD_STR_STARTMESSAGE = '/startmessage';
CMD_STR_DELETEROOM = '/deleteroom';
CMD_STR_DELETEPROFILEPHOTO = '/deleteprofilephoto';
CMD_STR_SETPROFILENOTES = '/setprofilenotes';
CMD_STR_NOTES = '/notes';
CMD_STR_BANPROFILE = '/banprofile';
CMD_STR_UNBANPROFILE = '/unbanprofile';
CMD_STR_MESSAGESEARCH = '/messagesearch';
CMD_STR_MESSAGESTATE = '/messagestate';
CMD_STR_MESSAGERETRIEVE = '/messageretrieve';
CMD_STR_SETIMAGE = '/setimage';
CMD_STR_CLIENTERROR = '/clienterror';
CMD_STR_ADMINGREETINGS = '/admingreetings';
CMD_STR_READTIMEODDSLIMITS = '/readtimeoddslimits';
CMD_STR_FULLRECORD = '/fullrecord';
CMD_STR_MESSAGEGROUP = '/messagegroup';
CMD_STR_HELP = '/help';
CMD_STR_EVENT_FINISH = '/event_finish';
CMD_STR_PROFILE_ACH = '/profile_ach';
CMD_STR_TRANSACTION_STATE = '/transaction_state';
CMD_STR_TRANSACTION = '/transaction';
CMD_STR_READACHIEVEMENTS = '/readachievements';
CMD_STR_PLAYENGINEGAME = '/playenginegame';
CMD_STR_SUMMON = '/summon';
CMD_STR_ORDER = '/order';
CMD_STR_TEST = '/test';
CMD_STR_PM_EXIT = '/pm_exit';
CMD_STR_REQUEST_USER_INFO = '/request_user_info';
CMD_STR_SKIP_UPDATE = '/skip_update';

{ Incoming Command Constants (named after commands above but grouped by function) }
{ Misc / System / Admin -1..99}
CMD_UNKNOWN = -1;
CMD_ME_SUPER = 1;
CMD_CLOSE_SOCKET = 2;
CMD_ACK_PING = 6;
CMD_NUKE = 50;
CMD_CHANGE_TITLE = 51;
CMD_DISABLE = 52;
CMD_ENABLE = 53;
CMD_ADDRESS = 54;
//CMD_LOG = 55;

{ Connection / Login 100..199 }
CMD_BYE = 101;
CMD_LOGIN = 103;
CMD_REGISTER = 105;
{ Settings 200..299 }
CMD_SET = 200;
CMD_SET_ALL = 201;
{ Notify / Censor Lists 300..399 }
CMD_NOTIFY_ADD = 300;
CMD_NOTIFY_REMOVE = 301;
CMD_CENSOR_ADD = 310;
CMD_CENSOR_REMOVE = 311;

{ Communications 400..499 }
CMD_DELETE_MESSAGE = 400;
CMD_GET_MESSAGE = 401;
CMD_KIBITZ = 402;
CMD_MESSAGE = 403;
CMD_SAY = 404;
CMD_SHOUT = 405;
CMD_TELL = 406;
CMD_WHISPER = 408;
CMD_MUTE = 410;
CMD_UNMUTE = 411;

{ Rooms 500..599 }
CMD_CREATE_ROOM = 500;
CMD_ENTER = 501;
CMD_EXIT = 502;
CMD_INVITE = 503;
{ Ratings 600..699 }
{ Offers 700..799 }
CMD_ACCEPT = 700;
CMD_DECLINE = 701;
CMD_MATCH = 702;
CMD_SEEK = 703;
{ Profiles 800..899 }
CMD_PROFILE = 800;
{ Games 900.999 }
CMD_ABORT = 900;
CMD_ACK_FLAG = 901;
CMD_ADJOURN = 902;
CMD_ADJOURNED = 903;
CMD_ARROW = 904;
CMD_CIRCLE = 905;
CMD_CLEAR_MARKERS = 906;
CMD_DRAW = 907;
CMD_FEN = 908;
CMD_FORWARD = 909;
CMD_FLAG = 910;
CMD_GAMES = 911;
CMD_INCLUDE = 912;
CMD_LIBRARY = 913;
CMD_LIBRARY_ADD = 914;
CMD_LIBRARY_REMOVE = 915;
CMD_LOAD = 916;
CMD_LOCK = 917;
CMD_MORETIME = 918;
CMD_MOVE = 919;
CMD_OBSERVE = 920;
CMD_PRIMARY = 921;
CMD_QUIT = 922;
CMD_RECENT = 923;
CMD_RESIGN = 924;
CMD_RESUME = 925;
CMD_REVERT = 926;
CMD_TAKEBACK = 927;
CMD_UNARROW = 928;
CMD_UNCIRCLE = 929;
CMD_UNLOCK = 930;
CMD_UNOFFER = 931;
CMD_ZERO_TIME = 932;
CMD_FOLLOW = 933;
CMD_UNFOLLOW = 934;
CMD_BAN = 935;
CMD_UNBAN = 936;
CMD_SETRATING = 937;
CMD_BANHISTORY = 938;
CMD_LOGINHISTORY = 939;
CMD_TWINS = 940;
CMD_DEMOBOARD = 941;
CMD_TIME = 942;
CMD_LOGINERRORS = 943;
CMD_COMMANDS = 944;
CMD_COMMAND_ADD = 945;
CMD_COMMAND_CHANGE = 946;
CMD_ROLES = 947;
CMD_ROLE_ADD = 948;
CMD_ROLE_REMOVE = 949;
CMD_ROLE_RELEASE = 950;
CMD_ALLOW = 951;
CMD_REJECT = 952;
CMD_EMPLOY = 953;
CMD_DISMISS = 954;
CMD_MEMBERS = 955;
CMD_VARS = 956;
CMD_SETVAR = 957;
CMD_READVARS = 958;
CMD_CHEATS = 959;
CMD_FOLLOWS = 960;
CMD_ADDCOMMANDTITLE = 961;
CMD_REMOVECOMMANDTITLE = 962;
CMD_TITLECOMMANDS = 963;
CMD_EVENT_CREATE = 964;
CMD_EVENT_JOIN = 965;
CMD_EVENT_START = 966;
CMD_EVENT_TELL = 967;
CMD_EVENT_LEAVE = 968;
CMD_EVENT_OBSERVE = 969;
CMD_EVENT_DELETE = 970;
CMD_ODDS_ADD = 971;
CMD_ODDS_CLEAR = 972;
CMD_FLUSHLOG = 973;
CMD_EVENT_PARAMS = 974;
CMD_EVENT_PAUSE = 975;
CMD_EVENT_RESUME = 976;
CMD_EVENT_SHOUT = 977;
CMD_EVENT_MEMBER = 978;
CMD_EVENT_ABANDON = 979;
CMD_EVENT_FORFEIT = 980;
CMD_EVENT_GAME_ACCEPT = 981;
CMD_EVENT_GAME_ABORT = 982;
CMD_EVENT_CREATE_END = 983;
CMD_EVENT_CONG = 984;
CMD_AUTH_KEY = 985;
CMD_EMAIL_CHANGE = 986;
CMD_EMAIL_RECONNECT = 987;
CMD_EMAIL_SEND = 988;
CMD_AUTH_KEY_REQ = 989;
CMD_KEY_CONFIRM = 990;
CMD_PASS_FORGOT = 991;
CMD_EVENT_BAN = 992;
CMD_EVENT_UNBAN = 993;
CMD_EVENT_KICKOUT = 994;
CMD_PHOTO_SEND = 995;
CMD_TIMESTAT = 996;
CMD_CLEARTIMESTAT = 997;
CMD_CHATLOG = 998;
CMD_ADJOURN_ALL = 999;
CMD_MM = 1000;
CMD_CHANGE_PASSWORD = 1001;
CMD_ADULT = 1002;
CMD_STAT = 1003;
CMD_READ_STAT_TYPES = 1004;
CMD_WIN = 1005;
CMD_DISCONNECT = 1006;
CMD_SHOWGREETINGS = 1007;
CMD_SETGREETINGS = 1008;
CMD_CLUBS = 1009;
CMD_CLUB = 1010;
CMD_CLUB_REMOVE = 1011;
CMD_SETUSERCLUB = 1012;
CMD_EVENT_CLUB = 1013;
CMD_CLUB_MEMBERS = 1014;
CMD_USER_CLUB = 1015;
CMD_GOTOCLUB = 1016;
CMD_CLUBSTATUS = 1017;
CMD_GETCLUBMEMBERS = 1018;
CMD_CLUBOPTIONS = 1019;
CMD_CLUBINFO = 1020;
CMD_CLUBPHOTO = 1021;
CMD_GAMESEARCH = 1022;
CMD_EVENT_TICKETS_BEGIN = 1023;
CMD_EVENT_TICKET = 1024;
CMD_EVENT_TICKETS_END = 1025;
CMD_EVENT_GAME_OBSERVE = 1026;
CMD_SETADMINLEVEL = 1027;
CMD_ADMINLEVEL = 1028;
CMD_ADMINS = 1029;
CMD_SCORE = 1030;
CMD_NAMES = 1031;
CMD_ADDRESSHISTORY = 1032;
CMD_MODE = 1033;
CMD_STARTMESSAGE = 1034;
CMD_DELETEROOM = 1035;
CMD_DELETEPROFILEPHOTO = 1036;
CMD_SETPROFILENOTES = 1037;
CMD_NOTES = 1038;
CMD_BANPROFILE = 1039;
CMD_UNBANPROFILE = 1040;
CMD_MESSAGESEARCH = 1041;
CMD_MESSAGESTATE = 1042;
CMD_MESSAGERETRIEVE = 1043;
CMD_SETIMAGE = 1044;
CMD_CLIENTERROR = 1045;
CMD_ADMINGREETINGS = 1046;
CMD_READTIMEODDSLIMITS = 1047;
CMD_FULLRECORD = 1048;
CMD_MESSAGEGROUP = 1049;
CMD_HELP = 1050;
CMD_EVENT_FINISH = 1051;
CMD_PROFILE_ACH = 1052;
CMD_TRANSACTION_STATE = 1053;
CMD_TRANSACTION = 1054;
CMD_READACHIEVEMENTS = 1055;
CMD_PLAYENGINEGAME = 1056;
CMD_SUMMON = 1057;
CMD_ORDER = 1058;
CMD_TEST = 1059;
CMD_PM_EXIT = 1060;
CMD_REQUEST_USER_INFO = 1061;
CMD_SKIP_UPDATE = 1062;

{ Outgoing Datapack Constants }
{ CLServer DP Delimiteres }
DP_START = #20;
DP_DELIMITER = #21;
DP_END = #22;

{ CLServer DP Definitions. Ensure that these match the CSConst.pas
  file for the CLServer project. }

{ DP_SERVER_MSG: DP#, ErrorLevel, Message }
DP_SERVER_MSG = '0';
DP_ERR_0 = '0'; { normal }
DP_ERR_1 = '1'; { warning }
DP_ERR_2 = '2'; { error }
DP_MSG_AUTO_LOGOUT = 'The server has logged you off due to excessive idle time.';
DP_MSG_INVALID_COMMAND = 'Invalid Command.';
DP_MSG_INCORRECT_PARAM_COUNT = 'Incorrect number of parameters for command.';
DP_MSG_INCORRECT_PARAM_TYPE = 'Incorrect type(s) of parameters for command.';
DP_MSG_LOGIN_INVALID = 'The login name / password combination is not valid. Please check them and try again.';
DP_MSG_LOGIN_DISABLED = 'Cannot login, account disabled.';
DP_MSG_LOGIN_BADCLIENT = 'The client you are using is not supported, plesae download a newer version from www.infiniachess.com';
DP_MSG_LOGIN_BANNED_CLIENT = 'This client banned from the server.';
DP_MSG_LOGIN_ALREADY_IN = 'You are already logged in.';
DP_MSG_LOGIN_NAME_IN_USE = 'That login name is currently in use. If you suspect a stolen account please email the administrator.';
DP_MSG_LOGIN_REQUIRED = 'You must login before issuing commands.';
DP_MSG_LOGIN_EXCEEDS_MAX = 'That handle and/or password exceeds the maximun number of characters';
DP_MSG_LOGIN_NOT_LOGGEDIN = 'The player %s is not currently logged in.';
DP_MSG_LOGINID_INVALID = '%s is not a valid registered login.';
DP_MSG_LOGIN_CLIENT_LOGGEDIN = 'Client is already logged in.';
DP_MSG_NON_EXISTANT_OFFER = 'That offer number does not exist.';
DP_MSG_NOT_OFFER_OWNER = 'You cannot remove a offer that you did not create.';
DP_MSG_NOT_OFFER_RECEPIENT = 'You are not the recepient of that offer.';
DP_MSG_CREJECT = 'Title (C) is forbidden for this offer';
DP_MSG_PREJECT = 'Provisional rating is forbidden for this offer';
DP_MSG_DECLINE_OFFER = 'Your match request to %s was declined.';
DP_MSG_NON_EXISTANT_GAME = 'That game number does not exist.';
DP_MSG_NO_PRIMARY_GAME = 'No Primary game. You cannot issue that command w/o being involved in a game.';
DP_MSG_NOT_GAME_PLAYER = 'You are not a player in that game.';
DP_MSG_ALREADY_OBSERVING = 'You are already observing the game: (%d) %s vs %s';
DP_MSG_NOT_INVOLVED = 'You are in no way related to that game.';
DP_MSG_INVALID_FEN = 'That was an invalid FEN string.';
DP_MSG_ON_MAINLINE = 'Cannot revert. You are already on the main line.';
DP_MSG_NOT_OPEN = 'is not currenlty open for receiving matches.';
DP_MSG_RATING_RANGE = 'Your rating is not within %ss rating range.';
DP_MSG_DB_ERROR = 'The server was unable to validate your login, try again.';
DP_MSG_OFFER_LIMIT_MET = 'You have reached your seek/match limit. Remove a existing seek/offer and try again.';
DP_MSG_C_NO_SEEK = 'Player with title (C) cannot seek';
DP_MSG_NO_NEG_TIME = 'Negative initial and/or increment times not allowed. Values will be adjusted to minimum allowed.';
DP_MSG_GAME_LIMIT_MET = 'You have reached your game limit. Leave a game and try again.';
DP_MSG_ADMIN_ONLY = 'Command may be only be issued by administrators.';
DP_MSG_SUPER_ADMIN_ONLY = 'Command may be only be issued by super administrators.';
DP_MSG_REGISTERED_ONLY = 'Command may only be issued by registered members';
DP_MSG_LOGIN_NUKED = '%s has been nuked.';
DP_MSG_TOLD = 'Told %s.';
DP_MSG_INVALID_ADJOURN = 'Game # %s is not a valid adjourned game for you.';
DP_MSG_GUEST_NO_RATED ='Guests may play unrated games only.';
DP_MSG_NOTIFY_ALREADY = '%s is already in your notify list.';
DP_MSG_NOTIFY_LIMIT_MET = 'Unable to add %s. Your notify list is full.';
DP_MSG_MESSAGE_SENT = 'Successfully messaged %s';
DP_MSG_MESSAGEID_INVALID = 'Message ID %s is not valid.';
DP_MSG_NON_EXISTANT_ROOM = 'Room # %s is not a valid room.';
DP_MSG_NOT_IN_ROOM = 'You are not in room # %s.';
DP_MSG_RESTRICTED_ROOM = 'Room %s is restricted to Administrators only.';
DP_MSG_ALREADY_IN_ROOM = '%s is already in room # %s.';
DP_MSG_NO_ROOM_CREATED = 'You may only invite others once you have created a Room.';
DP_MSG_ROOM_CREATED = 'You are allowed to create only one room.';
DP_MSG_INVITED_CONNECTION = 'Invited %s to your room.';
DP_MSG_INVITE_LIMIT_MET = 'You have invited the maximum number of people to your room.';
DP_MSG_NOT_INVITED = 'You have not been invited into room # %s.';
DP_MSG_ROOM_LIMIT_MET = 'You are already in the maximum allowable number of rooms.';
DP_MSG_ROOM_FULL = 'Sorry, room # %s, %s, is full.';
DP_MSG_GAMEID_NOT_VALID = 'The GameID, %s, does not exist.';
DP_MSG_ALREADY_IN_LIB = 'The GameID, %s, already exists in your library.';
DP_MSG_NOT_IN_LIB = 'The GameID, %s, does not exists in your library therefore cannot be removed.';
DP_MSG_LIBRARY_FULL = 'Your Library is full. The GameID, %s, was not added.';
DP_MSG_LIBRARY_ADDED = 'The GameID, %s, was successfully added to your Library.';
DP_MSG_LIBRARY_REMOVED = 'The GameID, %s, was successfully removed from your Library.';
DP_MSG_NON_EXISTANT_SETTING = '%s is not a recognized setting.';
DP_MSG_CANNOT_ASSIGN = 'Cannot assign the value ''%s'' to %s.';
DP_MSG_SETTING_ASSIGNED = 'Successfully assign the value ''%s'' to %s.';
DP_MSG_MUTE = 'You have been muted by the administrators and may not communicate.';
DP_MSG_MUTED = '%s has been muted';
DP_MSG_UNMUTED = '%s has been un-muted.';
DP_MSG_CENSOR_LIMIT_MET = 'Unable to add %s. Your censor list is full.';
DP_MSG_CENSORED_ALREADY = '%s is already in your censor list.';
DP_MSG_NO_CENSOR_ADMIN = 'Cannot censor Super Admins.';
DP_MSG_CENSORED = '%s is censoring you.';
DP_MSG_CENSORING = 'You are censoring %s.';
DP_MSG_TITLE_CHANGED = 'The title for %s has been changed to %s';
DP_MSG_DISABLED_LOGIN = 'The account for %s has been disabled.';
DP_MSG_ENABLED_LOGIN = 'The account for %s has been enabled.';
DP_MSG_ERR_GAME_LOCKED = 'Cannot observe. Game locked.';
DP_MSG_FOLLOW_YOURSELF = 'You cannot follow yourself :-)';
DP_MSG_MODE_NOGAMES = 'Server is in no-games mode now. You cannot seek, match or accept games.';
DP_MSG_MEMBERSHIP_END = 'Your membership has ended. ';
DP_MSG_STANDARD_RULES_ONLY = 'You can only play standard rules games now. ';
DP_MSG_OP_STANDARD_RULES_ONLY = 'Your opponent can only play standard rules games now. ';
DP_MSG_CHAT_WITH_ADMIN_ONLY = 'Your chat messages are visible for admins and your game opponents only . ';
DP_MSG_NO_MESSAGES = 'You cannot send messages.';
DP_MSG_NO_ROOMS = 'You cannot enter rooms except of Help and Lobby.';
DP_MSG_NO_EVENTS = 'You cannot join events, tournaments or lectures.';
DP_MSG_NO_CLUBS = 'You cannot use clubs or schools.';
DP_MSG_NO_ODDS = 'You cannot play odds games';

{ DP_PING: DP# }
DP_PING = '6';
{ DP_COMMAND_COMPLETE: DP#, CMD# }
DP_COMMAND_COMPLETE = '10';

{ DP_DIALOG: DP#, Title, Message, Buttons, Flags }
DP_DIALOG = '20';

{ DP_CONNECTION_REFUSED: DP# }
DP_CONNECTION_REFUSED = '100';
{ DP_BYE: DP# }
DP_BYE = '101';
{ DP_CONNECTED: DP# }
DP_CONNECTED = '102';
{ DP_LOGIN: DP#, Login, Title, AdminLevel }
DP_LOGIN = '103';
{ DP_LOGIN_ERROR: DP#, ErrorNumber, ErrorDescription }
DP_LOGIN_RESULT = '104';
DP_CODE_LOGIN_SUCCESS = '0';
DP_CODE_LOGIN_LOGGEDIN = '-1';
DP_CODE_LOGIN_INVALID = '-2';
DP_CODE_LOGIN_DISABLED = '-3';
DP_CODE_LOGIN_BADCLIENT = '-4';
DP_CODE_LOGIN_BANNEDCLIENT = '-5';
DP_CODE_LOGIN_CLIENT_LOGGEDIN = '-6';
DP_CODE_LOGIN_UNBANNEDCLIENT = '-7';
DP_CODE_LOGIN_AUTH_KEY = '-8';
DP_CODE_LOGIN_DBERROR = '-10';
{ DP_REGISTER: DP# ResultCode, ResultMSG, Login, Password }
DP_REGISTER = '105';
{ These codes match the proc_Register procedure in the CLServer DB. }
DP_CODE_REGISTER_SUCCESS = '0';
DP_CODE_REGISTER_BAD_LOGIN = '-1';
DP_CODE_REGISTER_BAD_PASSWORD = '-2';
DP_CODE_REGISTER_LOGIN_TAKEN = '-3';
DP_CODE_REGISTER_INAPPROPRIATE = '-4';
DP_CODE_REGISTER_CLIENT_BANNED = '-5';
DP_CODE_REGISTER_BAD_CLIENT= '-6';
DP_CODE_REGISTER_LOGGEDIN = '-7';
DP_CODE_REGISTER_BAD_PARM = '-8';
DP_CODE_REGISTER_TOO_MANY = '-9';
DP_MSG_REGISTER_SUCCESS = 'Registration successful. You may now login as %s.';
DP_MSG_REGISTER_BAD_LOGIN = 'The login %s contains an invalid character, or is not the correct length. Please try again.';
DP_MSG_REGISTER_BAD_PASSWORD = 'The password %s contains an invalid character or is not the correct length. Please try again.';
DP_MSG_REGISTER_LOGIN_TAKEN = 'The login %s has already been claimed. Please choose another and try again.';
DP_MSG_REGISTER_INAPPROPRIATE = 'The login %s is inappropriate and cannot be used. Please choose another and try again.';
DP_MSG_REGISTER_CLIENT_BANNED = 'This client banned from the server.';
DP_MSG_REGISTER_BAD_CLIENT = 'The client you are using is not supported, please download a newer version.';
DP_MSG_REGISTER_LOGGEDIN = 'You may not register a new account while logged in.';
DP_MSG_REGISTER_BAD_PARM = 'Inavlid parameter(s).';
DP_MSG_REGISTER_TOO_MANY = 'You already have maximum number of logins.';
DP_MSG_USER_NOT_EXISTS = 'User %s does not exists';
DP_MSG_USER_BANNED = 'User %s is successfully banned';
DP_MSG_USER_UNBANNED = 'User %s is successfully unbanned';


{ DP_LOGOFF: DP#, LoginID, Login, Title}
DP_LOGOFF = '110';
{ DP_LOGIN_STATE: DP#, LoginID, Login, Title }
DP_LOGIN_STATE = '111';
{ DP_LOGIN_BEGIN: DP# }
DP_LOGIN_BEGIN = '112';
{ DP_LOGIN2: DP#, LoginID, Login, Title }
DP_LOGIN2 = '113';
{ DP_LOGIN_END: DP#}
DP_LOGIN_END = '114';
DP_LOGIN_INFO = '115';

{ DP_SETTINGS: DP# Autoflag, Open, RemoveOffers, InitialTime, IncTime, Color,
  Rated, RatedType, MaxRating, MinRating }
DP_SETTINGS = '200';
{ DP_OPTION: DP# OptionSet }
DP_OPTION = '205';

{ DP_NOTIFY_REMOVE: DP#, LoginID, Login, Title, NotifyType }
DP_NOTIFY_REMOVE = '301';
{ DP_NOTIFY: DP#, LoginID, Login, Title, NotifyType, State }
DP_NOTIFY = '302';
{ DP_NOTIFY_BEGIN: DP# }
DP_NOTIFY_BEGIN = '304';
{ DP_NOTIFY_END: DP# }
DP_NOTIFY_END = '305';

{ DP_MESSAGE: DP#, MessageID, Sender, Title, Date, Subject, Body }
DP_MESSAGE = '401';
{ DP_MESSAGE_DELETE: DP#, MessageID }
DP_MESSAGE_DELETE = '402';
{ DP_KIBITZ: DP#, GameNumber, From, Title, Message }
DP_KIBITZ = '403';
{ DP_SAY: DP#, GameNumber, From, Title, Message }
DP_SAY = '404';
{ DP_SHOUT: DP#, From, Title, Message }
DP_SHOUT = '405';
{DP_TELL_LOGIN: DP#, (from)LoginID, (from)Login, (from) Title,
(reciprocate)LoginID, (reciprocate)Login, (reciprocate)Title, Message }
DP_TELL_LOGIN = '406';
{ DP_TELL_ROOM: DP#, RoomNumber, From, Title, Message }
DP_TELL_ROOM = '407';
{ DP_WHISPER: DP#, GameNumber, From, Title, Message }
DP_WHISPER = '408';

{ DP_ROOM_DEF: DP#, RoomNumber, Description, Creator, Limit, Count }
DP_ROOM_DEF = '500';
{ DP_ROOM_DESTROYED: DP#, RoomNumber }
DP_ROOM_DESTROYED = '501';
{ DP_ROOM_COUNT: DP#, RoomNumber, Count }
DP_ROOM_COUNT = '502';
{ DP_ROOM_I_ENTER: DP#, RoomNumber, Description }
DP_ROOM_I_ENTER = '503';
{ DP_ROOM_I_EXIT: DP#, RoomNumber }
DP_ROOM_I_EXIT = '504';
{ DP_ROOM_DEF_BEGIN: DP# }
DP_ROOM_DEF_BEGIN = '505';
{ DP_ROOM_DEF_END: DP# }
DP_ROOM_DEF_END = '506';
{DP_ROOM_EXIT: DP#, RoomNumber, LoginID, Login, Title }
DP_ROOM_EXIT = '507';
{DP_ROOM_ENTER: DP#, RoomNumber, LoginID, Login, Title }
DP_ROOM_ENTER = '508';
{ DP_ROOM_BEGIN: DP#, RoomNumber }
DP_ROOM_SET_BEGIN = '509';
{ DP_ROOM_END: DP#, RoomNumber }
DP_ROOM_SET_END = '510';

{ DP_RATING: DP#, RatedType, Rating }
DP_RATING = '600';
{ DP_RATING2: DP#, Login, RatingString }
DP_RATING2 = '610';

{ DP_MATCH: DP#, OfferNumber, Color, InitialTime, IncTime, Issuer, Title,
  Provisional, Rated, Rating, RatedType }
DP_MATCH = '700';
{ DP_SEEK: DP#, OfferNumber, Color, InitialTime, IncTime, Issuer, Title,
  Provisional, Rated, Rating, RatedType }
DP_SEEK = '701';
{ DP_UNOFFER: DP#, Offer }
DP_UNOFFER = '702';

{ DP_PROFILE_GAME: DP#, LoginID, Login, Title, ProfileGameType, GameNumber/ID,
  WhiteName, WhiteTitle, WhiteRating, WhiteMSec,
  BlackName, BlackTitle, BlackRating, BlackMSec,
  RatedType, InitialMSec, IncMSec, Rated, GameResult, ECO, Date, LoggedIn }
DP_PROFILE_GAME = '808';
DP_PROFILE_GAMETYPE_RECENT = '0';
DP_PROFILE_GAMETYPE_LIBRARY = '1';
DP_PROFILE_GAMETYPE_ADJOURNED = '2';
DP_PROFILE_GAMETYPE_CURRENT = '3';
{ DP_PROFILE_NOTES: DP#, LoginID, LoginHandle, Title, Note }
DP_PROFILE_NOTE = '810';
{ DP_PROFILE_PING: DP#, LoginID, LoginHandle, Title, AvgPingMSec, PingCount, IdleMSec }
DP_PROFILE_PING = '812';
{ DP_PROFILE_RATING: DP#, LoginID, LoginHandle, Title, RatedType, Rating, Provisional,
  RatedWins, RatedLosses, RatedDraws, UnratedWins, UnratedLosses, UnratedDraws,
  EP, Best, Date, RatedName }
DP_PROFILE_RATING = '813';
{ DP_PROFILE_BEGIN: DP#, LoginID, LoginHandle, Title }
DP_PROFILE_BEGIN = '820';
{ DP_PROFILE_BEGIN: DP#, LoginID, LoginHandle, Title }
DP_PROFILE_END = '821';

{ DP_GAME_MSG: DP#, GameNumber, ErrorLevel, Message }
DP_GAME_MSG = '900';
DP_MSG_ABORT_REQ_SENT = 'Abort request sent.';
DP_MSG_ADJOURN_REQ_SENT = 'Adjourn request sent.';
DP_MSG_DRAW_REQ_SENT = 'Draw request sent.';
DP_MSG_MORETIME_REQ_SENT = 'Moretime request sent.';
DP_MSG_TAKEBACK_REQ_SENT = 'Takeback request sent.';
DP_MSG_ABORT_REQ_INVALID = 'Abort request no longer valid.';
DP_MSG_ADJOURN_REQ_INVALID = 'Adjourn request no longer valid.';
DP_MSG_DRAW_REQ_INVALID = 'Draw request no longer valid.';
DP_MSG_MORETIME_REQ_INVALID = 'Moretime request no longer valid.';
DP_MSG_TAKEBACK_REQ_INVALID = 'Takeback request no longer valid.';
DP_MSG_TIME_REMAINING = 'There is time remaining on both clocks.';
DP_MSG_RATING_ADJUSTMENTS = 'Rating adjustments: %s=%d; %s=%d';
DP_MSG_NO_RATING_ADJUSTMENTS = 'No rating adjustments.';
DP_MSG_NOT_EXCLUSIVE_OWNER = 'You are not the exclusive owner of this game';
DP_MSG_PLAYER_NOT_OBSERVING = 'The player, %s, is not observing your game.';
DP_MSG_PLAYER_NOW_EXAMINER = '%s is now an examiner in game %s';
DP_MSG_GAME_LOCKED = 'Game is now locked.';
DP_MSG_GAME_UNLOCKED = 'Game in now unlocked.';


{ DP_SHOW_GAME: DP#, GameNumber }
DP_SHOW_GAME = '901';
{ DP_GAME_BORN: DP#, GameNumber, Site, Event, Round, Date,
  WhiteName, WhiteTitle, WhiteRating,
  BlackName, BlackTitle, BlackRating,
  InitialMSec, IncMSec, GameMode (0=gmLive, 1=gmExamine),
  PlayerInGame (0=no 1=yes), RatedType, Rated, Locked }
DP_GAME_BORN = '902';
{ DP_FEN: DP#, GameNumber, FEN }
DP_FEN = '903';
{ DP_GAME_RESULT: DP#, GameNumber, ResultCode }
DP_GAME_RESULT = '904';

DP_CODE_NO_RESULT = '0';
DP_CODE_ABORTED = '1';
DP_CODE_ADJOURNED = '2';
DP_CODE_DRAW = '3';
DP_CODE_WHITE_RESIGNS = '4';
DP_CODE_BLACK_RESIGNS = '5';
DP_CODE_WHITE_CHECKMATED = '6';
DP_CODE_BLACK_CHECKMATED = '7';
DP_CODE_WHITE_STALEMATED = '8';
DP_CODE_BLACK_STALEMATED = '9';
DP_CODE_WHITE_FORFEITS_TIME = '10';
DP_CODE_BLACK_FORFEITS_TIME = '11';
DP_CODE_WHITE_FORFEITS_NETWORK = '12';
DP_CODE_BLACK_FORFEITS_NETWORK = '13';
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
DP_MSG_SMALL_TIME = 'Game must have at least 30 second of initial time if no time is adding every move';
DP_MSG_SMALL_TIME2 = 'Game must have at least 10 second of initial time';
DP_MSG_INVISIBLE_CHAT = 'Invisible user cannot write in chat';
DP_MSG_PROV_ODDS = 'Player with provisional rating cannot play rated games with odds';

{ DP_GAME_PERISH: DP#, GameNumber }
DP_GAME_PERISH = '905';
{ DP_MOVE_BEGIN: DP#, GameNumber, NumberOfMovesToFollow }
DP_MOVE_BEGIN = '906';
{ DP_MOVE: DP#, GameNumber, FromSqr, ToSqr, Param, PGN }
DP_MOVE = '907';
{ DP_MOVE_END: DP#, GameNumber }
DP_MOVE_END = '908';
{ DP_ILLEGAL_MOVE: DP#, GameNumber, ReasonMessage }
DP_ILLEGAL_MOVE = '909';
DP_MSG_NOT_YOUR_MOVE = 'It is not your move';
DP_MSG_ILLEGAL_MOVE = 'Illegal move';
{ DP_MSEC: DP#, GameNumber, WhiteMSec, BlackMSec }
DP_MSEC = '910';
{ DP_FLAG: DP#, GameNumber }
DP_FLAG = '911';
{ DP_DRAW: DP#, GameNumber, PlayerRequestingDraw, Title }
DP_DRAW = '912';
{ DP_ABORT_OFFER: DP#, GameNumber, PlayerRequestingAbort, Title }
DP_ABORT = '913';
{ DP_ADJOURN: DP#, GameNumber, PlayerRequestingAdjour, Title }
DP_ADJOURN = '914';
{ DP_ARROW: DP# GameNumber, FromSqr, ToSqr }
DP_ARROW = '915';
{ DP_UNARROW: DP# GameNumber, FromSqr, ToSqr }
DP_UNARROW = '916';
{ DP_CIRCLE: DP# GameNumber, Sqr }
DP_CIRCLE = '917';
{ DP_UNCIRCLE: DP# GameNumber, Sqr }
DP_UNCIRCLE = '918';
{ DP_CLEAR_MARKERS: DP# GameNumber, FromSqr, ToSqr }
DP_CLEAR_MARKERS = '919';
{ DP_TAKEBACK_REQUEST: DP# GameNumber TakebackCount, PlayerRequestingTakeback, Title }
DP_TAKEBACK_REQUEST = '920';
{ DP_TAKEBACK: DP# GameNumber TakebackCount }
DP_TAKEBACK = '921';
{ DP_PRIMARY: DP# GameNumber }
DP_PRIMARY = '922';

{ DP_LIBRARY_ADD: DP#, GameID }
DP_LIBRARY_ADD = '926';
{ DP_LIBRARY_REMOVE: DP#, GameID }
DP_LIBRARY_REMOVE = '927';

{ DP_GAME_PERISH2: DP#, GameNumber }
DP_GAME_PERISH2 = '929';
{ DP_GAME_BEGIN: DP#  }
DP_GAME_BEGIN = '930';
{ DP_GAME: DP#, GameNumber/ID,
  WhiteName, WhiteTitle, WhiteRating,
  BlackName, BlackTitle, BlackRating,
  RatedType, InitialMSec, IncMSec, Rated, ResultCode, Locked }
DP_GAME = '931';
{ DP_GAMES_END: DP# }
DP_GAME_END = '932';
{ DP_GAME_LOCK: DP#, GameNumber/ID, Locked (1=yes, 0=no)}
DP_GAME_LOCK = '933';

{ DP_UNOBSERVER: DP#, GameNumber, LoginID, Login, Title }
DP_UNOBSERVER = '934';
{ DP_OBSERVER: DP#, GameNumber, LoginID, Login, Title }
DP_OBSERVER = '935';
{ DP_OBSERVER_BEGIN: DP#, GameNumber }
DP_OBSERVER_BEGIN = '936';
{ DP_OBSERVER_END: DP#, GameNumber }
DP_OBSERVER_END = '937';

{ DP_MORETIME_REQUEST: DP#, GameNumber, Secs, PlayerRequestingMoreTime, Title }
DP_MORETIME_REQUEST = '950';

{ DP_INCLUDED: DP#, GameNumber, Color }
DP_INCLUDED = '955';

DP_FOLLOW_START = '960';
DP_FOLLOW_END = '970';
//DP_UNBAN = '975';

DP_EVENT_CREATED = '971';
DP_EVENT_JOINED = '972';
DP_EVENT_STARTED = '973';
DP_EVENT_TELL = '974';
DP_EVENT_LEADER_LOCATION = '975';
DP_EVENT_FINISHED = '976';
DP_EVENT_DELETED = '977';
DP_ODDS_ADD = '978';
DP_EVENT_STATISTIC = '979';
DP_EVENT_ODDS_ADD = '980';
DP_EVENT_KING = '981';
DP_EVENT_QUEUE_TAIL = '982';
DP_EVENT_LEFT = '983';
DP_EVENT_MEMBER = '984';
DP_EVENT_ABANDON = '985';
DP_EVENT_QUEUE_CLEAR = '986';
DP_EVENT_QUEUE_ADD = '987';
DP_EVENT_MEMBERS_START = '988';
DP_EVENT_MEMBERS_END = '989';
DP_EVENT_REGLGAMES_START = '990';
DP_EVENT_REGLGAME_ADD = '991';
DP_EVENT_REGLGAMES_END = '992';
DP_EVENT_REGLGAME_UPDATE = '993';
DP_EVENT_REGLAMENT = '994';
DP_EVENT_ACCEPT_REQUEST = '995';
DP_AUTH_KEY_RESULT = '996';
DP_AUTH_KEY_REQ_RESULT = '997';
DP_PASS_FORGOT_RES = '998';
DP_PHOTO = '999';
DP_PROFILE_DATA = '1000';
DP_BEGINNING_STAT = '1001';
DP_CHATLOG_START = '1002';
DP_CHATLOG = '1003';
DP_CHATLOG_END = '1004';
DP_CHATLOG_PAGE = '1005';
DP_MM_INVITE = '1006';
DP_PING_VALUE = '1007';
DP_ADULT = '1008';

DP_STATTYPE_BEGIN = '1009';
DP_STATTYPE = '1010';
DP_STATTYPE_END = '1011';

DP_STAT_BEGIN = '1012';
DP_STAT = '1013';
DP_STAT_END = '1014';

DP_EVENT_GAMES_BEGIN = '1015';
DP_EVENT_GAMES_END = '1016';

DP_CLUB_BEGIN = '1017';
DP_CLUB = '1018';
DP_CLUB_END = '1019';

DP_SEEKS_CLEAR = '1020';
DP_EVENTS_CLEAR = '1021';

DP_CLUB_MEMBERS_BEGIN = '1022';
DP_CLUB_MEMBER = '1023';
DP_CLUB_MEMBERS_END = '1024';

DP_CLUB_CHANGED = '1025';
DP_CLUB_STATUS = '1026';
DP_CLUB_INFO = '1027';
DP_CLUB_PHOTO = '1028';
DP_CLUB_OPTIONS = '1029';

DP_USER_PING_VALUE = '1030';
DP_PROFILE_PAGES = '1031';
DP_PROFILE_RECENT_CLEAR = '1032';

DP_EVENT_TICKETS_BEGIN = '1033';
DP_EVENT_TICKET = '1034';
DP_EVENT_TICKETS_END = '1035';

DP_GAME_SCORE = '1036';
DP_PROFILE_CHATREADER = '1037';
DP_NOTES = '1038';
DP_RIGHTS = '1039';
DP_SERVER_TIME = '1040';

DP_MESSAGE2 = '1041';
DP_MESSAGE_PAGES = '1042';
DP_MESSAGE_CLEAR = '1043';
DP_IMAGE = '1044';
// access levels
DP_AL_START = '1045';
DP_AL_LEVEL = '1046';
DP_AL_TYPE = '1047';
DP_AL_LINK = '1048';
DP_AL_FINISH = '1049';

DP_NEWUSER_GREATED = '1050';
DP_TIMEODDSLIMIT_CLEAR = '1051';
DP_TIMEODDSLIMIT = '1052';
DP_GAME_ODDS = '1053';
DP_CLIENT_UPDATE = '1054';

DP_ACH_CLEAR = '1055';
DP_ACH_GROUP = '1056';
DP_ACHIEVEMENT = '1057';
DP_ACH_USER = '1058';
DP_ACH_USER_INFO = '1059';
DP_ACH_USER_INFO_CLEAR = '1060';
DP_ACH_FINISHED = '1061';
DP_ACH_SEND_END = '1062';

DP_SERVER_WARNING = '1063';

DP_MEMBERSHIPTYPE_BEGIN = '1064';
DP_MEMBERSHIPTYPE = '1065';

DP_PROFILE_PAYMENT_BEGIN = '1066';
DP_PROFILE_PAYMENT = '1067';
DP_PROFILE_PAYMENT_END = '1068';

DP_URL_OPEN = '1069';
DP_ROLES = '1070';
DP_PROFILE_PAY_DATA = '1071';
DP_SPECIAL_OFFER = '1072';
DP_ONLINE_STATUS = '1073';
DP_PM_EXIT = '1074';
DP_AUTOUPDATE = '1075';
DP_GAME_QUIT = '1076';

SW_TRIAL_MEMBERSHIP = '0';
SW_END_MEMBERSHIP = '1';
SW_CORE_MEMBERSHIP = '2';

CMM_INITIALIZE = 1;
CMM_PHOTO = 2;
CMM_GET_ALL_PHOTO = 3;

DPM_INITIALIZED = '1';
DPM_PHOTO = '2';

ISSOCKETLOG = FALSE;

START_POSITION = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

EVENT_ON_TIMER_PERIOD = 1;

MAIL_PATTERN_DIR = 'pattern';

MAX_BAN_TIME = 24; // hours
UNLIMITED_BAN_TIME = 100000;

PHOTO_USER_DIR = 'img\photo\';
PHOTO_CLUB_DIR = 'img\club\';
MM_LOG_DIR = 'log\mm';
BANNERS_DIR = 'banners\';

//ADULT_ROOM_NUMBER = 3;

SERVER_ONLINE_INTERVAL = 60; // in seconds
SAVE_USERS_ONLINE_INTERVAL = 300; // in seconds

VERSION_NEW_MESSAGE_SYSTEM = '8.0ac';
VERSION_IMAGES = '8.0ac';
VERSION_ODDS = '8.0am';
VERSION_NEW_LOGIN_TRANSFER = '8.1ai';
ENGINE_PASSWORD = 'aj83za914liw';

var
  VERSION_CLIENT_UPDATE: string = '8.1an';
  { SQL constants }
  DB_PROVIDER: string = 'Provider=SQLOLEDB.1;Password="Nf6=Q";Persist Security Info=True;User ID=clsa;Initial Catalog=CLServer;Data Source=infiniachess';
  MAIN_DIR: string;
  ERR_LOG: string = 'errors.log';
  SOCKET_LOG: string = 'socket.log';
  DB_LOG: string = 'db.log';

  CHEAT_RED_MIN_MOVES: integer = 8;
  CHEAT_RED_KOEF: real = 0.5;
  CHEAT_YELLOW_DIFF: integer = 1;

  MIN_SUPPORTED_VER: string = '6.0';
  MAX_GAMES: integer = 5;
  MAX_GAMES_ENGINE: integer = 9999;

  SLVars: TStringList;
  WORKING_PORT: integer;

  LOGGING: Boolean = true;
  LOG_BUFFER_COUNT: integer = 1000;

  SL_DP_CODES: TStringList;

  MAIL_HOST: string = 'mail.infiniachess.com';
  MAIL_USER: string = 'registration';
  MAIL_PASSWORD: string = 'reg4infinia!';
  MAIL_PORT: integer = 25;
  MAIL_FROM_ADDRESS: string = 'registration@infiniachess.com';
  MAIL_FROM_NAME: string = 'Infinia Registration';

  AUTH_KEY_SEND: Boolean = true;

  SAVE_CHAT_LOG: Boolean = true;
  MAX_CHATLOG_LINES: integer = 150;

  PORT_MM: integer = 1025;
  MM_OPENED: Boolean = true;

  csERRLOG: TCriticalSection;
  csLAG_STAT: TCriticalSection;
  critDB: TCriticalSection;

  BAD_LAG_LIMIT: integer = 1000;

  LAST_PING_TIME: TDateTime;
  LAG_STAT_MEMORY_LIMIT: integer = 1000;

  MAX_NUMBER_OF_LOGINS_PER_MAC: integer = 2;

  AUTOSHOUTS: Boolean = true;

  AUTO_FORFEITS_TIME: Boolean = true;

  MODE_NOGAMES: Boolean = false;

  START_MESSAGE: string = '';
    {'Attention all users we will be moving the site to a new server within the next 24hrs. '+
    'If the server is down please understand we are doing this to improve the over all enjoyment of our site. '+
    'Look at www.infiniachess for information. Thank You in advance!';}

  ADMIN_GREETINGS: string = '';

  URL_OPEN_ADMINLEVEL: integer = 3; // if user's level >= of this value, he will not open infiniachess.com during login
  URL_START: string = '';
  URL_START_ADMIN: string = 'aaaa';
  //URL_START: string = 'www.infiniachess.com';
  //URL_START_ADMIN: string = 'http://www.infiniachess.com/vbulletin';
  URL_START_PERIOD: real = 24.0;

  ACH_ADMIN_LEVEL: integer = 3;

  ACH_SEND_BY_CLUSTERS: Boolean = false;
  BAD_COMMAND_TIME_LIMIT: integer = 1000;

  CONNECTION_ENCRYPTED: Boolean = true;
  CONNECTIONS_ALLOWED: integer = 9999;
  LAUNCH_MODE: TLaunchMode = lncService;

  MAIN_THREAD_ID: integer;
  DB_LOGGING: Boolean = true;
  DB_SAVEGAME_THREAD: Boolean = false;

  AUTOLOGOUT_TIME_MINUTES: integer = 120;
  IDLE_TIME_MINUTES: integer = 20;
  LAST_EXE_LINK: string = 'http://www.infiniachess.com/lastclient/chclient.exe';

  AUTOTIMEODDS_RATING_DIFF: integer = 200;

implementation

end.
