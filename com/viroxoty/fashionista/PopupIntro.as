// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.PopupIntro

package com.viroxoty.fashionista{
    import flash.display.Sprite;
    import flash.system.ApplicationDomain;
    import flash.display.MovieClip;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.*;
    import flash.net.*;
    import com.viroxoty.fashionista.boutique.*;
    import flash.text.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.sound.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class PopupIntro extends Sprite {

        public static const BOUTIQUE_VISIT_TIP:String = "boutique_visit_tip";
        public static const FACEOFF_SHOPPING_TIP:String = "faceoff_shopping_tip";
        public static const MY_BOUTIQUE_START:String = "my_boutique_start";
        public static const MY_BOUTIQUE_TIP:String = "my_boutique_tip";
        public static const SHOPPING_TIP:String = "shopping_tip";
        public static const TUTORIAL_END:String = "tutorial_end";
        public static const WELCOME1:String = "welcome1";
        public static const WELCOME2:String = "welcome2";
        public static const WELCOME3:String = "welcome3";
        public static const WELCOME4:String = "welcome4";
        public static const WELCOME5:String = "welcome5";
        public static const CLOSED_POPUP:String = "CLOSED_POPUP";

        private static var _instance:PopupIntro;

        private var popupAppDomain:ApplicationDomain;
        var container:Sprite;
        var pending_popup:Object;
        private var popup:MovieClip;
        private var step:int = 1;

        public function PopupIntro(){
            Tracer.out("New PopupIntro");
            _instance = this;
            this.container = MainViewController.getInstance().pop_up_container;
        }
        public static function getInstance():PopupIntro{
            if (_instance == null)
            {
                _instance = new (PopupIntro)();
            };
            return (_instance);
        }

        public function load_swf():void{
            var _local1:* = ((Constants.SERVER_SWF + Constants.POPUPS_INTRO_FILENAME) + ".swf");
            var _local2:URLRequest = new URLRequest(_local1);
            Tracer.out(("PopupIntro > loading " + _local1));
            var _local3:Loader = new Loader();
            _local3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.popup_swf_loaded);
            _local3.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            _local3.load(_local2);
        }
        public function popup_swf_loaded(_arg1:Event):void{
            Tracer.out("PopupIntro > popups_intro_swf_loaded ");
            this.popupAppDomain = (_arg1.target as LoaderInfo).applicationDomain;
            if (this.pending_popup)
            {
                Tracer.out(("   showing pending popup: " + this.pending_popup.type));
                this.display_popup.apply(null, [this.pending_popup.type].concat(this.pending_popup.args));
            };
        }
        private function ioErrorHandler(_arg1:IOErrorEvent):void{
            Tracer.out(("ioErrorHandler: " + _arg1));
        }
        public function show_intro_popup():void{
            this.display_popup(WELCOME1);
        }
        public function display_popup(_arg1:String, ... _args):void{
            Tracer.out(((("PopupIntro > display_popup : " + _arg1) + ", ") + _args.toString()));
            if (this.popupAppDomain == null)
            {
                Tracer.out((("   popups_intro_swf_loaded swf not loaded yet!  " + _arg1) + " will show pending load"));
                this.pending_popup = {
                    "type":_arg1,
                    "args":_args
                };
                this.load_swf();
                return;
            };
            MainViewController.getInstance().show_popup_blocker();
            if (this.popupAppDomain.hasDefinition(_arg1) == false)
            {
                Tracer.out(("   error: no definition found for " + _arg1));
                return;
            };
            var _local3:Class = Class(this.popupAppDomain.getDefinition(_arg1));
            this.popup = new (_local3)();
            this.container.addChild(this.popup);
            this.popup.name = _arg1;
            if (this.hasOwnProperty(("setup_" + _arg1)))
            {
                this[("setup_" + _arg1)].apply(null, _args);
            };
        }
        public function setup_boutique_visit_tip(callback:Function=null):void{
            var remove:Function;
            remove = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                if (callback != null)
                {
                    callback();
                };
            };
            this.popup.enter_btn.buttonMode = true;
            this.popup.enter_btn.addEventListener(MouseEvent.CLICK, remove);
        }
        public function setup_my_boutique_tip():void{
            this.popup.enter_btn.buttonMode = true;
            this.popup.enter_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
        }
        public function setup_faceoff_shopping_tip(_arg1:Boolean):void{
            this.setup_shopping_tip();
            this.popup.message_txt.gotoAndStop(((_arg1) ? 1 : 2));
        }
        public function setup_my_boutique_start():void{
            var click_next:Function;
            click_next = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                if (Main.getInstance().current_section != Constants.SECTION_MY_BOUTIQUE)
                {
                    MyBoutique.getInstance().load();
                } else
                {
                    display_popup(MY_BOUTIQUE_TIP);
                };
            };
            this.popup.next_btn.buttonMode = true;
            this.popup.next_btn.addEventListener(MouseEvent.CLICK, click_next);
            DataManager.getInstance().credit_user(Constants.REASON_START_MY_BOUTIQUE);
        }
        public function setup_shopping_tip():void{
            var go_shopping:Function;
            go_shopping = function (_arg1:MouseEvent){
                remove_pop_up(_arg1);
                if (((!((Main.getInstance().current_section == Constants.SECTION_BOUTIQUE))) && (!((Main.getInstance().current_section == Constants.SECTION_MY_BOUTIQUE)))))
                {
                    BoutiqueManager.getInstance().setup_boutique_by_name("dresses");
                };
            };
            UserData.getInstance().shopping_welcome = false;
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, go_shopping);
            PelletFactory.make_cash_pellet((Constants.STARTING_CASH / 4), 1.5);
            PelletFactory.make_cash_pellet((Constants.STARTING_CASH / 4), 1.5);
            PelletFactory.make_cash_pellet((Constants.STARTING_CASH / 4), 1.5);
            PelletFactory.make_cash_pellet((Constants.STARTING_CASH / 4), 1.5);
            SoundEffectManager.getInstance().play_pellet_drop();
            if (Tracker.first_time_shopping_welcome == false)
            {
                (Tracker.first_time_shopping_welcome == true);
                Tracker.track(Tracker.SHOPPING_WELCOME, Tracker.FIRST_TIME);
            };
        }
        public function setup_tutorial_end():void{
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            (Tracker.first_time_tutorial_end == true);
            Tracker.track_first_time(Tracker.TUTORIAL_END);
            DataManager.getInstance().credit_user(Constants.REASON_COMPLETE_TUTORIAL);
        }
        public function setup_welcome1():void{
            var next_welcome:Function;
            next_welcome = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                Tracer.out(("PopupIntro > next_welcome: step is " + step));
                if (step == 1)
                {
                    Tracker.track_first_time(Tracker.OKAY);
                } else
                {
                    Tracker.track_first_time(("next" + (step - 1)));
                };
                step = 5;
                DressingRoom.getNewInstance().load();
                display_popup(("welcome" + step));
            };
            this.popup.next_btn.buttonMode = true;
            this.popup.next_btn.addEventListener(MouseEvent.CLICK, next_welcome);
        }
        public function setup_welcome5():void{
            var welcome_finish:Function;
            welcome_finish = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                Tracker.track_first_time(Tracker.GET_DRESSED);
                TopMenu.getInstance().revertSoundControl();
            };
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, welcome_finish);
        }
        private function remove_pop_up(_arg1:MouseEvent):void{
            Tracer.out("PopupIntro > remove_pop_up");
            var _local2:MovieClip = _arg1.currentTarget.parent;
            if (this.container.contains(_local2))
            {
                this.container.removeChild(_local2);
            };
            if (this.container.numChildren == 0)
            {
                MainViewController.getInstance().hide_popup_blocker();
                dispatchEvent(new Event(CLOSED_POPUP));
            };
        }
        function check_close_popup(_arg1:MouseEvent):void{
            if (this.popup.hitTestPoint(_arg1.stageX, _arg1.stageY))
            {
                return;
            };
            this.remove_pop_up(_arg1);
        }

    }
}//package com.viroxoty.fashionista

