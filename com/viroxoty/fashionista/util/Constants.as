// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.util.Constants

package com.viroxoty.fashionista.util{
    import flash.system.*;
    import com.adobe.serialization.json.*;

    public class Constants {

        public static const DEV_VERBOSE_OUTPUT:Boolean = true;
        public static const DEV_BOUTIQUE_IMAGE_MODE:Boolean = false;
        public static const DEV_FRESH_DAILY_VISIT_MODE:Boolean = false;
        public static const SHOW_FREE_ITEM:Boolean = true;
        public static const ADMIN_IDS:Array = ["625008472", "680114583", "100001484935108", "100001847112723", "100001629937553", "100001714393434", "100002114011208", "100001446415635", "100001708686352", "1299241415", "100002926004257", "100002273782481","10206340686015170","10208474744325294"];
        public static const USER_ISSUE_IDS:Array = [];
        public static const MUTE_IDS:Array = ["100001484935108", "100001847112723", "100001629937553"];
        public static const PRELOADER_SWF:String = "preloader_1_20.swf";
        public static const INTRO_FILENAME:String = "intro_4_5";
        public static const GAME_ASSETS_FILENAME:String = "game_assets_4_13";
        public static const AVATAR_SWF:String = "avatar_3_22.swf";
        public static const MESSAGE_CENTER_FILENAME:String = "message_center_3_29";
        public static const TOP_MENU_SWF:String = "topMenu_4_11.swf";
        public static const CONTESTANT_BAR_SWF:String = "contestantBar_2_16.swf";
        public static const POPUPS_FILENAME:String = "popups_4_18";
        public static const POPUPS_INTRO_FILENAME:String = "popups_intro_2_7";
        public static const POPUPS_SPONSORED_ITEM_FILENAME:String = "popup_sponsored_items_4_25";
        public static const NOTIFICATION_FILENAME:String = "notifications_4_11";
        public static const SNAPSHOT_FILENAME:String = "snapshot_3_22";
        public static const DECOR_BROWSER_FILENAME:String = "decor_browser_12_30";
        public static const GIFTING_FILENAME:String = "gifting";
        public static const CLEANUP_FILENAME:String = "cleanup";
        public static const CITY_FILENAME:String = "city_10_26";
        public static const PARIS_FILENAME:String = "paris_2_1";
        public static const PARIS_ZOOM_FILENAME:String = "paris_zoom_2_1";
        public static const BOUTIQUE_FILENAME:String = "boutique_4_10";
        public static const RUNWAY_FILENAME:String = "runway_3_14";
        public static const USER_BOUTIQUE_FILENAME:String = "user_boutique_4_17";
        public static const DRESSING_ROOM_FILENAME:String = USER_BOUTIQUE_FILENAME;//"user_boutique_4_17"
        public static const SHARED_KEY:String = "8ece49d7d6ec14ac32c4855b52a4390d";
        public static const FB_PIC_URL:String = "https://graph.facebook.com/ID/picture?type=square";
        public static const FB_PROFILE_URL_BASE:String = "http://www.facebook.com/profile.php?id=ID";
        public static const FCASH_TO_FB_CREDIT:int = 100;
        public static const STARTING_CASH:int = 2000;
        public static const PARIS_LEVEL:int = 2;
        public static const PARIS_POINTS:int = 2000;
        public static const TOP_LOOKS_COUNT:int = 50;
        public static const FIRSTIE_VISIT_COUNT:int = 1;
        public static const BEST_DRESSED_DELAY_SECS:int = 45;
        public static const INTRO_LENGTH:int = 31000;
        public static const BEST_DRESSED_REWARD:int = 10;
        public static const MINI_LEVEL_REWARD:int = 10;
        public static const LEVEL_UP_REWARD:int = 25;
        public static const A_LIST_ADD_REWARD:int = 2;
        public static const THREE_DAY_REWARD:int = 30;
        public static const ENTER_LOOK_REWARD:int = 5;
        public static const JOIN_TEAM_REWARD:int = 100;
        public static const FACEOFF_REWARD:int = 5;
        public static const TUTORIAL_END_REWARD:int = 100;
        public static const START_MY_BOUTIQUE_REWARD:int = 1000;
        public static const FIRST_USER_BOUTIQUE_VISIT_REWARD:int = 25;
        public static const VOTE_REWARD:int = 1;
        public static const CLEANUP_REWARD:int = 10;
        public static const TOTAL_DAILY_CLEANUP_REWARD:int = 210;
        public static const REASON_COMPLETE_TUTORIAL:String = "complete_tutorial";
        public static const REASON_START_MY_BOUTIQUE:String = "start_my_boutique";
        public static const REASON_CLEANUP_REWARD:String = "cleanup_reward";
        public static const XP_CODE_FIRST_USER_BOUTIQUE_VISIT:int = 1000;
        public static const RESTRICTION_UNBUYABLE:String = "1";
        public static const RESTRICTION_HIDDEN:String = "2";
        public static const REQUEST_PERFUME_GIFT:String = "perfume_gift";
        public static const REQUEST_DECOR_GIFT:String = "decor_gift";
        public static const REQUEST_ITEM_GIFT:String = "item_gift";
        public static const REQUEST_FREE_ITEM:String = "free_item";
        public static const COST_A_LIST_INVITE:int = 100;
        public static const COST_BUY_VOTE:int = 1;
        public static const BOUTIQUE_INFINITY:String = "infinity_salon";
        public static const SECTION_INTRO:String = "intro";
        public static const SECTION_CITY:String = "city";
        public static const SECTION_RUNWAY:String = "runway";
        public static const SECTION_DRESSING_ROOM:String = "dressing_room";
        public static const SECTION_PARIS:String = "paris";
        public static const SECTION_PARIS_ZOOM:String = "paris_zoom";
        public static const SECTION_BOUTIQUE:String = "boutique";
        public static const SECTION_MESSAGE_CENTER:String = "message_center";
        public static const SECTION_MY_BOUTIQUE:String = "my_boutique";
        public static const SECTION_BOUTIQUE_VISIT:String = "boutique_visit";
        public static const FRAME_RATE:int = 12;
        public static const CITY_DURATION:int = 11962;
        public static const CITY_MUSIC:String = "FFCity_aud.mp3";
        public static const PARIS_MUSIC:String = "ParisLoop.mp3";
        public static const RUNWAY_DURATION:int = 15306;
        public static const RUNWAY_MUSIC:String = "FFRunwayLoop.mp3";
        public static const RUNWAY_SOUND_FX:String = "camera.mp3";
        public static const RUNWAY_SOUND_FX_VOLUME:Number = 0.3;
        public static const DRESSING_ROOM_DURATION:int = 30746;
        public static const DRESSING_ROOM_MUSIC:String = "FFDressingRoomLoop.mp3";
        public static const SCREEN_WIDTH:int = 760;
        public static const SCREEN_HEIGHT:int = 690;
        public static const TOP_UI_HEIGHT:int = 70;
        public static const GAME_SCREEN_HEIGHT:int = 485;
        public static const BOTTOM_BAR_HEIGHT:int = 135;

        public static var VERSION:String = "4/18";
        public static var LOCAL:Boolean;
        public static var DEBUG:Boolean = true;
        public static var IS_ADMIN:Boolean = false;
        public static var APP_ID:String;
        public static var APP_NAME:String;
        public static var FACEBOOK_APP_PAGE:String;
        public static var TOP_PAGE_URL:String;
        public static var START_TIME:Number;
        public static var SERVER_MUSIC:String;
        public static var PROTOCOL:String;
        public static var SERVERLOC:String;
        public static var APP_SERVER:String;
        public static var SERVER_JSON:String;
        public static var SERVER_SERVICES:String;
        public static var SERVER_XML:String;
        public static var RESOURCE_SERVER:String;
        public static var SERVER_SWF:String;
        public static var SERVER_BOUTIQUE_ITEMS:String;
        public static var SERVER_IMAGES:String;
        public static var SERVER_LOOKS:String;
        public static var SERVER_ITEM_IMAGES:String;
        public static var SERVER_DECOR:String;
        public static var SERVER_DECOR_IMAGES:String;
        public static var UGC_SERVER:String;
        public static var UGC_SERVER_IMAGES:String;
        public static var JOEL_URL:String;
        public static var FB_PROFILE_URL:String;
        public static var IMAGE_ADD_FLOOR:String;
        public static var SUPER_REWARDS_APP_ID:String;
        public static var SUPER_REWARDS_SECERT:String;
        public static var DEALSPOT_URL:String;
		public static var FACEBOOK_IMAGE_URL:String;

        public static function createMainConstants(_arg1:String, _arg2:Boolean):void{
            var _local3:String;
            var _local4:String;
            if ((((Capabilities.playerType == "PlugIn")) || ((Capabilities.playerType == "ActiveX"))))
            {
                LOCAL = false;
            } else
            {
                LOCAL = true;
            };
            var _local5:Array = _arg1.split("://");
            PROTOCOL = (_local5[0] + "://");
            Tracer.out(((("Constants > init : LOCAL is " + LOCAL) + ", PROTOCOL is ") + PROTOCOL));
            if (LOCAL)
            {
                Tracer.out(("Constants > init : running locally, isProd = " + _arg2));
                SERVERLOC = "local";
                if (_arg2)
                {
                    _local3 = "viroxotystudios.com";
                    _local4 = "viroxotygames.com";
                } else
                {
                    _local3 = "dev.viroxotystudios.com";
                    _local4 = "dev.viroxotygames.com";
                };
                FACEBOOK_APP_PAGE = (PROTOCOL + "apps.facebook.com/dev-fashionista");
                APP_ID = "273488505695";
                APP_NAME = "dev-fashionista";
            } else
            {
                if ((((_arg1.indexOf("dev.viroxotystudios.com") > -1)) || ((_arg1.indexOf("dev.viroxotygames.com") > -1))))
                {
                    Tracer.out("Constants > init : dev is true");
                    SERVERLOC = "dev";
                    _local3 = "dev.viroxotystudios.com";
                    _local4 = "dev.viroxotygames.com";
                    FACEBOOK_APP_PAGE = (PROTOCOL + "apps.facebook.com/dev-fashionista");
                    APP_ID = "273488505695";
                    APP_NAME = "dev-fashionista";
                    SUPER_REWARDS_APP_ID = "gkohlxgighg.243228446444";
                    SUPER_REWARDS_SECERT = "3d738d851ac3b07e0edd27ba9c3827c3";
                } else
                {
                    if ((((_arg1.indexOf("staging.viroxotystudios.com") > -1)) || ((_arg1.indexOf("staging.viroxotygames.com") > -1))))
                    {
                        Tracer.out("Constants > init : staging is true");
                        SERVERLOC = "staging";
                        _local3 = "staging.viroxotystudios.com";
                        _local4 = "staging.viroxotygames.com";
                        FACEBOOK_APP_PAGE = (PROTOCOL + "apps.facebook.com/staging-fashionista");
                        APP_ID = "201044623254995";
                        APP_NAME = "staging-fashionista";
                        SUPER_REWARDS_APP_ID = "gkohpxgighi.243372419377";
                        SUPER_REWARDS_SECERT = "eaaa048da4baae0548a84c888ffac563";
                    } else
                    {
                        if ((((_arg1.indexOf("viroxotystudios.com") > -1)) || ((_arg1.indexOf("viroxotygames.com") > -1))))
                        {
                            Tracer.out("Constants > init : prod is true");
                            SERVERLOC = "prod";
                            _local3 = "viroxotystudios.com";
                            _local4 = "viroxotygames.com";
                            FACEBOOK_APP_PAGE = (PROTOCOL + "apps.facebook.com/fashionista-faceoff");
                            APP_ID = "135555983142945";
                            APP_NAME = "fashionista_faceoff";
                            SUPER_REWARDS_APP_ID = "nmunzgmlgk.24622913405";
                            SUPER_REWARDS_SECERT = "f0557451768f4f80f222c0114e200f2d";
                        };
                    };
                };
            };
            var _local6:* = ((PROTOCOL + _local3) + "/");
            var _local7:* = ((PROTOCOL + _local4) + "/");
            TOP_PAGE_URL = (FACEBOOK_APP_PAGE + "/index.php?page=master.php&tab=");
            APP_SERVER = (_local6 + "testing/");
            UGC_SERVER = APP_SERVER;
            RESOURCE_SERVER = (_local7 + "fashionista/");
            Tracer.out(((("Constants > createConstants : APP_SERVER is " + APP_SERVER) + ", RESOURCE_SERVER is ") + RESOURCE_SERVER));
            SERVER_SERVICES = (_local6 + "services/");
            SERVER_JSON = (APP_SERVER + "json/");
            SERVER_XML = (APP_SERVER + "xml/");
            SERVER_SWF = (RESOURCE_SERVER + "swf/");
            SERVER_BOUTIQUE_ITEMS = (SERVER_SWF + "boutique_items/");
            SERVER_MUSIC = (RESOURCE_SERVER + "music/");
            SERVER_IMAGES = (RESOURCE_SERVER + "images/");
            SERVER_LOOKS = (SERVER_IMAGES + "Looks/");
            SERVER_ITEM_IMAGES = (SERVER_IMAGES + "product_png/");
            SERVER_DECOR_IMAGES = (SERVER_IMAGES + "decor/");
            IMAGE_ADD_FLOOR = (SERVER_IMAGES + "add_floor.png");
            UGC_SERVER_IMAGES = (UGC_SERVER + "images/");
            JOEL_URL = (PROTOCOL + "www.facebook.com/pages/Joel-Goodrich/130889340293728");
            FB_PROFILE_URL = (PROTOCOL + "www.facebook.com/profile.php?id=");
            DEALSPOT_URL = (PROTOCOL + (((PROTOCOL)=="https://") ? "s-assets.tp-cdn.com/static3/swf/dealspot.swf" : "assets.tp-cdn.com/static3/swf/dealspot.swf"));
            update_start_time();
        }
        public static function process_paths(_arg1:String):void{
            var _local2:Object = Json.decode(_arg1);
            SERVER_DECOR = ((RESOURCE_SERVER + _local2.decor.swfDir) + "/");
            Tracer.out(("SERVER_DECOR = " + SERVER_DECOR));
        }
        public static function update_start_time():void{
            var _local1:Date = new Date();
            START_TIME = _local1.time;
        }
        public static function fb_pic_for_id(_arg1:String):String{
            return (Util.replace("ID", _arg1, FB_PIC_URL));
        }
        public static function fb_profile_for_id(_arg1:String):String{
            return (Util.replace("ID", _arg1, FB_PROFILE_URL_BASE));
        }
        public static function convertFcashToFBCredits(_arg1:int):int{
            return (Math.max(1, Math.floor((_arg1 / Constants.FCASH_TO_FB_CREDIT))));
        }

    }
}//package com.viroxoty.fashionista.util

