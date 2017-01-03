// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.TopMenu

package com.viroxoty.fashionista{
    import flash.events.EventDispatcher;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.text.TextFormat;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.*;
    import flash.net.*;
    import com.viroxoty.fashionista.boutique.*;
    import flash.text.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class TopMenu extends EventDispatcher {

        public static const CLICKED_TOP_MENU:String = "CLICKED_TOP_MENU";
        static const CHALLENGE_TOTAL_SECS:int = 604800;

        private static var _instance;
        public static var contest_text:String;
        static var contest_id:String;

        public var menu:MovieClip;
        private var cur_selected:MovieClip;
        private var pop_obj:Pop_Up;
        public var show_challenge_popup:Boolean = false;
        var pink_mask_start_width:Number;

        public function TopMenu(){
            _instance = this;
            Tracer.out("New TopMenu");
            this.pop_obj = Pop_Up.getInstance();
        }
        public static function getInstance():TopMenu{
            if (_instance == null)
            {
                _instance = new (TopMenu)();
            };
            return (_instance);
        }
        public static function get_contest_text():String{
            return (contest_text);
        }
        public static function get_contest_id():String{
            return (contest_id);
        }

        public function set_contest_xml(_arg1:XML):void{
            Tracer.out(("TopMenu > set_contest_xml " + _arg1.toString()));
            var _local2:GameTimer = GameTimer.getInstance();
            var _local3:int = _arg1.DATA.WEEK_EXPIRY;
            var _local4:int = _arg1.DATA.DAY_EXPIRY;
            var _local5:int = _arg1.DATA.SERVER_TIME;
            _local2.setExpiry(_local3, _local4, _local5);
            contest_id = _arg1.DATA.CONTESTID;
            contest_text = _arg1.DATA.TEXT;
            var _local6:Number = this.menu.challenge_tip.challenge_txt.height;
            this.menu.challenge_tip.challenge_txt.text = contest_text;
            this.menu.challenge_tip.challenge_txt.y = (this.menu.challenge_tip.challenge_txt.y + ((_local6 - this.menu.challenge_tip.challenge_txt.textHeight) / 2));
            if (this.show_challenge_popup)
            {
                this.show_challenge_popup = false;
                this.display_challenge_alert();
            };
        }
        public function reload_challenge():void{
            this.show_challenge_popup = true;
            DataManager.getInstance().get_contest_xml(TopMenu.getInstance());
        }
        public function load_swf():void{
            var _local1:AssetDataObject = new AssetDataObject();
            _local1.parseURL((Constants.SERVER_SWF + Constants.TOP_MENU_SWF));
            AssetManager.getInstance().getAssetFor(_local1, this);
        }
        public function assetLoaded(_arg1:MovieClip, _arg2:String):void{
            Tracer.out(("TopMenu > assetLoaded: " + _arg2));
            this.menu = _arg1;
            MainViewController.getInstance().check_first_screen_swfs();
        }
        public function isReady():Boolean{
            return (!((this.menu == null)));
        }
        public function init():void{
            MainViewController.getInstance().header_container.addChild(this.menu);
            Util.setupButton(this.menu.city_mc, this.menu.city_mc.bg);
            Util.setupButton(this.menu.dress_mc, this.menu.dress_mc.bg);
            Util.setupButton(this.menu.myboutique_mc, this.menu.myboutique_mc.bg);
            Util.setupButton(this.menu.runway_mc, this.menu.runway_mc.bg);
            if (Main.getInstance().current_section == Constants.SECTION_CITY)
            {
                this.select_button(this.menu.city_mc);
            } else
            {
                if (Main.getInstance().current_section == Constants.SECTION_MY_BOUTIQUE)
                {
                    this.select_button(this.menu.myboutique_mc);
                };
            };
            this.menu.city_mc.addEventListener(MouseEvent.MOUSE_UP, this.open_menu_link);
            this.menu.dress_mc.addEventListener(MouseEvent.MOUSE_UP, this.open_menu_link);
            this.menu.runway_mc.addEventListener(MouseEvent.MOUSE_UP, this.open_menu_link);
            this.menu.myboutique_mc.addEventListener(MouseEvent.MOUSE_UP, this.open_menu_link);
            Tracer.out("TopMenu > init: set up nav buttons");
            Util.setupButton(this.menu.add_cash);
            this.menu.add_cash.addEventListener(MouseEvent.CLICK, this.open_menu_link);
            Util.create_tooltip("ADD FASHION CASH!", this.menu, "center", "top", this.menu.add_cash);
            Util.setupButton(this.menu.how_to_play);
            this.menu.how_to_play.addEventListener(MouseEvent.CLICK, this.open_menu_link);
            Util.create_tooltip("HOW TO PLAY", this.menu, "right", "top", this.menu.how_to_play);
            Util.setupButton(this.menu.winner_last_week);
            this.menu.winner_last_week.addEventListener(MouseEvent.CLICK, this.open_menu_link);
            Util.create_tooltip("SEE LAST WEEK'S WINNERS!", this.menu, "right", "top", this.menu.winner_last_week);
            Util.setupButton(this.menu.speaker_mc);
            this.menu.speaker_mc.mouseChildren = false;
            this.menu.speaker_mc.addEventListener(MouseEvent.CLICK, this.toggle_sound);
            Util.create_tooltip("SOUND ON/OFF", this.menu, "right", "top", this.menu.speaker_mc);
            if (BackGroundMusic.isMuted)
            {
                this.menu.speaker_mc.speakerX.visible = true;
                this.menu.speaker_mc.speakerFX.visible = false;
            } else
            {
                this.menu.speaker_mc.speakerX.visible = false;
                this.menu.speaker_mc.speakerFX.visible = true;
            };
            Util.setupButton(this.menu.gift_mc);
            this.menu.gift_mc.addEventListener(MouseEvent.CLICK, this.open_menu_link);
            Util.create_tooltip("FREE GIFTS, EARN CASH!", this.menu, "right", "top", this.menu.gift_mc);
            Util.setupButton(this.menu.message_mc);
            this.menu.message_mc.addEventListener(MouseEvent.CLICK, this.open_menu_link);
            Util.create_tooltip("OPEN THE MESSAGE CENTER", this.menu, "right", "top", this.menu.message_mc);
            Util.setupButton(this.menu.directory_mc);
            this.menu.directory_mc.addEventListener(MouseEvent.CLICK, this.open_menu_link);
            Util.create_tooltip("OPEN THE BOUTIQUE DIRECTORY!", this.menu, "right", "top", this.menu.directory_mc);
            Tracer.out("TopMenu > init: set up right buttons");
            Util.setupButton(this.menu.challenge_mc);
            this.menu.challenge_mc.addEventListener(MouseEvent.MOUSE_OVER, this.show_challenge);
            this.menu.challenge_mc.addEventListener(MouseEvent.MOUSE_OUT, this.hide_challenge);
            this.menu.challenge_mc.addEventListener(MouseEvent.CLICK, this.display_challenge_alert);
            this.pink_mask_start_width = this.menu.challenge_mc.pink_mask.width;
            this.menu.challenge_tip.visible = false;
            var _local1:TextFormat = new TextFormat();
            _local1.bold = true;
            this.menu.challenge_tip.challenge_txt.defaultTextFormat = _local1;
            Tracer.out("TopMenu > init: set up challenge UI");
            this.menu.timer_txt.defaultTextFormat = _local1;
            this.menu.points_mc.points_text.defaultTextFormat = _local1;
            this.menu.points_mc.level_text.defaultTextFormat = _local1;
            this.menu.cash_mc.cash_txt.defaultTextFormat = _local1;
            DataManager.getInstance().get_contest_xml(this);
        }
        public function display_points_level(_arg1:int, _arg2:int):void{
            this.menu.points_mc.points_text.text = String(_arg1);
            this.menu.points_mc.level_text.text = String(_arg2);
        }
        public function display_coins(_arg1:int):void{
            this.menu.cash_mc.cash_txt.text = _arg1;
        }
        public function display_time(_arg1:String, _arg2):void{
            this.menu.timer_txt.text = _arg1;
            this.menu.challenge_mc.pink_mask.width = ((this.pink_mask_start_width * (CHALLENGE_TOTAL_SECS - _arg2)) / CHALLENGE_TOTAL_SECS);
        }
        public function getRunwayCountdownText():String{
            var _local1:Array = this.menu.timer_txt.text.split(":");
            _local1.splice(0, 1);
            return (_local1.join(":"));
        }
        public function set_selected(_arg1:String){
            if (this.menu == null)
            {
                return;
            };
            switch (_arg1)
            {
                case Constants.SECTION_CITY:
                    this.select_button(this.menu.city_mc);
                    return;
                case Constants.SECTION_RUNWAY:
                    this.select_button(this.menu.runway_mc);
                    return;
                case Constants.SECTION_DRESSING_ROOM:
                    this.select_button(this.menu.dress_mc);
                    return;
                case Constants.SECTION_MY_BOUTIQUE:
                    this.select_button(this.menu.myboutique_mc);
                    return;
                case null:
                    this.select_button(null);
                    return;
            };
        }
        public function set_inactive():void{
            if (this.menu)
            {
                this.menu.mouseChildren = false;
            };
        }
        public function set_active():void{
            this.menu.mouseChildren = true;
        }
        public function revertSoundControl():void{
            this.menu.addChild(MainViewController.getInstance().getTopLevelClipByName("speaker_mc"));
        }
        private function open_menu_link(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            switch (_local2.name)
            {
                case "city_mc":
                    this.select_button(_local2);
                    CityManager.getInstance().goto_city(1);
                    break;
                case "runway_mc":
                    this.select_button(_local2);
                    Runway.getInstance().load(Runway.SHOW_WELCOME);
                    break;
                case "dress_mc":
                    this.select_button(_local2);
                    DressingRoom.getNewInstance().load();
                    break;
                case "myboutique_mc":
                    this.select_button(_local2);
                    MyBoutique.getInstance().load();
                    break;
                case "how_to_play":
                    this.pop_obj.display_popup(Pop_Up.HOW_TO_PLAY);
                    break;
                case "add_cash":
                    External.addcash_window();
                    break;
                case "winner_last_week":
                    External.open_last_weeks_winners();
                    break;
                case "gift_mc":
                    BoutiqueManager.getInstance().setup_boutique_by_name("gift_store");
                    break;
                case "message_mc":
                    MessageCenter.getInstance().show_message_center();
                    break;
                case "directory_mc":
                    this.pop_obj.display_popup(Pop_Up.BOUTIQUE_DIRECTORY);
                    break;
                case "challenge_mc":
                    this.display_challenge_alert();
                    break;
            };
            dispatchEvent(new Event(TopMenu.CLICKED_TOP_MENU));
        }
        private function select_button(_arg1:MovieClip):void{
            if (this.cur_selected)
            {
                this.cur_selected.bg.gotoAndStop(1);
                this.cur_selected.buttonMode = true;
                this.cur_selected.mouseChildren = true;
                this.cur_selected.mouseEnabled = true;
            };
            if (_arg1)
            {
                _arg1.bg.gotoAndStop(3);
                _arg1.buttonMode = false;
                _arg1.mouseChildren = false;
                _arg1.mouseEnabled = false;
                this.cur_selected = _arg1;
            };
        }
        public function toggle_sound(_arg1:MouseEvent=null):void{
            Tracer.out(("toggle_sound : isMuted = " + BackGroundMusic.isMuted));
            if (BackGroundMusic.isMuted == true)
            {
                BackGroundMusic.isMuted = false;
                BackGroundMusic.getInstance().startMusic();
                this.menu.speaker_mc.speakerX.visible = false;
                this.menu.speaker_mc.speakerFX.visible = true;
            } else
            {
                BackGroundMusic.isMuted = true;
                BackGroundMusic.getInstance().stopMusic();
                this.menu.speaker_mc.speakerX.visible = true;
                this.menu.speaker_mc.speakerFX.visible = false;
            };
        }
        function show_challenge(_arg1:Event):void{
            this.menu.challenge_tip.visible = true;
        }
        function hide_challenge(_arg1:Event):void{
            this.menu.challenge_tip.visible = false;
        }
        private function display_challenge_alert(_arg1:MouseEvent=null):void{
            Pop_Up.getInstance().display_popup(Pop_Up.WEEKLY_CHALLENGE, contest_text);
        }

    }
}//package com.viroxoty.fashionista

