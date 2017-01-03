// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.Main

package com.viroxoty.fashionista{
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.main.MainViewController;
    import flash.events.Event;
    import com.viroxoty.fashionista.events.GameEvent;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import com.viroxoty.fashionista.boutique.*;
    import com.viroxoty.fashionista.events.*;
    import com.viroxoty.fashionista.ui.*;
    import com.viroxoty.fashionista.user_boutique.*;
    import flash.system.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;
    import com.adobe.crypto.*;
    import flash.external.*;
    import com.facebook.graph.*;

    public class Main extends MovieClip {

        public static var isProd:Boolean;
        private static var _instance:Main;

        public var dev_copy_btn:MovieClip;
        public var dev_hide_btn:MovieClip;
        var view:MainViewController;
        public var screen_controller:Object;
        public var current_section:String;
        var dataManager:DataManager;
        var paramsLoaded:Boolean = false;
        var parameters:Object;
        private var flashVars:Object;

        public function Main(){
            var url:String;
            var loc:* = undefined;
            super();
            _instance = this;
            Tracer.out((("Fashionista Faceoff version " + Constants.VERSION) + "\n"), false);
            this.dev_copy_btn.visible = false;
            this.dev_hide_btn.visible = false;
            Security.allowDomain("70.32.67.176");
            Security.allowDomain("fashionistafaceoff.com");
            Security.allowDomain("70.32.67.175");
            Security.allowDomain("dev-fashionistafaceoff.com");
            Security.allowDomain("205.186.151.24");
            Security.allowDomain("dev.viroxotystudios.com");
            Security.allowDomain("staging.viroxotystudios.com");
            Security.allowDomain("viroxotystudios.com");
			Security.allowDomain("viroxoty.com");
            /*try
            {
                loc = ExternalInterface.call("window.location.href.toString");
                url = String(loc);
            } catch(e:Error)
            {
                Tracer.out(("error caught: " + e));*/
                url = "https://viroxotystudios.com/testing/";
           // };
            Tracer.out(("url is " + url));
            Constants.createMainConstants(url, isProd);
            this.view = new MainViewController(this);
            this.dataManager = new DataManager(this);
            if (Constants.LOCAL)
            {
                DataManager.user_id = "100001484935108";
            };
            Tracer.out("start listening for flash vars");
            root.loaderInfo.addEventListener(Event.COMPLETE, this.loaderComplete);
            addEventListener(Event.ADDED_TO_STAGE, this.addedToStage, false, 0, true);
            if (Constants.LOCAL == false)
            {
                Tracer.out("Facebook.init");
                Facebook.init(Constants.APP_ID);
            };
        }
        public static function getInstance():Main{
            if (_instance == null)
            {
                _instance = new (Main)();
            };
            return (_instance);
        }

        private function loaderComplete(_arg1:Event):void{
            root.loaderInfo.removeEventListener(Event.COMPLETE, this.loaderComplete);
            Tracer.out("loader complete");
            this.flashVars = _arg1.target.parameters;
            if (stage != null)
            {
                Tracer.out("already added to stage, so processing flashVars");
                this.setParameters(this.parameters);
            } else
            {
                Tracer.out("not yet added to stage, hold on processing flashVars");
            };
        }
        private function addedToStage(_arg1:Event){
            Tracer.out("Main added to stage");
            removeEventListener(Event.ADDED_TO_STAGE, this.addedToStage);
            this.view.init();
            if (this.flashVars)
            {
                this.setParameters(this.flashVars);
            } else
            {
                Tracer.out("flashVars not yet loaded in, so doing that now");
                root.loaderInfo.removeEventListener(Event.COMPLETE, this.loaderComplete);
                this.setParameters(root.loaderInfo.parameters);
            };
        }
        private function setParameters(_arg1:Object):void{
            var _local2:String;
            var _local3:Object;
            var _local4:*;
            var _local5:String;
            var _local6:Array;
            var _local7:int;
            var _local8:int;
            var _local9:Boolean;
            this.paramsLoaded = true;
            Tracer.out("setting parameters");
            this.parameters = {};
            for (_local2 in _arg1)
            {
                _local9 = true;
                _local3 = _arg1[_local2];
                Tracer.out(((("  received " + _local2) + ": ") + _local3), false);
                this.parameters[_local2] = _local3;
                switch (_local2)
                {
                    case "user_id":
                        if (Constants.SERVERLOC == "prod")
                        {
                            Constants.DEBUG = false;
                            _local5 = String(_local3);
                            _local6 = ((Constants.USER_ISSUE_IDS) ? Constants.ADMIN_IDS.concat(Constants.USER_ISSUE_IDS) : Constants.ADMIN_IDS);
                            _local7 = _local6.length;
                            _local8 = 0;
                            while (_local8 < _local7)
                            {
                                if (_local5 == _local6[_local8])
                                {
                                    Constants.DEBUG = true;
                                    Constants.IS_ADMIN = true;
                                    this.setup_debug();
                                };
                                _local8++;
                            };
                        } else
                        {
                            Constants.IS_ADMIN = true;
                            this.setup_debug();
                        };
                        DataManager.user_id = String(_local3);
                        break;
                    case "debug_user_id":
                        DataManager.debug_user_id = String(_local3);
                        this.setup_debug();
                        break;
                    case "access_token":
                        _local4 = String(_local3);
                        DataManager.getInstance().client_key = MD5.hash((_local4 + Constants.SHARED_KEY));
                        break;
                    case "leveling_welcome":
                        UserData.getInstance().leveling_welcome = (String(_local3) == "true");
                        break;
                    case "offline_leveling_reward":
                        UserData.getInstance().offline_leveling_reward = int(_local3);
                        break;
                    case "birthday_flag":
                        UserData.getInstance().birthday_flag = true;
                        break;
                    case "fb_session":
                        DataManager.getInstance().fb_session = String(_local3);
                        break;
                    case "free_offer_item":
                        DataManager.getInstance().process_free_item(String(_local3));
                        break;
                    case "look_of_the_day":
                        LookOfTheDayController.getInstance().process_data(String(_local3));
                        break;
                    case "user_visits":
                        UserData.getInstance().set_visits(int(_local3));
                        if (int(_local3) == 1)
                        {
                            Tracker.track_first_time(Tracker.STARTUP);
                            MainViewController.getInstance().first_section = Constants.SECTION_CITY;
                            new FirstVisitEventHandler();
                        } else
                        {
                            MainViewController.getInstance().first_section = Constants.SECTION_MY_BOUTIQUE;
                            new EventHandler();
                        };
                        break;
                    case "daily_deal_item":
                        DataManager.getInstance().process_daily_deal_item(String(_local3));
                        break;
                    case "teams":
                        DataManager.getInstance().process_teams(String(_local3));
                        break;
                    case "paths":
                        Constants.process_paths(String(_local3));
                        break;
                };
            };
            if (_local9 == false)
            {
                Tracker.track(Tracker.NO_FLASHVARS);
            };
            Tracer.out(("leveling_welcome is " + UserData.getInstance().leveling_welcome));
            Tracer.out(("offline_leveling_reward is " + UserData.getInstance().offline_leveling_reward));
            this.startup();
        }
        public function startup():void{
            Tracker.track(Tracker.STARTUP);
            this.dataManager.get_startup_data();
            if (Constants.LOCAL != true)
            {
                External.set_callbacks();
            };
            this.view.startup();
        }
        public function set_section(_arg1:String, _arg2:Boolean=true){
            var _local3:String;
            var _local4:String;
            Tracer.out(("Main > set_section " + _arg1), false);
            if ((((((_arg1 == Constants.SECTION_BOUTIQUE)) && (UserData.getInstance().first_time_visit()))) && ((Tracker.first_time_boutique == false))))
            {
                Tracker.first_time_boutique = true;
                Tracker.track_first_time((Tracker.BOUTIQUE_FROM_ + this.current_section));
            };
            if (((UserData.getInstance().shopping_welcome) && ((this.current_section == Constants.SECTION_RUNWAY))))
            {
                PopupIntro.getInstance().display_popup(PopupIntro.SHOPPING_TIP);
            };
            this.current_section = _arg1;
            this.view.removePopups();
            this.view.removeNotifications();
            switch (this.current_section)
            {
                case Constants.SECTION_INTRO:
                    _local3 = Constants.INTRO_FILENAME;
                    break;
                case Constants.SECTION_MESSAGE_CENTER:
                    _local3 = Constants.MESSAGE_CENTER_FILENAME;
                    break;
                case Constants.SECTION_CITY:
                    TopMenu.getInstance().set_selected(Constants.SECTION_CITY);
                    _local3 = Constants.CITY_FILENAME;
                    CityManager.getInstance().current_city = 1;
                    break;
                case Constants.SECTION_PARIS:
                    TopMenu.getInstance().set_selected(null);
                    CityParis.getInstance().track_visit();
                    break;
                case Constants.SECTION_PARIS_ZOOM:
                    TopMenu.getInstance().set_selected(null);
                    CityParis.getInstance().track_visit();
                    break;
                case Constants.SECTION_BOUTIQUE:
                    TopMenu.getInstance().set_selected(null);
                    break;
                case Constants.SECTION_DRESSING_ROOM:
                    TopMenu.getInstance().set_selected(Constants.SECTION_DRESSING_ROOM);
                    break;
                case Constants.SECTION_RUNWAY:
                    TopMenu.getInstance().set_selected(Constants.SECTION_RUNWAY);
                    break;
                case Constants.SECTION_MY_BOUTIQUE:
                    TopMenu.getInstance().set_selected(Constants.SECTION_MY_BOUTIQUE);
                    break;
                case Constants.SECTION_BOUTIQUE_VISIT:
                    TopMenu.getInstance().set_selected(null);
                    break;
                case null:
                default:
                    TopMenu.getInstance().set_selected(null);
            };
            ContestantBar.getInstance().update_section();
            if (((_arg2) && (_local3)))
            {
                this.view.show_preloader();
                _local4 = ((Constants.SERVER_SWF + _local3) + ".swf");
                this.view.load_swf(_local4);
            };
        }
        public function init_screen_controller():void{
            var _local2:Boolean;
            var _local1:Boolean = true;
            switch (this.current_section)
            {
                case Constants.SECTION_CITY:
                    this.screen_controller = CityNewYork.getInstance();
                    break;
                case Constants.SECTION_PARIS:
                    this.screen_controller = CityParis.getInstance();
                    break;
                case Constants.SECTION_BOUTIQUE:
                    this.screen_controller = BoutiqueManager.getInstance().enable_boutique();
                    _local1 = false;
                    break;
                case Constants.SECTION_DRESSING_ROOM:
                    this.screen_controller = DressingRoom.getCurrentInstance();
                    _local2 = true;
                    break;
                case Constants.SECTION_RUNWAY:
                    this.screen_controller = Runway.getInstance();
                    break;
                case Constants.SECTION_MY_BOUTIQUE:
                    this.screen_controller = MyBoutique.getInstance();
                    break;
                case Constants.SECTION_BOUTIQUE_VISIT:
                    this.screen_controller = BoutiqueVisit.getInstance();
                    break;
            };
            if (this.screen_controller)
            {
                if (_local2)
                {
                    this.screen_controller.addEventListener(Events.GAME_EVENT, this.handle_game_event);
                };
                if (_local1)
                {
                    this.screen_controller.init();
                };
            };
        }
        public function destroy_screen_controller():void{
            if (this.screen_controller)
            {
                if (this.screen_controller.hasOwnProperty("removeEventListener"))
                {
                    this.screen_controller.removeEventListener(Events.GAME_EVENT, this.handle_game_event);
                };
                if (this.screen_controller.hasOwnProperty("destroy"))
                {
                    this.screen_controller.destroy();
                };
                this.screen_controller = null;
            };
        }
        function handle_game_event(_arg1:GameEvent):void{
            Tracer.out(("Main > handle_game_event : " + _arg1.code), false);
            dispatchEvent(_arg1);
        }
        function setup_debug():void{
            if (Constants.DEV_BOUTIQUE_IMAGE_MODE)
            {
                return;
            };
            this.dev_copy_btn.visible = true;
            this.dev_copy_btn.addEventListener(MouseEvent.CLICK, this.copy_dev_output, false, 0, true);
            this.dev_hide_btn.visible = true;
            this.dev_hide_btn.addEventListener(MouseEvent.CLICK, this.hide_dev_btns, false, 0, true);
            addChild(this.dev_copy_btn);
            addChild(this.dev_hide_btn);
            addChild(new FPSCounter());
        }
        function hide_dev_btns(_arg1:MouseEvent){
            this.dev_copy_btn.visible = false;
            this.dev_hide_btn.visible = false;
        }
        private function copy_dev_output(_arg1:MouseEvent):void{
            System.setClipboard(Tracer.getOutput());
        }

    }
}//package com.viroxoty.fashionista

