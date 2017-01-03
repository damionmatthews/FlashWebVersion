// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.Tracker

package com.viroxoty.fashionista{
    public class Tracker {

        public static const FIRST_TIME:String = "first_time";
        public static const INTRO:String = "intro";
        public static const A_LIST:String = "a_list";
        public static const FACEOFF:String = "faceoff";
        public static const MY_BOUTIQUE:String = "my_boutique";
        public static const FIRST_TIME_MY_BOUTIQUE:String = "first_time_my_boutique";
        public static const NO_FLASHVARS:String = "no_flashvars";
        public static const STARTUP:String = "startup";
        public static const VISIT:String = "visit";
        public static const WIN:String = "win";
        public static const GIVE_FREE_ITEM:String = "give_free_item";
        public static const OPEN_GIFT_CENTER:String = "open_gift_center";
        public static const PLAY_GAME:String = "play_game";
        public static const INTRO_COMPLETE:String = "intro_complete";
        public static const OKAY:String = "okay";
        public static const GET_DRESSED:String = "get_dressed";
        public static const OPEN_CLOSET:String = "open_closet";
        public static const OPEN_HAIR_MAKEUP:String = "open_hair_makeup";
        public static const ADD_MORE_ITEMS:String = "add_more_items";
        public static const ENTER_CONTEST:String = "enter_contest";
        public static const SKIP_PUBLISH:String = "skip_publish";
        public static const SHARE_LOOK:String = "share_look";
        public static const VOTE:String = "vote";
        public static const SHOPPING_WELCOME:String = "shopping_welcome";
        public static const TUTORIAL_END:String = "tutorial_end";
        public static const CREATE:String = "create";
        public static const CLICK_DRESS:String = "click_dress";
        public static const CLICK_DECORATE:String = "click_decorate";
        public static const LAUNCH:String = "launch";
        public static const CLICK_WALL_FLOOR:String = "click_wall_floor";
        public static const PURCHASE_WALL_FLOOR:String = "purchase_wall_floor";
        public static const CLICK_DECOR:String = "click_decor";
        public static const PURCHASE_DECOR:String = "purchase_decor";
        public static const PLACE_DECOR:String = "place_decor";
        public static const BOUTIQUE_FROM_:String = "boutique_from_";
        public static const BUY_ITEM:String = "buy_item";

        public static var first_time_closet:Boolean = false;
        public static var first_time_hair_makeup:Boolean = false;
        public static var first_time_add_more_items:Boolean = false;
        public static var first_time_enter_look:Boolean = false;
        public static var first_time_share:Boolean = false;
        public static var first_time_skip:Boolean = false;
        public static var first_time_vote:Boolean = false;
        public static var first_time_boutique:Boolean = false;
        public static var first_time_catalog:Boolean = false;
        public static var first_time_buy_item:Boolean = false;
        public static var first_time_shopping_welcome:Boolean = false;
        public static var first_time_tutorial_end:Boolean = false;
        public static var first_time_my_boutique_welcome:Boolean = false;
        public static var first_time_my_boutique_start:Boolean = false;
        public static var first_time_my_boutique_closet:Boolean = false;
        public static var first_time_my_boutique_decor_browser_interaction:Boolean = false;
        public static var first_time_my_boutique_click_decor:Boolean = false;
        public static var first_time_my_boutique_click_wall_floor:Boolean = false;
        public static var first_time_my_boutique_buy_wall_floor:Boolean = false;
        public static var first_time_my_boutique_buy_decor:Boolean = false;
        public static var first_time_my_boutique_place_decor:Boolean = false;
        public static var first_time_my_boutique_launch:Boolean = false;
        public static var first_time_my_boutique_session:Boolean = false;
        public static var first_time_my_boutique_model_init:Boolean = false;
        public static var shown_my_boutique_welcome_back:Boolean = false;
        public static var deleted_message_daily_deal:Boolean = false;
        public static var deleted_message_daily_free_item:Boolean = false;
        public static var deleted_message_join_team:Boolean = false;
        public static var deleted_message_boutique:Boolean = false;
        public static var deleted_message_fashion_earnings:Boolean = false;

        public static function track(_arg1:String, _arg2:String=null){
            DataManager.getInstance().track_game_event(_arg1, _arg2);
        }
        public static function track_first_time(_arg1:String){
            if (UserData.getInstance().first_time_visit())
            {
                track(_arg1, FIRST_TIME);
            };
        }
        public static function set_my_boutique_flags(){
            first_time_my_boutique_welcome = true;
            first_time_my_boutique_start = true;
            first_time_my_boutique_closet = true;
            first_time_my_boutique_decor_browser_interaction = true;
            first_time_my_boutique_click_decor = true;
            first_time_my_boutique_click_wall_floor = true;
            first_time_my_boutique_buy_decor = true;
            first_time_my_boutique_buy_wall_floor = true;
            first_time_my_boutique_place_decor = true;
            first_time_my_boutique_launch = true;
            first_time_my_boutique_session = true;
            first_time_my_boutique_model_init = true;
        }

    }
}//package com.viroxoty.fashionista

