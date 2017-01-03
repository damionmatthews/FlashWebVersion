// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.main.MainViewController

package com.viroxoty.fashionista.main{
    import flash.events.EventDispatcher;
    import com.viroxoty.fashionista.Main;
    import flash.display.MovieClip;
    import flash.system.ApplicationDomain;
    import flash.display.Sprite;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.utils.Timer;
    import com.viroxoty.fashionista.BackGroundMusic;
    import flash.events.Event;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import com.viroxoty.fashionista.Intro;
    import flash.display.DisplayObject;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import flash.text.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.sound.*;
    import com.viroxoty.fashionista.asset.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.util.*;

    public class MainViewController extends EventDispatcher {

        public static const FIRST_SCREEN_READY:String = "FIRST_SCREEN_READY";
        public static const CLOSED_POPUP:String = "CLOSED_POPUP";
        public static const CLOSED_MESSAGE_CENTER:String = "CLOSED_MESSAGE_CENTER";
        public static const OPENED_MESSAGE_CENTER:String = "OPENED_MESSAGE_CENTER";
        public static const OPENED_GIFT_CENTER:String = "OPENED_GIFT_CENTER";

        private static var _instance:MainViewController;

        var main:Main;
        private var swf_filename:String;
        public var first_section:String;
        public var screen:MovieClip;
        public var intro_screen:MovieClip;
        public var welcome_mgs_flag:Boolean;
        public var city_data_ready:Boolean = false;
        private var game_assets_domain:ApplicationDomain;
        public var free_item_popup_pending:Boolean;
        public var intro_container:Sprite;
        public var main_container:Sprite;
        public var cleanup_container:Sprite;
        public var header_container:Sprite;
        public var footer_container:Sprite;
        private var pre_loader_container:Sprite;
        public var message_center_container:Sprite;
        public var snapshot_container:Sprite;
        public var notification_container:Sprite;
        public var pop_up_blocker:Sprite;
        public var pop_up_container:Sprite;
        public var level_up_container:Sprite;
        public var specials_container:Sprite;
        public var game_element_container:Sprite;
        public var ui_container:Sprite;
        public var tip_container:MovieClip;
        public var swf_blocker:Sprite;
        public var top_bottom_blocker:Sprite;
        private var swf_loader:Loader;
        private var url_request:URLRequest;
        private var first_screen_loader:Loader;
        private var pre_loader:Loader;
        private var main_container_start_y:Number = 70;
        private var footer_container_start_y:int = 555;
        var intro_timer:Timer;
        var pausedClips:Array;
        public var bVideoPlayed:Boolean = false;

        public function MainViewController(_arg1:Main){
            _instance = this;
            this.main = _arg1;
            this.pre_loader_container = new Sprite();
            this.main.addChild(this.pre_loader_container);
            this.load_preloader();
        }
        public static function getInstance():MainViewController{
            return (_instance);
        }

        public function init():void{
            this.main_container = new Sprite();
            this.main_container.y = this.main_container_start_y;
            this.cleanup_container = new Sprite();
            this.cleanup_container.y = this.main_container_start_y;
            this.header_container = new Sprite();
            this.header_container.alpha = 0;
            this.game_element_container = new Sprite();
            this.game_element_container.y = this.main_container_start_y;
            this.footer_container = new Sprite();
            this.footer_container.y = this.footer_container_start_y;
            this.footer_container.alpha = 0;
            this.specials_container = new Sprite();
            this.notification_container = new Sprite();
            this.pop_up_blocker = new Sprite();
            this.pop_up_blocker.graphics.beginFill(0, 0.3);
            this.pop_up_blocker.graphics.drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT);
            this.pop_up_blocker.visible = false;
            this.pop_up_container = new Sprite();
            this.level_up_container = new Sprite();
            this.intro_container = new Sprite();
            this.snapshot_container = new Sprite();
            this.snapshot_container.y = this.main_container_start_y;
            this.message_center_container = new Sprite();
            this.message_center_container.visible = false;
            this.ui_container = new Sprite();
            this.tip_container = new MovieClip();
            this.top_bottom_blocker = new Sprite();
            var _local2 = this.top_bottom_blocker.graphics;
            with (_local2)
            {
                beginFill(0, 0.4);
                drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.TOP_UI_HEIGHT);
                endFill();
                beginFill(0, 0.4);
                drawRect(0, (Constants.TOP_UI_HEIGHT + Constants.GAME_SCREEN_HEIGHT), Constants.SCREEN_WIDTH, Constants.BOTTOM_BAR_HEIGHT);
                endFill();
            };
            this.top_bottom_blocker.visible = false;
            this.swf_blocker = new Sprite();
            _local2 = this.swf_blocker.graphics;
            with (_local2)
            {
                beginFill(0, 0.4);
                drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT);
                endFill();
            };
            this.swf_blocker.visible = false;
            _local2 = this.main;
            with (_local2)
            {
                addChild(main_container);
                addChild(cleanup_container);
                addChild(footer_container);
                addChild(header_container);
                addChild(intro_container);
                addChild(message_center_container);
                addChild(snapshot_container);
                addChild(pop_up_blocker);
                addChild(pop_up_container);
                addChild(level_up_container);
                addChild(specials_container);
                addChild(game_element_container);
                addChild(notification_container);
                addChild(ui_container);
                addChild(tip_container);
                addChild(top_bottom_blocker);
                addChild(swf_blocker);
            };
            if (UserData.getInstance().visits < 2)
            {
                this.bVideoPlayed = false;
            } else
            {
                this.bVideoPlayed = true;
            };
            trace(("bVideoPlayed   " + this.bVideoPlayed));
            var n:int = this.main.getChildIndex(this.message_center_container);
            this.main.addChildAt(this.pre_loader_container, n);
        }
        public function startup():void{
            Tracer.out("MainViewController > startup");
            var _local1:BackGroundMusic = BackGroundMusic.getInstance();
            this.main.set_section(Constants.SECTION_INTRO);
            this.main_container.visible = false;
            if (UserData.getInstance().first_time_visit())
            {
                PopupIntro.getInstance().load_swf();
                AvatarController.getInstance().preload_avatar_mc();
            } else
            {
                Pop_Up.getInstance().load_popups();
            };
            this.load_game_assets();
        }
        public function load_preloader():void{
            this.pre_loader = new Loader();
            var _local1:URLRequest = new URLRequest((Constants.SERVER_SWF + Constants.PRELOADER_SWF));
            this.pre_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.preloader_complete);
            this.pre_loader.load(_local1);
        }
        public function preloader_complete(_arg1:Event):void{
            Tracer.out("preloader_complete");
            this.pre_loader_container.addChild(_arg1.currentTarget.content);
            this.show_preloader();
        }
        public function show_preloader():void{
            if (this.pre_loader_container.numChildren > 0)
            {
                MovieClip(this.pre_loader_container.getChildAt(0)).preLoaderClip.pre_txt.text = "";
                this.pre_loader_container.visible = true;
            };
        }
        public function hide_preloader():void{
            this.pre_loader_container.visible = false;
        }
        public function initial_load_first_screen():void{
            Tracer.out(("MainViewController > initial_load_first_screen: " + this.first_section));
            if ((((this.main.current_section == "intro")) && ((this.intro_container.numChildren == 0))))
            {
                Tracer.out("   intro not loaded yet, waiting to load first screen");
                return;
            };
            var _local1:String = (((this.first_section)==Constants.SECTION_MY_BOUTIQUE) ? Constants.USER_BOUTIQUE_FILENAME : Constants.CITY_FILENAME);
            var _local2:URLRequest = new URLRequest(((Constants.SERVER_SWF + _local1) + ".swf"));
            this.first_screen_loader = new Loader();
            this.first_screen_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.swf_loaded);
            this.first_screen_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.swf_io_error);
            this.first_screen_loader.contentLoaderInfo.addEventListener(Event.INIT, this.swf_init);
            this.first_screen_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.swf_progress);
            this.first_screen_loader.load(_local2);
        }
        public function load_swf(_arg1:String):void{
            Tracer.out(("load_swf " + _arg1));
            this.swf_filename = _arg1;
            this.swf_loader = new Loader();
            this.url_request = new URLRequest(_arg1);
            this.swf_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.swf_io_error);
            this.swf_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.swf_progress);
            this.swf_loader.contentLoaderInfo.addEventListener(Event.INIT, this.swf_init);
            this.swf_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.swf_loaded);
            this.swf_loader.load(this.url_request);
        }
        public function load_asset(_arg1:String, _arg2:Function):void{
            var _local3 = ((Constants.SERVER_SWF + _arg1) + ".swf");
            var _local4:Object = {"assetLoaded":_arg2};
            var _local5:AssetDataObject = new AssetDataObject();
            _local5.parseURL(_local3);
            AssetManager.getInstance().getAssetFor(_local5, _local4);
            TopMenu.getInstance().set_inactive();
        }
        private function swf_progress(_arg1:ProgressEvent):void{
            var _local2 = (Math.floor(((_arg1.bytesLoaded / _arg1.bytesTotal) * 100)) + "%");
            if (this.pre_loader_container.numChildren > 0)
            {
                MovieClip(this.pre_loader_container.getChildAt(0)).preLoaderClip.pre_txt.text = _local2;
            };
        }
        private function swf_io_error(_arg1:IOErrorEvent):void{
            Tracer.out(("swf_io_error event: " + _arg1));
        }
        private function swf_init(_arg1:Event):void{
            MovieClip(_arg1.currentTarget.content).stop();
        }
        function preload_first_screen_swfs():void{
            this.initial_load_first_screen();
            MessageCenter.getInstance().load_swf();
            TopMenu.getInstance().load_swf();
            ContestantBar.getInstance().load_swf();
        }
        private function swf_loaded(evt:Event):void{
            var b1:Sprite;
            var intro_obj:Intro;
            LoaderInfo(evt.currentTarget).loader.removeEventListener(Event.COMPLETE, this.swf_loaded);
            var url:String = LoaderInfo(evt.currentTarget).url;
            Tracer.out(("swf_loaded : " + url));
            this.hide_preloader();
            if (this.main.current_section == "intro")
            {
                if (this.intro_container.numChildren == 0)
                {
                    DataManager.getInstance().track_game_event("initial_visit", "Intro");
                    this.intro_screen = evt.currentTarget.content;
                    b1 = new Sprite();
                    b1.graphics.beginFill(16751052, 1);
                    b1.graphics.drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT);
                    this.main.addChildAt(b1, 0);
                    this.intro_screen.y = 45;
                    this.intro_timer = new Timer(Constants.INTRO_LENGTH, 1);
                    this.intro_timer.addEventListener(TimerEvent.TIMER, this.intro_complete, false, 0, true);
                    this.intro_timer.start();
                    this.intro_container.addChild(this.intro_screen);
                    intro_obj = new Intro();
                    Tracer.out("> loaded intro.swf");
                    this.intro_screen.play();
                    this.main_container.visible = false;
                    this.header_container.visible = false;
                    this.footer_container.visible = false;
                    this.preload_first_screen_swfs();
                    this.intro_screen.alpha = 0;
                    Tweener.addTween(this.intro_screen, {
                        "alpha":1,
                        "time":1,
                        "transition":"easeinoutsine",
                        "onComplete":function (){
                        }
                    });
                    return;
                };
                this.screen = evt.currentTarget.content;
                this.screen.alpha = 0;
                Tracer.out("> loaded first screen in background");
                this.main_container.addChild(this.screen);
                this.first_screen_loader.unload();
                this.first_screen_loader = null;
                return;
            };
            if (LoaderInfo(evt.currentTarget).loader == this.first_screen_loader)
            {
                this.screen = evt.currentTarget.content;
                this.main_container.addChild(this.screen);
                this.screen.alpha = 0;
                this.check_first_screen_swfs();
                return;
            };
            if (url.split("/")[(url.split("/").length - 1)] != this.swf_filename.split("/")[(this.swf_filename.split("/").length - 1)])
            {
                Tracer.out((((("   url " + url) + " doesn't match latest swf filename ") + this.swf_filename) + "; ignoring"));
                return;
            };
            if (url.indexOf("intro") > -1)
            {
                Tracer.out((("   intro swf loaded, but current_section is " + this.main.current_section) + "; preloading first screen swfs"));
                this.preload_first_screen_swfs();
                return;
            };
            this.add_swf(evt.currentTarget.content);
            this.swf_loader.unload();
            this.swf_loader = null;
        }
        public function add_swf(_arg1:MovieClip):void{
            this.screen = _arg1;
            Tracer.out(("> loaded swf for current_section " + this.main.current_section));
            Tweener.removeTweens(this.screen);
            this.screen.alpha = 0;
            Tweener.addTween(this.screen, {
                "alpha":1,
                "time":1,
                "transition":"easeinoutsine",
                "onComplete":this.swf_tween_completed
            });
            this.main_container.addChild(this.screen);
            this.screen.play();
            this.main.destroy_screen_controller();
            this.main.init_screen_controller();
        }
        public function swap_swf(_arg1:MovieClip):void{
            TopMenu.getInstance().set_active();
            this.hide_preloader();
            this.screen = _arg1;
            Tracer.out(("> loaded swf for current_section " + this.main.current_section));
            Tweener.removeTweens(this.screen);
            this.screen.alpha = 0;
            Tweener.addTween(this.screen, {
                "alpha":1,
                "time":1,
                "transition":"easeinoutsine",
                "onComplete":this.swf_tween_completed
            });
            this.main_container.addChild(this.screen);
            this.screen.play();
            this.main.destroy_screen_controller();
            this.main.init_screen_controller();
        }
        public function swf_tween_completed(_arg1:Event=null):void{
            while (this.main_container.numChildren > 1)
            {
                this.main_container.removeChildAt(0);
            };
            TopMenu.getInstance().set_active();
        }
        function intro_complete(_arg1:Event):void{
            Tracker.track_first_time(Tracker.INTRO_COMPLETE);
            this.exit_intro();
        }
        public function exit_intro():void{
            Tracer.out("MainViewController > exit_intro");
            if (this.intro_timer)
            {
                this.intro_timer.stop();
            };
            while (this.intro_container.numChildren > 0)
            {
                this.intro_screen.stop();
                this.intro_container.removeChildAt(0);
                this.intro_screen = null;
            };
            this.intro_container.visible = false;
            this.main.current_section = this.first_section;
            this.main_container.visible = true;
            this.show_preloader();
            DataManager.getInstance().get_user_data();
        }
        public function check_first_screen_swfs():void{
            Tracer.out("MainViewController > check_first_screen_swfs");
            if (this.main.current_section != this.first_section)
            {
                return;
            };
            if (((((((((((((!((UserData.getInstance().user_name == null))) && (!((UserData.getInstance().a_list == null))))) && (this.city_data_ready))) && (!((this.screen == null))))) && (TopMenu.getInstance().isReady()))) && (ContestantBar.getInstance().isReady()))) && (!((this.game_assets_domain == null)))))
            {
                this.show_first_screen();
            };
        }
        public function city_data_received(_arg1:Event):void{
            this.city_data_ready = true;
            this.check_first_screen_swfs();
        }
        private function show_first_screen():void{
            Tracer.out("MainViewController > show_first_screen");
            if (this.first_section == Constants.SECTION_CITY)
            {
                DataManager.getInstance().track_game_event("initial_visit", "fashionista_city");
            };
            this.hide_preloader();
            BackGroundMusic.getInstance().init();
            TopMenu.getInstance().init();
            UserData.getInstance().init();
            this.header_container.visible = true;
            this.header_container.alpha = 0;
            Tweener.addTween(this.header_container, {
                "alpha":1,
                "time":1,
                "transition":"easeinoutsine"
            });
            switch (this.first_section)
            {
                case Constants.SECTION_CITY:
                    Tweener.addTween(this.screen, {
                        "alpha":1,
                        "time":1,
                        "transition":"easeinoutsine"
                    });
                    Main.getInstance().set_section(Constants.SECTION_CITY, false);
                    break;
                case Constants.SECTION_MY_BOUTIQUE:
                    MyBoutique.getInstance().load();
                    break;
                default:
                    Tracer.out(("ERROR: unhandled first section : " + this.first_section));
            };
            ContestantBar.getInstance().init();
            this.footer_container.visible = true;
            this.footer_container.alpha = 0;
            Tweener.addTween(this.footer_container, {
                "alpha":1,
                "time":1,
                "transition":"easeinoutsine",
                "onComplete":function (){
                }
            });
            if (UserData.getInstance().first_time_visit())
            {
                PopupIntro.getInstance().display_popup(PopupIntro.WELCOME1);
                this.moveClipToTopLevel(TopMenu.getInstance().menu.speaker_mc);
            } else
            {
                if (UserData.getInstance().daily_gift_center == false)
                {
                    GiftingController.getInstance().open_popup();
                } else
                {
                    MessageCenter.getInstance().init_welcome();
                };
            };
            UserData.getInstance().check_initial_fcash_drop();
            dispatchEvent(new Event(FIRST_SCREEN_READY));
        }
        public function show_modal_html_popup(){
            Tracer.out("setting frameRate to 0.1");
            this.main.stage.frameRate = 0.1;
            this.swf_blocker.visible = true;
        }
        public function hide_modal_html_popup(){
            this.main.stage.frameRate = Constants.FRAME_RATE;
            this.swf_blocker.visible = false;
        }
        public function blockTopAndBottom():void{
            this.top_bottom_blocker.visible = true;
        }
        public function unblockTopAndBottom():void{
            this.top_bottom_blocker.visible = false;
        }
        public function show_popup_blocker(){
            this.pop_up_blocker.visible = true;
        }
        public function hide_popup_blocker(){
            this.pop_up_blocker.visible = false;
        }
        public function dropFrameRate():void{
            Tracer.out("Main > dropFrameRate");
            if (this.main.current_section != "intro")
            {
                this.main.stage.frameRate = 0.1;
                Pop_Up.getInstance().display_restore_frame_rate();
            };
        }
        public function pause():void{
            Tracer.out("setting frameRate to 0.1");
            this.main.stage.frameRate = 0.1;
        }
        public function soft_pause():void{
            Tracer.out("setting frameRate to 1");
            this.main.stage.frameRate = 1;
        }
        public function resume():void{
            Tracer.out(("setting frameRate to " + Constants.FRAME_RATE));
            this.main.stage.frameRate = Constants.FRAME_RATE;
        }
        public function addGiftCenter(_arg1:MovieClip):void{
            this.snapshot_container.addChild(_arg1);
            dispatchEvent(new Event(OPENED_GIFT_CENTER));
        }
        public function inGiftCenter():Boolean{
            return (GiftingController.getInstance().isOpen());
        }
        public function addMessageCenter(_arg1:MovieClip):void{
            while (this.message_center_container.numChildren > 0)
            {
                this.message_center_container.removeChildAt(0);
            };
            this.message_center_container.addChild(_arg1);
        }
        public function hideMessageCenter():void{
            this.message_center_container.visible = false;
            dispatchEvent(new Event(CLOSED_MESSAGE_CENTER));
        }
        public function showMessageCenter():void{
            Tracer.out("showMessageCenter");
            this.message_center_container.visible = true;
            dispatchEvent(new Event(OPENED_MESSAGE_CENTER));
        }
        public function inMessageCenter():Boolean{
            return (this.message_center_container.visible);
        }
        public function in_popup():Boolean{
            if ((((((this.pop_up_container.numChildren > 0)) || ((this.level_up_container.numChildren > 0)))) || ((this.specials_container.numChildren > 0))))
            {
                return (true);
            };
            return (false);
        }
        public function closed_popup():void{
            if (this.pop_up_container.numChildren == 0)
            {
                Tracer.out("MainViewController > closed_popup");
                dispatchEvent(new Event(CLOSED_POPUP));
                this.hide_popup_blocker();
            };
        }
        public function moveClipToTopLevel(_arg1:MovieClip):void{
            Tracer.out((("moved " + _arg1.name) + " to top"));
            this.ui_container.addChild(_arg1);
        }
        public function addPopup(_arg1:MovieClip):void{
            this.pop_up_container.addChild(_arg1);
            this.show_popup_blocker();
        }
        public function removePopups():void{
            var _local1:MovieClip;
            var _local3:MovieClip;
            Tracer.out("removePopups");
            var _local2 = (this.pop_up_container.numChildren > 0);
            while (this.pop_up_container.numChildren > 0)
            {
                _local3 = (this.pop_up_container.removeChildAt(0) as MovieClip);
                if (_local3.no_remove)
                {
                    _local1 = _local3;
                };
            };
            if (_local1)
            {
                Tracer.out("reshowing one popup");
                this.pop_up_container.addChild(_local1);
            } else
            {
                if (_local2)
                {
                    this.closed_popup();
                };
            };
        }
        public function removeNotifications():void{
            Notification.getInstance().clear_notifications();
        }
        public function hide_free_item_btn():void{
            if (this.main.current_section == "city")
            {
                CityNewYork.getInstance().hide_free_item_btn();
            };
        }
        public function show_free_item_btn():void{
            if (this.main.current_section == "city")
            {
                CityNewYork.getInstance().show_free_item_btn();
            };
        }
        public function temp_mute_sound():void{
            if (BackGroundMusic.isMuted == false)
            {
                BackGroundMusic.getInstance().stopMusic();
            };
        }
        public function end_temp_mute_sound():void{
            if (BackGroundMusic.isMuted == false)
            {
                BackGroundMusic.getInstance().startMusic();
            };
        }
        public function load_game_assets(){
            var _local1:URLRequest = new URLRequest(((Constants.SERVER_SWF + Constants.GAME_ASSETS_FILENAME) + ".swf"));
            var _local2:Loader = new Loader();
            _local2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.asset_loaded);
            _local2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            _local2.load(_local1);
        }
        private function ioErrorHandler(_arg1:IOErrorEvent):void{
            Tracer.out(("ioErrorHandler: " + _arg1));
        }
        public function asset_loaded(_arg1:Event):void{
            var _local3:int;
            var _local5:String;
            Tracer.out("MainViewController > game assets swf loaded");
            this.game_assets_domain = (_arg1.target as LoaderInfo).applicationDomain;
            this.check_first_screen_swfs();
            Tracer.out("  registering fonts frankfurter, agent_orange, arial_narrow_bold, gill_sans_bold, gill_sans_light");
            Font.registerFont((this.game_assets_domain.getDefinition("frankfurter") as Class));
            Font.registerFont((this.game_assets_domain.getDefinition("agent_orange") as Class));
            Font.registerFont((this.game_assets_domain.getDefinition("arial_narrow_bold") as Class));
            Font.registerFont((this.game_assets_domain.getDefinition("gill_sans_bold") as Class));
            Font.registerFont((this.game_assets_domain.getDefinition("gill_sans_light") as Class));
            Util.tooltipClass = Class(this.game_assets_domain.getDefinition("oxylus.slidingTooltip.slidingTooltipMain"));
            var _local2:Array = Font.enumerateFonts(false);
            var _local4:int = _local2.length;
            while (_local3 < _local4)
            {
                _local5 = _local2[_local3].fontName;
                Tracer.out(("  has font: " + _local5));
                _local3++;
            };
        }
        public function get_game_asset(_arg1:String):Object{
            var _local2:Class;
            var _local3:Object;
            if (this.game_assets_domain)
            {
                _local2 = Class(this.game_assets_domain.getDefinition(_arg1));
                _local3 = new (_local2)();
                return (_local3);
            };
            return (null);
        }
        public function add_game_element(_arg1:DisplayObject):void{
            this.game_element_container.addChild(_arg1);
        }
        public function add_cleanup_element(_arg1:DisplayObject):void{
            this.cleanup_container.addChild(_arg1);
        }
        public function open_free_item_popup():void{
            FreeItemPopup.getInstance().open_popup();
        }
        public function open_look_of_the_day_popup():void{
            LookOfTheDayController.getInstance().open_popup();
        }
        public function add_snapshot_ui(_arg1:DisplayObject):void{
            this.snapshot_container.addChild(_arg1);
        }
        public function show_snapshot_effect():void{
            var s:Sprite;
            var remove_white:* = undefined;
            remove_white = function ():void{
                Tracer.out("remove_white");
                snapshot_container.removeChild(s);
            };
            Tracer.out("show_snapshot_effect");
            SoundEffectManager.getInstance().play_sound(Constants.RUNWAY_SOUND_FX, Constants.RUNWAY_SOUND_FX_VOLUME);
            s = new Sprite();
            s.graphics.beginFill(0xFFFFFF, 1);
            s.graphics.drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.GAME_SCREEN_HEIGHT);
            s.graphics.endFill();
            this.snapshot_container.addChild(s);
            Tweener.addTween(s, {
                "alpha":0,
                "time":0.75,
                "transition":"linear",
                "onComplete":remove_white
            });
        }
        public function show_decor_browser(db:DisplayObject, animate:Boolean=false):void{
            var startY:Number;
            this.footer_container.addChild(db);
            if (animate)
            {
                startY = db.y;
                db.y = (db.y + db.height);
                Tweener.addTween(db, {
                    "y":startY,
                    "time":1,
                    "transition":"easeOutSine",
                    "onComplete":function (){
                        footer_container.getChildAt(0).visible = false;
                    }
                });
                Tracer.out("show_decor_browser: animating in");
            } else
            {
                this.footer_container.getChildAt(0).visible = false;
            };
        }
        public function hide_decor_browser():void{
            this.footer_container.getChildAt(0).visible = true;
            if (this.footer_container.numChildren > 1)
            {
                this.footer_container.removeChildAt(1);
            };
        }
        public function getTopLevelClipByName(_arg1:String):MovieClip{
            return ((this.ui_container.getChildByName(_arg1) as MovieClip));
        }

    }
}//package com.viroxoty.fashionista.main

