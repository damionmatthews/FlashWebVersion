// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.Runway

package com.viroxoty.fashionista{
    import flash.display.Sprite;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Friend;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.text.TextFormat;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.data.Styles;
    import com.viroxoty.fashionista.data.Team;
    import com.viroxoty.fashionista.ui.ImageLoader;
    import com.viroxoty.fashionista.data.Item;
    import com.viroxoty.fashionista.ui.SnapshotController;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.text.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.user_boutique.*;
    import com.viroxoty.fashionista.sound.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class Runway extends Sprite {

        private static const THRESHOLD:int = 5;
        private static const INITIAL_CHUNK_SIZE:int = 10;
        public static const ALL_LOOKS:int = 0;
        public static const TOP_LOOKS:int = 1;
        public static const A_LIST_LOOKS:int = 2;
        public static const MY_LOOKS:int = 3;
        public static const A_LISTER_LOOKS:int = 4;
        public static const A_LISTER_PREVIEW:int = 5;
        public static const FROM_DRESSING_ROOM:int = 6;
        public static const SHOW_WELCOME:int = 7;
        public static const FACEOFF:int = 8;
        public static const TEAM_LOOKS:int = 9;
        private static const AVATAR_X:Number = 298.5;
        private static const AVATAR_Y:Number = 74.1;
        private static const AVATAR_FLIP_X_ADJ:Number = 175;
        private static const VISIT_BTN_TOP_LOOKS_Y:int = 266;
        private static const A_LIST_BTN_TOP_LOOKS_Y:int = 297;

        private static var _instance:Runway;
        private static var avatar_controller:AvatarController;
        static var button_mode:Boolean;

        public var mode:int = -1;
        private var avatar_looks:XML;
        private var loading_chunk:Boolean = false;
        private var total_looks:int;
        private var all_looks_count:int;
        private var counter:int;
        public var a_lister_xml:XML;
        private var name_li:Array;
        private var object_li:Array;
        private var pending_load:Boolean = false;
        private var user_looks:Array;
        private var friend_pool:Vector.<Friend>;
        private var friend_pool_length:int;
        public var runway:MovieClip;
        private var current_runway_bg:MovieClip;
        private var avatar_mc:MovieClip;
        private var faceoff_controller:FaceoffController;
        public var from_dressing_room:Boolean;
        public var show_intro_popup:Boolean;
        private var runway_init:MovieClip;
        private var back_to_city:MovieClip;
        private var looks_ui:MovieClip;
        private var faceoff_ui:MovieClip;
        private var vote_display:MovieClip;
        private var stars:MovieClip;
        public var stars_left:MovieClip;
        public var stars_right:MovieClip;
        private var tray:MovieClip;
        private var current_mode_btn:MovieClip;
        private var navi:String;
        private var welcome_clicks:int = 0;

        public function Runway(){
            this.name_li = new Array("jacket", "coat", "shoes", "pants", "skirts", "shorts", "hat", "mask", "glares", "earrings", "necklaces", "scarf", "purse", "tops", "ring", "bracelet", "dress", "tights", "belts", "gloves");
            this.object_li = new Array("jacket_mc", "jacket_mc", "shoes_mc", "bottom_mc", "bottom_mc", "bottom_mc", "hat_mc", "mask_mc", "mask_mc", "earring_mc", "necklaces_mc", "necklaces_mc", "purse_mc", "tops_mc", "ring_mc", "bracelet_mc", "dress_mc", "tights_mc", "belt1_mc", "gloves_mc");
            super();
            Tracer.out("new Runway");
            _instance = this;
            avatar_controller = AvatarController.getInstance();
            this.faceoff_controller = FaceoffController.getInstance();
            button_mode = false;
            this.user_looks = new Array();
        }
        public static function getInstance():Runway{
            if (_instance == null)
            {
                _instance = new (Runway)();
            };
            return (_instance);
        }

        public function load(_arg1:int=-1){
            if (_arg1 > -1)
            {
                this.mode = _arg1;
                Tracer.out(("set runway mode to " + this.mode));
            };
            Tracer.out("loading runway swf");
            Main.getInstance().set_section("runway");
            MainViewController.getInstance().load_asset(Constants.RUNWAY_FILENAME, this.loaded_runway);
        }
        public function loaded_runway(_arg1:MovieClip, _arg2:String):void{
            Tracer.out("Runway > loaded_runway");
            this.runway = _arg1;
            MainViewController.getInstance().swap_swf(this.runway);
        }
        public function init():void{
            Tracer.out("Runway > init");
            var _local2:* = this.runway;
            var _local2 = _local2;
            with (_local2)
            {
                welcome_mc.visible = false;
                contest_tip.visible = false;
                contest_tip.contest_txt.height = 54;
                contest_tip.contest_txt.text = TopMenu.get_contest_text();
                timer.visible = false;
                fabulous_popup.visible = false;
                buy_tip.visible = false;
                tray.ui.visible = false;
                tray.out_tab.visible = false;
                ui.visible = false;
                faceoff_ui.visible = false;
            };
            this.init_friend_buttons();
            this.avatar_mc = null;
            this.avatar_looks = null;
            this.counter = 0;
            this.total_looks = 0;
            this.welcome_clicks = 0;
            this.pending_load = false;
            this.navi = "next";
            this.init_friend_pool();
            this.runway.bg.faceoff.visible = false;
            this.runway.bg.faceoff.stop();
            this.runway.bg.my.visible = false;
            this.runway.bg.my.stop();
            this.runway.bg.a_list.visible = false;
            this.runway.bg.a_list.stop();
            this.runway.bg.top.visible = false;
            this.runway.bg.top.stop();
            this.current_runway_bg = this.runway.bg.all;
            this.runway_init = this.runway.welcome_mc;
            if (this.mode == FROM_DRESSING_ROOM)
            {
                this.dressing_room_runway();
            } else
            {
                if (this.mode == SHOW_WELCOME)
                {
                    this.city_runway();
                } else
                {
                    this.setup_runway();
                };
            };
            avatar_controller.mode = AvatarController.MODE_RUNWAY;
            avatar_controller.init();
            avatar_controller.get_avatar_mc_for(this);
            avatar_controller.addEventListener(AvatarController.FADE_IN_COMPLETE, this.avatar_faded_in);
            avatar_controller.addEventListener(AvatarController.ITEMS_LOADED, this.play_star_effect);
            SnapshotController.getInstance().addEventListener(SnapshotController.CLOSED, this.closed_snapshot_controller, false, 0, true);
            BackGroundMusic.getInstance().set_music(Constants.RUNWAY_MUSIC, Constants.RUNWAY_DURATION);
        }
        public function destroy():void{
            Tracer.out("Runway > destroy");
            this.mode = -1;
            this.a_lister_xml = null;
            Main.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.set_vote_stars_rollover);
            GameTimer.getInstance().removeEventListener("timer", this.show_runway_time);
            SnapshotController.getInstance().removeEventListener(SnapshotController.CLOSED, this.closed_snapshot_controller);
            avatar_controller.removeEventListener(AvatarController.FADE_IN_COMPLETE, this.avatar_faded_in);
            avatar_controller.removeEventListener(AvatarController.ITEMS_LOADED, this.play_star_effect);
            this.faceoff_controller.destroy();
            this.runway = null;
            this.avatar_mc = null;
            this.runway_init = null;
            this.back_to_city = null;
            this.looks_ui = null;
            this.vote_display = null;
            this.faceoff_ui = null;
            this.tray = null;
            this.current_mode_btn = null;
            this.from_dressing_room = false;
            this.show_intro_popup = false;
        }
        public function set_avatar_mc(_arg1:MovieClip):void{
            Tracer.out("Ruwnay > set_avatar_mc");
            this.avatar_mc = _arg1;
            this.avatar_mc.x = AVATAR_X;
            this.avatar_mc.y = AVATAR_Y;
            this.avatar_mc.visible = false;
            this.avatar_mc.alpha = 0;
            this.runway.addChildAt(_arg1, 3);
            if (this.pending_load)
            {
                this.pending_load = false;
                this.show_looks_ui();
                this.load_contestant_avatar();
            };
        }
        public function show_top_looks():void{
            this.mode = TOP_LOOKS;
            if (this.runway_init.visible)
            {
                this.runway_init.visible = false;
                this.setup_runway();
            } else
            {
                this.select_top();
                this.tray.ui.top_btn.gotoAndStop(3);
            };
        }
        public function show_team_looks():void{
            this.mode = TEAM_LOOKS;
            if (this.runway_init.visible)
            {
                this.runway_init.visible = false;
                this.setup_runway();
            } else
            {
                this.select_team();
                this.tray.ui.team_btn.gotoAndStop(3);
            };
        }
        public function show_my_looks():void{
            this.mode = Runway.MY_LOOKS;
            if (this.runway_init.visible)
            {
                this.runway_init.visible = false;
                this.setup_runway();
            } else
            {
                this.select_my();
                this.tray.ui.your_btn.gotoAndStop(3);
            };
        }
        public function show_a_lister_looks():void{
            Tracer.out("show_a_lister_looks");
            this.mode = A_LISTER_LOOKS;
            if (this.runway_init.visible)
            {
                this.runway_init.visible = false;
                this.setup_runway();
                return;
            };
            this.reset_ui();
            this.current_mode_btn = this.tray.ui.a_list_btn;
            this.current_mode_btn.gotoAndStop(3);
            this.show_bg("a_list");
            Tracer.out("show_a_lister_looks > ui setup done");
            this.set_looks_xml(this.a_lister_xml, Pop_Up.NO_A_LISTER_LOOKS);
        }
        public function addUserLook(_arg1:Object, _arg2:int):void{
            Tracer.out(("addUserLook id: " + _arg2));
            Tracer.out(("user_looks was " + this.user_looks.toString()));
            _arg1.id = _arg2;
            this.user_looks.unshift(_arg1);
            Tracer.out(("user_looks now " + this.user_looks.toString()));
        }
        public function user_leveled():void{
            if (this.runway)
            {
                avatar_controller.check_item_levels();
            };
        }
        public function set_runway_avatar_xml(_arg1:XML):void{
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local5:Object;
            var _local6:XML;
            if (this.mode != ALL_LOOKS)
            {
                Tracer.out("set_runway_avatar_xml > wrong mode; bailing");
                return;
            };
            MainViewController.getInstance().hide_preloader();
            this.reset_avatar_num(this.counter);
            this.counter = 0;
            Tracer.out(("set_runway_avatar_xml, received initial data: " + this.xml_summary(_arg1)));
            this.avatar_looks = new XML(_arg1);
            this.total_looks = int(this.avatar_looks.@TOTAL);
            this.all_looks_count = this.total_looks;
            Tracer.out(("  total looks: " + this.total_looks));
            if ((INITIAL_CHUNK_SIZE * 2) < this.total_looks)
            {
                Tracer.out((((("  received head chunk of " + INITIAL_CHUNK_SIZE) + " looks and tail chunk of ") + INITIAL_CHUNK_SIZE) + " looks.  Removing tail looks"));
                _local2 = this.avatar_looks.children().length();
                _local3 = _local2;
                while (_local3 >= INITIAL_CHUNK_SIZE)
                {
                    delete this.avatar_looks.AVATAR[_local3];
                    _local3--;
                };
                Tracer.out(("  avatar_looks now is: \n" + this.xml_summary(this.avatar_looks)));
            } else
            {
                Tracer.out("   received all looks");
            };
            _local2 = this.user_looks.length;
            if (_local2 > 0)
            {
                Tracer.out(("user_looks was \n" + this.user_looks));
                _local4 = (((this.total_looks)==0) ? 0 : int(this.avatar_looks.AVATAR[0].@ID));
                _local3 = (_local2 - 1);
                while (_local3 >= 0)
                {
                    _local5 = this.user_looks[_local3];
                    if (_local5.id > _local4)
                    {
                        _local6 = this.avatar_node_from_object(_local5);
                        this.avatar_looks.prependChild(_local6);
                        Tracer.out(("user_looks after prepend \n" + this.user_looks));
                    } else
                    {
                        this.user_looks.splice(_local3, 1);
                        Tracer.out((this.user_looks.length + " user_looks after delete \n"));
                    };
                    _local3--;
                };
                Tracer.out(("avatar_looks now is \n" + this.xml_summary(this.avatar_looks)));
            };
            this.total_looks = this.avatar_looks.children().length();
            if (this.total_looks > 0)
            {
                this.show_looks_ui();
                this.load_contestant_avatar();
            } else
            {
                Pop_Up.getInstance().display_popup(Pop_Up.NO_LOOKS);
            };
        }
        public function add_forward_chunk(_arg1:XML):void{
            var _local3:int;
            this.loading_chunk = false;
            Tracer.out(("add_forward_chunk, received: " + this.xml_summary(_arg1)));
            var _local2:int = _arg1.children().length();
            while (_local3 < _local2)
            {
                this.avatar_looks.appendChild(_arg1.AVATAR[_local3]);
                _local3++;
            };
            this.total_looks = this.avatar_looks.children().length();
            Tracer.out(("total_looks now " + this.total_looks));
            Tracer.out(("avatar_looks now is: \n" + this.xml_summary(this.avatar_looks)));
        }
        public function set_top_looks_xml(_arg1:XML):void{
            MainViewController.getInstance().hide_preloader();
            if (this.mode != Runway.TOP_LOOKS)
            {
                Tracer.out("set_top_looks_xml > wrong mode; bailing");
                return;
            };
            this.set_looks_xml(_arg1, Pop_Up.NO_LOOKS);
        }
        public function set_friends_looks_xml(_arg1:XML):void{
            MainViewController.getInstance().hide_preloader();
            if (this.mode != Runway.A_LIST_LOOKS)
            {
                Tracer.out("set_friends_looks_xml > wrong mode; bailing");
                return;
            };
            this.set_looks_xml(_arg1, Pop_Up.NO_A_LIST_LOOKS);
        }
        public function set_user_looks(_arg1:XML):void{
            MainViewController.getInstance().hide_preloader();
            if (this.mode != Runway.MY_LOOKS)
            {
                Tracer.out("set_user_looks > wrong mode; bailing");
                return;
            };
            Tracer.out(("set_user_looks, received initial data: " + _arg1.toString()));
            this.set_looks_xml(_arg1, Pop_Up.NO_MY_LOOKS);
        }
        function set_looks_xml(_arg1:XML, _arg2:String):void{
            this.reset_avatar_num(this.counter);
            this.counter = 0;
            this.avatar_looks = new XML(_arg1);
            this.total_looks = this.avatar_looks.children().length();
            Tracer.out(("  total looks: " + this.total_looks));
            if (this.total_looks > 0)
            {
                this.show_looks_ui();
                this.load_contestant_avatar();
            } else
            {
                Pop_Up.getInstance().display_popup(_arg2);
            };
        }
        function set_team_looks(_arg1:XML):void{
            if (this.mode != Runway.TEAM_LOOKS)
            {
                Tracer.out("set_team_looks > wrong mode; bailing");
                return;
            };
            MainViewController.getInstance().hide_preloader();
            this.reset_avatar_num(this.counter);
            this.counter = 0;
            Tracer.out(("set_user_looks, received initial data: " + _arg1.toString()));
            this.avatar_looks = new XML(_arg1);
            this.total_looks = this.avatar_looks.children().length();
            Tracer.out(("  total looks: " + this.total_looks));
            if (this.total_looks > 0)
            {
                this.show_looks_ui();
                this.load_contestant_avatar();
            } else
            {
                Pop_Up.getInstance().display_popup(Pop_Up.NO_TEAM_LOOKS);
            };
        }
        public function load_faceoff(_arg1:Event):void{
            Tracer.out("Runway > load_faceoff");
            this.mode = Runway.FACEOFF;
            this.reset_ui();
            this.current_mode_btn = this.tray.ui.faceoff_btn;
            this.current_runway_bg = this.runway.bg.faceoff;
            this.current_runway_bg.visible = true;
            this.current_runway_bg.play();
            this.show_faceoff_ui();
            this.faceoff_controller.get_faceoff();
        }
        public function add_votes(_arg1:String, _arg2:int, _arg3:String):void{
            var _local4:XML;
            var _local5:int;
            var _local6:int;
            Tracer.out(((("add_votes >  updating votes for avatar id " + _arg1) + ", user id ") + _arg3));
            while (_local6 < this.total_looks)
            {
                _local4 = this.avatar_looks.AVATAR[_local6];
                if (_local4.@ID == _arg1)
                {
                    _local4.@VOTES = String((int(_local4.@VOTES) + _arg2));
                };
                if (_local4.@UID == _arg3)
                {
                    _local4.@DAY = String((int(_local4.@DAY) + _arg2));
                    _local4.@WEEK = String((int(_local4.@WEEK) + _arg2));
                    _local5++;
                };
                _local6++;
            };
            Tracer.out(((("   updated vote counts for " + _local5) + " runway looks for uid ") + _arg3));
            if (_arg3 == DataManager.user_id)
            {
                UserData.getInstance().day_votes = (UserData.getInstance().day_votes + _arg2);
                UserData.getInstance().week_votes = (UserData.getInstance().week_votes + _arg2);
            };
            Tracer.out((("   updated vote counts for " + _local5) + " cached user looks "));
            _local4 = this.avatar_looks.AVATAR[this.counter];
            this.vote_display.today_txt.text = _local4.@DAY;
            if (this.mode != Runway.TOP_LOOKS)
            {
                this.vote_display.week_txt.text = _local4.@WEEK;
            };
            if (_local4.@ID == _arg1)
            {
                Tracer.out("   also updated Look vote count since only one look on runway");
                this.looks_ui.info_mc.vote_txt.text = _local4.@VOTES;
            };
        }
        public function play_star_effect(_arg1:Event=null):void{
        }
        public function play_camera_flash():void{
        }
        public function update_a_list_btn():void{
            MainViewController.getInstance().hide_preloader();
            var _local1:MovieClip = this.looks_ui.a_list_btn;
            var _local2:String = this.avatar_looks.AVATAR[this.counter].@UID;
            Tracer.out(("update_a_list_btn > uid is " + _local2));
            if (_local2 == DataManager.user_id)
            {
                _local1.visible = false;
                return;
            };
            this.looks_ui.a_list_btn.visible = true;
            if (UserData.getInstance().check_a_list(_local2))
            {
                Tracer.out("already on A-List");
                _local1.gotoAndStop(2);
            } else
            {
                Tracer.out("not on A-List");
                _local1.gotoAndStop(1);
            };
            if ((((this.mode == TOP_LOOKS)) || ((this.mode == TEAM_LOOKS))))
            {
                _local1.y = A_LIST_BTN_TOP_LOOKS_Y;
            } else
            {
                _local1.y = _local1.startY;
            };
        }
        function city_runway():void{
            this.runway_init.visible = true;
            this.runway_init.vote_btn.buttonMode = true;
            this.runway_init.vote_btn.addEventListener(MouseEvent.CLICK, this.setup_runway, false, 0, true);
            this.runway_init.enter_btn.buttonMode = true;
            this.runway_init.enter_btn.addEventListener(MouseEvent.CLICK, this.go_dressing_room, false, 0, true);
            var _local1:TextFormat = new TextFormat();
            _local1.font = "Arial";
            this.runway_init.content_text.defaultTextFormat = _local1;
            this.runway_init.content_text.text = TopMenu.get_contest_text();
            Util.verticallyCenterText(this.runway_init.content_text);
        }
        function dressing_room_runway():void{
            this.setup_runway();
        }
        function setup_runway(_arg1:MouseEvent=null):void{
            var _local2:MovieClip;
            if (this.runway_init)
            {
                this.runway_init.visible = false;
            };
            this.stars = this.runway.star_effect;
            this.stars_left = this.runway.star_effect_left;
            this.stars_right = this.runway.star_effect_right;
            this.tray = this.runway.tray;
            this.tray.out_tab.visible = true;
            this.tray.out_tab.buttonMode = true;
            this.tray.out_tab.addEventListener(MouseEvent.CLICK, this.open_tray, false, 0, true);
            Util.create_tooltip("CLICK THE ARROW TO SEE YOUR FRIENDS OR THE TOP 50!", this.tray.out_tab, "left", "top");
            this.tray.ui.visible = true;
            this.tray.ui.in_tab.buttonMode = true;
            this.tray.ui.in_tab.addEventListener(MouseEvent.CLICK, this.close_tray, false, 0, true);
            Util.setupButton(this.tray.ui.a_list_btn);
            this.tray.ui.a_list_btn.addEventListener(MouseEvent.CLICK, this.select_a_list, false, 0, true);
            Util.setupButton(this.tray.ui.top_btn);
            this.tray.ui.top_btn.addEventListener(MouseEvent.CLICK, this.select_top, false, 0, true);
            Util.setupButton(this.tray.ui.all_btn);
            this.tray.ui.all_btn.addEventListener(MouseEvent.CLICK, this.select_all, false, 0, true);
            Util.setupButton(this.tray.ui.your_btn);
            this.tray.ui.your_btn.addEventListener(MouseEvent.CLICK, this.select_my, false, 0, true);
            Util.setupButton(this.tray.ui.team_btn);
            this.tray.ui.team_btn.addEventListener(MouseEvent.CLICK, this.select_team, false, 0, true);
            Util.setupButton(this.tray.ui.faceoff_btn);
            this.tray.ui.faceoff_btn.addEventListener(MouseEvent.CLICK, this.load_faceoff, false, 0, true);
            this.looks_ui = this.runway.ui;
            var _local3:int = 1;
            while (_local3 <= 5)
            {
                _local2 = this.looks_ui[("star" + _local3)];
                _local2.index = _local3;
                _local2.mouseChildren = false;
                _local2.gold_mc.visible = false;
                _local2.num_txt.visible = false;
                _local2.num_txt.text = String(_local3);
                _local2.buttonMode = true;
                _local2.addEventListener(MouseEvent.CLICK, this.add_vote, false, 0, true);
                _local2.addEventListener(MouseEvent.ROLL_OVER, this.light_star, false, 0, true);
                _local3++;
            };
            this.looks_ui.next_btn.buttonMode = true;
            this.looks_ui.next_btn.addEventListener(MouseEvent.CLICK, this.next_avatar, false, 0, true);
            this.looks_ui.prev_btn.buttonMode = true;
            this.looks_ui.prev_btn.addEventListener(MouseEvent.CLICK, this.previous_avatar, false, 0, true);
            this.looks_ui.photo_btn.buttonMode = true;
            this.looks_ui.photo_btn.addEventListener(MouseEvent.CLICK, this.take_snapshot, false, 0, true);
            this.looks_ui.name_btn.buttonMode = true;
            this.looks_ui.name_btn.addEventListener(MouseEvent.CLICK, this.show_profile, false, 0, true);
            Util.create_tooltip("ADD AS FRIEND!", this.looks_ui.name_btn, "right");
            this.looks_ui.info_mc.team_icon.buttonMode = true;
            this.looks_ui.info_mc.team_icon.addEventListener(MouseEvent.CLICK, this.open_team, false, 0, true);
            this.looks_ui.a_list_btn.stop();
            this.looks_ui.a_list_btn.startY = this.looks_ui.a_list_btn.y;
            this.looks_ui.a_list_btn.buttonMode = true;
            this.looks_ui.a_list_btn.addEventListener(MouseEvent.CLICK, this.click_a_list, false, 0, true);
            this.looks_ui.visit_btn.startY = this.looks_ui.visit_btn.y;
            this.looks_ui.visit_btn.buttonMode = true;
            this.looks_ui.visit_btn.addEventListener(MouseEvent.CLICK, this.visit_boutique, false, 0, true);
            this.looks_ui.rank_mc.visible = false;
            this.looks_ui.zoom_btn.buttonMode = true;
            this.looks_ui.zoom_btn.addEventListener(MouseEvent.CLICK, this.set_avatar_zoom, false, 0, true);
            this.vote_display = this.looks_ui.info_mc.vote_display;
            this.looks_ui.info_mc.top_vote_display.visible = false;
            this.faceoff_ui = this.runway.faceoff_ui;
            this.faceoff_controller.init_ui(this.faceoff_ui);
            this.runway.daily_btn.buttonMode = true;
            this.runway.daily_btn.addEventListener(MouseEvent.CLICK, this.show_daily_leaders, false, 0, true);
            Util.create_tooltip("DAILY LEADERS!", this.runway, "right", "top", this.runway.daily_btn);
            GameTimer.getInstance().addEventListener("timer", this.show_runway_time, false, 0, true);
            this.show_runway_time();
            this.runway.timer.visible = true;
            if ((((this.mode == A_LISTER_LOOKS)) || ((this.mode == A_LISTER_PREVIEW))))
            {
                this.show_a_lister_looks();
                this.current_mode_btn = this.tray.ui.a_list_btn;
            } else
            {
                if (this.mode == FROM_DRESSING_ROOM)
                {
                    this.tray.ui.faceoff_btn.gotoAndStop(3);
                    this.load_faceoff(null);
                    this.current_mode_btn = this.tray.ui.faceoff_btn;
                } else
                {
                    if (this.mode == TOP_LOOKS)
                    {
                        this.select_top();
                    } else
                    {
                        if (this.mode == MY_LOOKS)
                        {
                            this.select_my();
                        } else
                        {
                            this.mode = ALL_LOOKS;
                            this.select_all();
                        };
                    };
                };
            };
            this.current_mode_btn.gotoAndStop(3);
        }
        function open_tray(_arg1:Event):void{
            this.tray.ui.visible = true;
        }
        function close_tray(_arg1:Event):void{
            this.tray.ui.visible = false;
        }
        function show_looks_ui():void{
            this.looks_ui.visible = true;
            this.runway.buy_tip.visible = true;
            if (this.avatar_mc)
            {
                this.avatar_mc.visible = true;
            };
            this.looks_ui.prev_btn.visible = !((this.mode == ALL_LOOKS));
        }
        function show_faceoff_ui():void{
            this.runway.buy_tip.visible = true;
            this.faceoff_controller.show_ui();
            this.runway.contest_tip.visible = true;
            this.runway.bg.logo.visible = false;
            this.runway.timer.visible = false;
            this.runway.daily_btn.visible = false;
            if (this.avatar_mc)
            {
                this.avatar_mc.visible = false;
            };
        }
        function hide_ui():void{
            this.looks_ui.visible = false;
            this.faceoff_controller.hide_ui();
            this.runway.buy_tip.visible = false;
            this.runway.contest_tip.visible = false;
            this.runway.bg.logo.visible = true;
            this.runway.timer.visible = true;
            this.runway.daily_btn.visible = true;
            if (this.avatar_mc)
            {
                this.avatar_mc.alpha = 0;
            };
            this.stars.gotoAndStop(1);
        }
        function reset_ui(){
            this.hide_ui();
            if (this.current_mode_btn)
            {
                this.current_mode_btn.gotoAndStop(1);
            };
            this.current_runway_bg.visible = false;
            this.current_runway_bg.stop();
            this.looks_ui.visit_btn.y = this.looks_ui.visit_btn.startY;
            if (this.vote_display == this.looks_ui.info_mc.top_vote_display)
            {
                this.vote_display.visible = false;
                this.vote_display = this.looks_ui.info_mc.vote_display;
                this.vote_display.visible = true;
            };
            this.looks_ui.rank_mc.visible = false;
            this.hide_friends();
        }
        function show_bg(_arg1:String):void{
            this.current_runway_bg = this.runway.bg[_arg1];
            this.current_runway_bg.visible = true;
            this.current_runway_bg.play();
        }
        function select_a_list(_arg1:Event=null):void{
            this.mode = Runway.A_LIST_LOOKS;
            this.reset_ui();
            this.current_mode_btn = this.tray.ui.a_list_btn;
            this.show_bg("a_list");
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().get_user_looks_xml(this, true);
        }
        function select_top(_arg1:Event=null):void{
            this.mode = Runway.TOP_LOOKS;
            this.reset_ui();
            this.show_bg("top");
            if (this.vote_display == this.looks_ui.info_mc.vote_display)
            {
                this.vote_display.visible = false;
                this.vote_display = this.looks_ui.info_mc.top_vote_display;
                this.vote_display.visible = true;
            };
            this.current_mode_btn = this.tray.ui.top_btn;
            this.looks_ui.visit_btn.y = VISIT_BTN_TOP_LOOKS_Y;
            this.looks_ui.rank_mc.visible = true;
            this.looks_ui.rank_mc.rank_txt.text = "";
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().get_top_looks_xml(this);
        }
        function select_all(_arg1:Event=null):void{
            this.mode = Runway.ALL_LOOKS;
            this.reset_ui();
            this.current_mode_btn = this.tray.ui.all_btn;
            this.show_bg("all");
            Tracer.out("going to show_friends");
            this.show_friends();
            Tracer.out("did show_friends");
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().get_runway_avatar_xml(this);
        }
        function select_my(_arg1:Event=null):void{
            this.mode = Runway.MY_LOOKS;
            this.reset_ui();
            this.current_mode_btn = this.tray.ui.your_btn;
            this.show_bg("my");
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().get_user_looks_xml(this);
        }
        function select_team(_arg1:Event=null):void{
            this.mode = Runway.TEAM_LOOKS;
            this.reset_ui();
            this.current_mode_btn = this.tray.ui.team_btn;
            this.show_bg("a_list");
            this.looks_ui.visit_btn.y = VISIT_BTN_TOP_LOOKS_Y;
            this.looks_ui.rank_mc.visible = true;
            this.looks_ui.rank_mc.rank_txt.text = "";
            if (UserData.getInstance().team)
            {
                MainViewController.getInstance().show_preloader();
                DataManager.getInstance().get_team_looks_xml(UserData.getInstance().team.id, this.set_team_looks);
            } else
            {
                MessageCenter.getInstance().show_team();
            };
        }
        function go_dressing_room(_arg1:Event):void{
            DressingRoom.getNewInstance().load();
        }
        private function load_city(_arg1:MouseEvent):void{
            _arg1.currentTarget.removeEventListener(MouseEvent.CLICK, this.load_city);
            CityManager.getInstance().goto_city(1);
        }
        private function show_daily_leaders(_arg1:MouseEvent):void{
            External.open_top_daily();
        }
        private function show_profile(_arg1:MouseEvent):void{
            var _local2:String = this.avatar_looks.AVATAR[this.counter].@URL;
            Util.open_url(_local2);
        }
        private function open_team(_arg1:MouseEvent):void{
            MessageCenter.getInstance().show_team();
        }
        private function click_a_list(_arg1:MouseEvent):void{
            if (MovieClip(_arg1.currentTarget).currentFrame == 1)
            {
                this.add_a_list();
            } else
            {
                this.remove_a_list();
            };
        }
        private function add_a_list():void{
            var _local1:String = this.avatar_looks.AVATAR[this.counter].@UID;
            var _local2:String = this.avatar_looks.AVATAR[this.counter].@NAME;
            Tracer.out((("add uid " + _local1) + " to user's A-List"));
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().add_to_a_list(_local1, _local2, this.update_a_list_btn, this.update_a_list_btn);
        }
        private function remove_a_list():void{
            var _local1:String = this.avatar_looks.AVATAR[this.counter].@UID;
            Tracer.out((("remove uid " + _local1) + " from user's A-List"));
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().remove_from_a_list(_local1, this.update_a_list_btn, this.update_a_list_btn);
        }
        private function visit_boutique(_arg1=null):void{
            var _local2:String = this.avatar_looks.AVATAR[this.counter].@UID;
            var _local3:String = this.avatar_looks.AVATAR[this.counter].@NAME;
            Tracer.out(("TODO: visit boutique for uid " + _local2));
            BoutiqueVisit.createVisit(_local2, _local3);
        }
        private function show_next_look():void{
            if (this.navi == "previous")
            {
                this.show_previous();
            } else
            {
                this.show_next();
            };
        }
        private function next_avatar(_arg1:MouseEvent):void{
            if (button_mode)
            {
                this.navi = "next";
                button_mode = false;
                this.show_next();
            };
        }
        private function show_next():void{
            var _local1:int;
            var _local2:int;
            if ((((this.mode == ALL_LOOKS)) && ((this.loading_chunk == false))))
            {
                _local1 = (this.counter + THRESHOLD);
                if (_local1 < this.all_looks_count)
                {
                    if (this.avatar_looks.AVATAR[_local1] == null)
                    {
                        Tracer.out((("show-next > found a gap at index " + _local1) + ", need to load a chunk"));
                        _local2 = this.avatar_looks.AVATAR[(_local1 - 1)].@ID;
                        this.loading_chunk = true;
                        DataManager.getInstance().get_runway_avatar_xml(this, "forward", _local2);
                    };
                };
            } else
            {
                Tracer.out("Runway > already loading a chunk, nevermind");
            };
            Tracer.out(((("show_next > before increment, counter=" + this.counter) + ", total_looks = ") + this.total_looks));
            this.counter++;
            if (this.counter == this.total_looks)
            {
                this.counter = 0;
            };
            if (this.mode == Runway.ALL_LOOKS)
            {
                this.looks_ui.prev_btn.visible = true;
            };
            if (UserData.getInstance().shopping_welcome)
            {
                PopupIntro.getInstance().display_popup(PopupIntro.SHOPPING_TIP);
            };
            this.load_contestant_avatar();
        }
        private function previous_avatar(_arg1:MouseEvent=null):void{
            if (button_mode)
            {
                this.navi = "previous";
                button_mode = false;
                this.show_previous();
            };
        }
        private function show_previous():void{
            this.counter--;
            if (this.counter == -1)
            {
                this.counter = (this.total_looks - 1);
            };
            if ((((this.counter == 0)) && ((this.mode == Runway.ALL_LOOKS))))
            {
                this.looks_ui.prev_btn.visible = false;
            };
            this.load_contestant_avatar();
        }
        private function load_contestant_avatar():void{
            var avatar_xml:XML;
            var s:Styles;
            var i:int;
            var max:int;
            var t:Team;
            var il:ImageLoader;
            var node:XML;
            var name:String;
            var values:String;
            var a:Array;
            var fade_out:Function;
            var setup_avatar:Function = function (){
                var _local1:XML;
                var _local2:Item;
                avatar_controller.set_styles(s);
                i = 0;
                while (i < max)
                {
                    _local1 = avatar_xml.item[i];
                    _local2 = new Item();
                    _local2.parseRunwayXML(_local1);
                    if ((((avatar_xml.@UID == DataManager.user_id)) || (((UserData.getInstance().first_time_visit()) && (UserData.getInstance().shopping_welcome)))))
                    {
                        _local2.name = "";
                        _local2.description = "";
                        _local2.price = -1;
                        _local2.level = -1;
                    };
                    avatar_controller.display_contestant_item(_local2, max);
                    i++;
                };
                play_camera_flash();
            };
            MainViewController.getInstance().show_preloader();
            if (this.avatar_mc == null)
            {
                this.hide_ui();
                this.pending_load = true;
                return;
            };
            if (this.avatar_looks.AVATAR[this.counter].item.length() == 0)
            {
                Tracer.out(("Runway > load_contestant_avatar:  ERROR: no items for this look! > " + this.avatar_looks.AVATAR[this.counter].toString()));
                Tracker.track(("avatar_id_" + this.avatar_looks.AVATAR[this.counter].@ID), "no_item_avatar");
                this.reset_avatar();
                delete this.avatar_looks.AVATAR[this.counter];
                this.total_looks--;
                if (this.total_looks > 0)
                {
                    if (this.navi == "previous")
                    {
                        this.show_previous();
                    } else
                    {
                        this.show_next();
                    };
                } else
                {
                    switch (this.mode)
                    {
                        case Runway.ALL_LOOKS:
                        case Runway.TOP_LOOKS:
                            Pop_Up.getInstance().display_popup(Pop_Up.NO_LOOKS);
                            return;
                        case Runway.A_LIST_LOOKS:
                            Pop_Up.getInstance().display_popup(Pop_Up.NO_A_LIST_LOOKS);
                            return;
                        case Runway.MY_LOOKS:
                            Pop_Up.getInstance().display_popup(Pop_Up.NO_MY_LOOKS);
                            return;
                    };
                };
                return;
            };
            Tracer.out(("load_contestant_avatar > avatar_mc.alpha = " + this.avatar_mc.alpha));
            avatar_xml = this.avatar_looks.AVATAR[this.counter];
            Tracer.out(("avatar_xml is " + avatar_xml.toString()));
            var info:MovieClip = this.looks_ui.info_mc;
            info.name_txt.text = avatar_xml.@NAME;
            info.vote_txt.text = avatar_xml.@VOTES;
            this.vote_display.today_txt.text = avatar_xml.@DAY;
            if (this.mode != Runway.TOP_LOOKS)
            {
                this.vote_display.week_txt.text = avatar_xml.@WEEK;
            };
            if (avatar_xml.@TEAM != "")
            {
                info.team_icon.visible = true;
                while (info.team_icon.pic.numChildren > 0)
                {
                    info.team_icon.pic.removeChildAt(0);
                };
                t = DataManager.getInstance().get_team_by_id(int(avatar_xml.@TEAM));
                il = new ImageLoader(t.icon_url, info.team_icon.pic, 30, 30);
                Util.remove_tooltip(info.team_icon);
                if (t.leader_id == avatar_xml.@UID)
                {
                    info.team_icon.leader_star.visible = true;
                    Util.create_tooltip(("LEADER OF " + t.name.toUpperCase()), this.runway, "right", "bottom", info.team_icon);
                } else
                {
                    info.team_icon.leader_star.visible = false;
                    Util.create_tooltip(("MEMBER OF " + t.name.toUpperCase()), this.runway, "right", "bottom", info.team_icon);
                };
            } else
            {
                info.team_icon.visible = false;
            };
            Tracer.out(("vote_txt is " + info.vote_txt.text));
            if ((((this.mode == Runway.TOP_LOOKS)) || ((this.mode == Runway.TEAM_LOOKS))))
            {
                this.looks_ui.rank_mc.rank_txt.text = ("#" + String((this.total_looks - this.counter)));
            };
            var notUserLook:Boolean = !((avatar_xml.@UID == DataManager.user_id));
            this.runway.buy_tip.visible = notUserLook;
            this.looks_ui.name_btn.visible = notUserLook;
            this.looks_ui.visit_btn.visible = ((notUserLook) && ((avatar_xml.@ACTIVE_BOUTIQUE == "1")));
            if (this.runway.buy_tip.visible)
            {
                if (((UserData.getInstance().first_time_visit()) && (UserData.getInstance().shopping_welcome)))
                {
                    this.runway.buy_tip.visible = false;
                };
            };
            this.update_a_list_btn();
            avatar_controller.reset_item_counter();
            s = new Styles();
            i = 0;
            while (i < 6)
            {
                node = avatar_xml.SWF[i];
                name = String(node.@NAME).toLocaleLowerCase();
                values = node.toString();
                if (name == "styles")
                {
                    a = values.split(",");
                    s.hair = int(a[0]);
                    s.eyes = int(a[1]);
                    s.lips = int(a[2]);
                } else
                {
                    if (name == "colors")
                    {
                        a = values.split(",");
                        s.hair_color = int(a[0]);
                        s.eye_color = int(a[1]);
                        s.lip_color = int(a[2]);
                    } else
                    {
                        if (name == "skintone")
                        {
                            s.skin = int(values);
                        } else
                        {
                            if (name == "eyeshade")
                            {
                                s.eye_shade = int(values);
                            } else
                            {
                                if (name == "eyebrows")
                                {
                                    s.eyebrows = int(values);
                                } else
                                {
                                    if (name == "blush")
                                    {
                                        s.blush = int(values);
                                    };
                                };
                            };
                        };
                    };
                };
                i = (i + 1);
            };
            Tracer.out(((("Runway > avatar_mc.x = " + this.avatar_mc.x) + ", y = ") + this.avatar_mc.y));
            max = this.avatar_looks.AVATAR[this.counter].item.length();
            if (this.avatar_mc.alpha > 0)
            {
                fade_out = function (_arg1:Event):void{
                    _arg1.currentTarget.alpha = (_arg1.currentTarget.alpha - 0.3);
                    if (_arg1.currentTarget.alpha <= 0)
                    {
                        _arg1.currentTarget.removeEventListener(Event.ENTER_FRAME, fade_out);
                        _arg1.currentTarget.alpha = 0;
                        reset_avatar();
                        setup_avatar();
                    };
                };
                this.avatar_mc.addEventListener(Event.ENTER_FRAME, fade_out);
            } else
            {
                (setup_avatar());
            };
        }
        private function avatar_faded_in(_arg1:Event):void{
            button_mode = true;
            this.reset_vote_stars();
        }
        private function reset_avatar():void{
            var _local1:int;
            Tracer.out("reset_avatar");
            if (this.navi == "next")
            {
                if (this.counter == 0)
                {
                    _local1 = (this.total_looks - 1);
                } else
                {
                    _local1 = (this.counter - 1);
                };
            } else
            {
                if (this.navi == "previous")
                {
                    if (this.counter == (this.total_looks - 1))
                    {
                        _local1 = 0;
                    } else
                    {
                        _local1 = (this.counter + 1);
                    };
                };
            };
            if ((this.counter % 2) == 0)
            {
                this.avatar_mc.scaleX = 1;
                this.avatar_mc.x = AVATAR_X;
            } else
            {
                this.avatar_mc.scaleX = -1;
                this.avatar_mc.x = (AVATAR_X + AVATAR_FLIP_X_ADJ);
            };
            this.reset_avatar_num(_local1);
        }
        private function reset_avatar_num(_arg1:int):void{
            Tracer.out(("reset_avatar_num : " + _arg1));
            if (this.avatar_mc == null)
            {
                return;
            };
            if (this.avatar_looks == null)
            {
                return;
            };
            var _local2:XML = this.avatar_looks.AVATAR[_arg1];
            if (_local2 == null)
            {
                return;
            };
            var _local3:int = _local2.item.length();
            avatar_controller.remove_all();
            avatar_controller.reset_zoom();
        }
        private function set_avatar_zoom(_arg1:MouseEvent):void{
            avatar_controller.set_avatar_zoom((this.looks_ui.zoom_btn.currentFrame == 1), this.looks_ui.zoom_btn);
        }
        private function add_vote(_arg1:MouseEvent):void{
            var _local2:Number;
            var _local3:int;
            if (button_mode)
            {
                _local2 = _arg1.currentTarget.index;
                _local3 = 1;
                while (_local3 < _local2)
                {
                    this.looks_ui[("star" + _local3)].gold_mc.visible = true;
                    _local3++;
                };
                this.looks_ui[("star" + _local2)].num_txt.visible = true;
                DataManager.getInstance().register_vote(this.avatar_looks.AVATAR[this.counter].@ID, _local2, this.avatar_looks.AVATAR[this.counter].@UID, this);
                button_mode = false;
                this.show_next_look();
            };
        }
        function reset_vote_stars():void{
            var _local1:MovieClip;
            if (this.looks_ui.stage == null)
            {
                return;
            };
            this.looks_ui.visible = true;
            var _local2:int = 1;
            while (_local2 <= 5)
            {
                _local1 = this.looks_ui[("star" + _local2)];
                _local1.gold_mc.visible = false;
                _local1.num_txt.visible = false;
                _local2++;
            };
            this.looks_ui.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.set_vote_stars_rollover, false, 0, true);
        }
        private function set_vote_stars_rollover(_arg1:MouseEvent):void{
            var _local2:MovieClip;
            var _local3:int;
            if (this.looks_ui.stage == null)
            {
                Main.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.set_vote_stars_rollover);
                return;
            };
            this.looks_ui.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.set_vote_stars_rollover);
            var _local4:int = 1;
            while (_local4 <= 5)
            {
                _local2 = this.looks_ui[("star" + _local4)];
                if (_local2.hitTestPoint(_arg1.stageX, _arg1.stageY))
                {
                    _local3 = 1;
                    while (_local3 <= _local2.index)
                    {
                        this.looks_ui[("star" + _local3)].gold_mc.visible = true;
                        _local3++;
                    };
                    _local2.num_txt.visible = true;
                };
                _local4++;
            };
        }
        private function light_star(_arg1:MouseEvent):void{
            var _local2:int = _arg1.currentTarget.index;
            var _local3:int = 1;
            while (_local3 <= 5)
            {
                this.looks_ui[("star" + _local3)].gold_mc.visible = (_local3 <= _local2);
                if (_local3 == _local2)
                {
                    this.looks_ui[("star" + _local3)].num_txt.visible = true;
                    this.looks_ui[("star" + _local3)].num_txt.text = String(_local3);
                } else
                {
                    this.looks_ui[("star" + _local3)].num_txt.visible = false;
                };
                _local3++;
            };
        }
        private function show_runway_time(_arg1:Event=null):void{
            var _local2:int;
            this.runway.timer.timer_txt.text = TopMenu.getInstance().getRunwayCountdownText();
            if (this.runway.timer.timer_txt.text == "00:00:00")
            {
                Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Today's Contest has ended!");
                _local2 = 0;
                while (_local2 < this.total_looks)
                {
                    this.avatar_looks.AVATAR[_local2].@DAY = 0;
                    _local2++;
                };
                if (this.vote_display.today_txt)
                {
                    this.vote_display.today_txt.text = "0";
                };
            };
        }
        function hide_fabulous_popup(_arg1:MouseEvent):void{
            if (this.runway.stage)
            {
                this.welcome_clicks++;
                if (this.welcome_clicks >= 1)
                {
                    this.runway.removeEventListener(MouseEvent.MOUSE_DOWN, this.hide_fabulous_popup);
                    this.runway.fabulous_popup.visible = false;
                };
            } else
            {
                this.runway.removeEventListener(MouseEvent.MOUSE_DOWN, this.hide_fabulous_popup);
            };
        }
        function avatar_node_from_object(_arg1:Object):XML{
            var _local2:XML;
            var _local3:Item;
            var _local4:XML;
            var _local5:XML;
            var _local10:int;
            var _local6:XML = <AVATAR/>
            ;
            _local6.@UID = DataManager.user_id;
            var _local7:UserData = UserData.getInstance();
            _local6.@NAME = _local7.user_name;
            _local6.@VOTES = "0";
            _local6.@WEEK = _local7.week_votes;
            _local6.@DAY = _local7.day_votes;
            _local6.@ID = _arg1.id;
            _local6.@URL = ("http://www.facebook.com/profile.php?id=" + DataManager.user_id);
            _local6.@TEAM = ((_local7.team) ? _local7.team.id : "");
            var _local8:Array = _arg1.itemids.split(",");
            var _local9:int = _local8.length;
            while (_local10 < _local9)
            {
                _local2 = <item/>
                ;
                _local2.@id = _local8[_local10];
                _local3 = (_arg1.items[_local10] as Item);
                _local4 = new (XML)((("<swf>" + _local3.swf) + "</swf>"));
                _local5 = new (XML)((("<category>" + _local3.category.toUpperCase()) + "</category>"));
                _local2.appendChild(_local4);
                _local2.appendChild(_local5);
                _local6.appendChild(_local2);
                _local10++;
            };
            if (_arg1.pet_items)
            {
                _local8 = _arg1.pet_items.split(",");
                _local9 = _local8.length;
                if (_local9 > 0)
                {
                    Tracer.out("creating pet item nodes for fresh user avatar");
                };
                _local10 = 0;
                while (_local10 < _local9)
                {
                    _local2 = <item/>
                    ;
                    _local2.@id = _local8[_local10];
                    _local4 = new (XML)((("<swf>" + _arg1.pet_swfs[_local10]) + "</swf>"));
                    _local5 = new (XML)((("<category>" + _arg1.pet_categories[_local10].toUpperCase()) + "</category>"));
                    _local2.appendChild(_local4);
                    _local2.appendChild(_local5);
                    Tracer.out(("new pet item node is " + _local2.toString()));
                    _local6.appendChild(_local2);
                    _local10++;
                };
            };
            var _local11:XML = new XML((('<SWF NAME="STYLES">' + _arg1.styles) + "</SWF>"));
            var _local12:XML = new XML((('<SWF NAME="COLORS">' + _arg1.colors) + "</SWF>"));
            var _local13:XML = new XML((('<SWF NAME="SKINTONE">' + _arg1.skintone) + "</SWF>"));
            var _local14:XML = new XML((('<SWF NAME="EYESHADE">' + _arg1.eyeshade) + "</SWF>"));
            var _local15:XML = new XML((('<SWF NAME="EYEBROWS">' + _arg1.eyebrows) + "</SWF>"));
            var _local16:XML = new XML((('<SWF NAME="BLUSH">' + _arg1.blush) + "</SWF>"));
            _local6.appendChild(_local11);
            _local6.appendChild(_local12);
            _local6.appendChild(_local13);
            _local6.appendChild(_local14);
            _local6.appendChild(_local15);
            _local6.appendChild(_local16);
            Tracer.out(("new look is " + _local6));
            return (_local6);
        }
        function xml_summary(_arg1:XML):String{
            var _local2:int;
            var _local5:Boolean;
            var _local6:int;
            var _local3:int = _arg1.children().length();
            var _local4:* = (("Runway > xml_summary: " + _local3) + " total AVATAR nodes");
            for (;_local6 < _local3;_local6++)
            {
                _local2 = int(_arg1.AVATAR[_local6].@ID);
                if ((((_local5 == false)) && ((_local2 == 0))))
                {
                    _local5 = true;
                    _local4 = (_local4 + ("\n  <AVATAR> id=0 starting at node " + _local6));
                } else
                {
                    if (((_local5) && (!((_local2 == 0)))))
                    {
                        _local5 = false;
                        _local4 = (_local4 + ("\n  <AVATAR> id=0 starting at node " + _local6));
                    } else
                    {
                        if (((_local5) && ((_local2 == 0)))) continue;
                    };
                    _local4 = (_local4 + ((("\n  <AVATAR> node " + _local6) + ": id=") + _local2));
                };
            };
            return (_local4);
        }
        function init_friend_pool():void{
            this.friend_pool = UserData.getInstance().friends.concat();
            this.friend_pool_length = this.friend_pool.length;
        }
        function get_random_friend():Friend{
            if (this.friend_pool_length == 0)
            {
                return (null);
            };
            var _local1:Friend = Friend(Util.random_item(this.friend_pool));
            Util.remove(this.friend_pool, _local1);
            if (this.friend_pool.length == 0)
            {
                this.init_friend_pool();
            };
            return (_local1);
        }
        function init_friend_buttons():void{
            var _local1:MovieClip;
            var _local2:int = 1;
            while (_local2 <= 3)
            {
                _local1 = (this.runway.bg[("friend" + _local2)] as MovieClip);
                _local1.visible = false;
                Util.simpleButton(_local1, this.invite_friend);
                _local2++;
            };
        }
        function invite_friend(_arg1:Event){
            var _local2:Friend = _arg1.currentTarget.friend;
            FacebookConnector.invite_friend(_local2, "Please vote for my looks on the Fashionista FaceOff Runway!", "Get more votes!");
        }
        function show_friends():void{
            var _local1:Friend;
            var _local2:MovieClip;
            var _local3:ImageLoader;
            var _local4:int = 1;
            while (_local4 <= 3)
            {
                _local1 = this.get_random_friend();
                if (_local1)
                {
                    Tracer.out(("show_friends > will show " + _local1.name));
                    _local2 = (this.runway.bg[("friend" + _local4)] as MovieClip);
                    Util.removeChildren(_local2.pic);
                    _local2.visible = true;
                    _local2.friend = _local1;
                    _local3 = new ImageLoader(_local1.pic, _local2.pic, 50, 50);
                };
                _local4++;
            };
        }
        function hide_friends():void{
            var _local1:MovieClip;
            var _local2:int = 1;
            while (_local2 <= 3)
            {
                _local1 = (this.runway.bg[("friend" + _local2)] as MovieClip);
                _local1.visible = false;
                _local2++;
            };
        }
        function take_snapshot(_arg1=null):void{
            Util.stopClip(this.runway.bg);
            var _local2:SnapshotController = SnapshotController.getInstance();
            _local2.show_with_avatar(this.avatar_mc, avatar_controller);
        }
        function closed_snapshot_controller(_arg1=null):void{
            Util.playNestedClips(this.runway.bg);
        }

    }
}//package com.viroxoty.fashionista

