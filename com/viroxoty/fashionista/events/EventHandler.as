// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.events.EventHandler

package com.viroxoty.fashionista.events{
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.ui.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class EventHandler {

        public static const MESSAGE_CENTER_INIT:String = "MESSAGE_CENTER_INIT";
        public static const CLOSED_GIFT_CENTER:String = "CLOSED_GIFT_CENTER";

        private static var _instance:EventHandler;

        public function EventHandler(){
            Tracer.out("new EventHandler test");
            MainViewController.getInstance().addEventListener(MainViewController.OPENED_GIFT_CENTER, this.gift_center_opened);
            GiftingController.getInstance().addEventListener(CLOSED_GIFT_CENTER, this.gift_center_closed);
            MainViewController.getInstance().addEventListener(MainViewController.CLOSED_MESSAGE_CENTER, this.closed_welcome_back_popup);
            Tracer.out("EventHandler > added gift center listeners");
        }
        public static function getInstance():EventHandler{
            if (_instance == null)
            {
                _instance = new (EventHandler)();
            };
            return (_instance);
        }

        function gift_center_opened(_arg1=null){
            Tracer.out("EventHandler > gift_center_opened");
            MainViewController.getInstance().removeEventListener(MainViewController.OPENED_GIFT_CENTER, this.gift_center_opened);
        }
        function gift_center_closed(_arg1=null){
            Tracer.out("EventHandler > gift_center_closed");
            GiftingController.getInstance().removeEventListener(CLOSED_GIFT_CENTER, this.gift_center_closed);
            MessageCenter.getInstance().init_welcome();
        }
        function closed_welcome_back_popup(_arg1=null){
            Tracer.out("EventHandler > closed_welcome_back_popup");
            MainViewController.getInstance().removeEventListener(MainViewController.CLOSED_MESSAGE_CENTER, this.closed_welcome_back_popup);
            if (UserData.getInstance().check_show_3_day_reward())
            {
                MainViewController.getInstance().addEventListener(MainViewController.CLOSED_POPUP, this.closed_3_day_reward);
            } else
            {
                this.closed_3_day_reward();
            };
        }
        function closed_3_day_reward(_arg1=null){
            Tracer.out("EventHandler > closed_3_day_reward");
            MainViewController.getInstance().removeEventListener(MainViewController.CLOSED_POPUP, this.closed_3_day_reward);
            if ((((UserData.getInstance().visits > 2)) && (UserData.getInstance().check_show_look_of_the_day())))
            {
                MainViewController.getInstance().addEventListener(MainViewController.CLOSED_POPUP, this.closed_look_of_the_day);
                if (Main.getInstance().current_section == Constants.SECTION_MY_BOUTIQUE)
                {
                    MyBoutique.getInstance().hide_like_btn();
                };
            } else
            {
                this.closed_look_of_the_day();
            };
        }
        function closed_look_of_the_day(_arg1=null){
            Tracer.out("EventHandler > closed_look_of_the_day");
            MainViewController.getInstance().removeEventListener(MainViewController.CLOSED_POPUP, this.closed_look_of_the_day);
            if (MyBoutique.getInstance().check_show_welcome_back())
            {
                return;
            };
            if (Tracker.first_time_my_boutique_welcome)
            {
                Tracker.first_time_my_boutique_welcome = false;
                Tracker.first_time_my_boutique_start = false;
                PopupIntro.getInstance().display_popup(PopupIntro.MY_BOUTIQUE_START);
                Tracker.track(Tracker.CREATE, Tracker.FIRST_TIME_MY_BOUTIQUE);
            };
        }
        public function queue_my_boutique_start(){
            Tracer.out("EventHandler > queue_my_boutique_start");
            MainViewController.getInstance().addEventListener(MainViewController.CLOSED_POPUP, this.show_my_boutique_start);
        }
        function show_my_boutique_start(_arg1=null){
            Tracer.out("EventHandler > show_my_boutique_start");
            MainViewController.getInstance().removeEventListener(MainViewController.CLOSED_POPUP, this.show_my_boutique_start);
            Tracker.first_time_my_boutique_start = false;
            PopupIntro.getInstance().display_popup(PopupIntro.MY_BOUTIQUE_START);
        }
        public function queue_my_boutique_start_after_shopping(){
            Tracer.out("EventHandler > queue_my_boutique_start_after_shopping");
            PopupIntro.getInstance().addEventListener(PopupIntro.CLOSED_POPUP, this.show_my_boutique_start_after_shopping);
        }
        function show_my_boutique_start_after_shopping(_arg1=null){
            Tracer.out("EventHandler > show_my_boutique_start_after_shopping");
            PopupIntro.getInstance().removeEventListener(PopupIntro.CLOSED_POPUP, this.show_my_boutique_start_after_shopping);
            Tracker.first_time_my_boutique_start = false;
            PopupIntro.getInstance().display_popup(PopupIntro.MY_BOUTIQUE_START);
        }
        public function queue_shopping_tip(){
            Tracer.out("EventHandler > queue_shopping_tip");
            MainViewController.getInstance().addEventListener(MainViewController.CLOSED_POPUP, this.show_shopping_tip);
        }
        function show_shopping_tip(_arg1=null){
            Tracer.out("EventHandler > show_shopping_tip");
            MainViewController.getInstance().removeEventListener(MainViewController.CLOSED_POPUP, this.show_shopping_tip);
            PopupIntro.getInstance().display_popup(PopupIntro.SHOPPING_TIP);
        }

    }
}//package com.viroxoty.fashionista.events

