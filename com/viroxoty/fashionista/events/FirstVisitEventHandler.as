// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.events.FirstVisitEventHandler

package com.viroxoty.fashionista.events{
    import flash.events.Event;
    import flash.display.MovieClip;
    import flash.events.EventDispatcher;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class FirstVisitEventHandler {

        private static var _instance:FirstVisitEventHandler;

        public function FirstVisitEventHandler(){
            Tracer.out("new FirstVisitEventHandler");
            MainViewController.getInstance().addEventListener(MainViewController.FIRST_SCREEN_READY, this.show_intro_popup1, false, 0, true);
            Main.getInstance().addEventListener(Events.GAME_EVENT, this.dressing_room_open_closet);
        }
        public static function getInstance():FirstVisitEventHandler{
            if (_instance == null)
            {
                _instance = new (FirstVisitEventHandler)();
            };
            return (_instance);
        }

        function show_intro_popup1(_arg1:Event):void{
            Tracer.out("FirstVisitEventHandler > show_intro_popup1", false);
            MainViewController.getInstance().removeEventListener(MainViewController.FIRST_SCREEN_READY, this.show_intro_popup1);
            PopupIntro.getInstance().display_popup(PopupIntro.WELCOME1);
        }
        function dressing_room_open_closet(_arg1:GameEvent):void{
            var _local2:MovieClip;
            Tracer.out(("FirstVisitEventHandler > dressing_room_open_closet : " + _arg1.code), false);
            if (_arg1.code == Events.DRESSING_ROOM_DISPLAY_CLOSET)
            {
                Main.getInstance().removeEventListener(Events.GAME_EVENT, this.dressing_room_open_closet);
                Tracker.track_first_time(Tracker.OPEN_CLOSET);
                _local2 = DressingRoom.getCurrentInstance().view;
                _local2.tip1.visible = true;
                _local2.addChild(_local2.tip1);
                DressingRoom.getCurrentInstance().hide_enter_look();
                Main.getInstance().addEventListener(Events.GAME_EVENT, this.dressing_room_add_item);
                Pop_Up.getInstance().load_popups();
            };
        }
        function dressing_room_add_item(_arg1:GameEvent):void{
            var _local2:MovieClip;
            Tracer.out("FirstVisitEventHandler > dressing_room_add_item", false);
            if (_arg1.code == Events.DRESSING_ROOM_ADD_ITEM)
            {
                Main.getInstance().removeEventListener(Events.GAME_EVENT, this.dressing_room_add_item);
                _local2 = DressingRoom.getCurrentInstance().view;
                _local2.tip1.visible = false;
                _local2.tip2.visible = true;
                _local2.addChild(_local2.tip2);
                _local2.makeup_tip.visible = true;
                _local2.addChild(_local2.makeup_tip);
                DressingRoom.getCurrentInstance().show_enter_look();
                Main.getInstance().addEventListener(Events.GAME_EVENT, this.dressing_room_open_makeup);
            };
        }
        function dressing_room_open_makeup(_arg1:GameEvent):void{
            var _local2:MovieClip;
            Tracer.out("FirstVisitEventHandler > dressing_room_open_makeup", false);
            if (_arg1.code == Events.DRESSING_ROOM_DISPLAY_MAKEUP)
            {
                Main.getInstance().removeEventListener(Events.GAME_EVENT, this.dressing_room_open_makeup);
                Tracker.track_first_time(Tracker.OPEN_HAIR_MAKEUP);
                _local2 = DressingRoom.getCurrentInstance().view;
                _local2.tip2.visible = false;
                _local2.makeup_tip.visible = false;
                _local2.tip3.visible = true;
                _local2.enter_contest_tip.visible = true;
                _local2.addChild(_local2.tip3);
                _local2.addChild(_local2.enter_contest_tip);
                Main.getInstance().addEventListener(Events.GAME_EVENT, this.dressing_room_close_makeup);
            };
        }
        function dressing_room_close_makeup(_arg1:GameEvent):void{
            var _local2:MovieClip;
            Tracer.out("FirstVisitEventHandler > dressing_room_close_makeup", false);
            if (_arg1.code == Events.DRESSING_ROOM_DISPLAY_CLOSET)
            {
                _local2 = DressingRoom.getCurrentInstance().view;
                _local2.tip3.visible = false;
            } else
            {
                if ((((_arg1.code == Events.DRESSING_ROOM_ENTERED_CONTEST)) || ((_arg1.code == Events.DRESSING_ROOM_DESTROY))))
                {
                    Main.getInstance().removeEventListener(Events.GAME_EVENT, this.dressing_room_close_makeup);
                    _local2 = DressingRoom.getCurrentInstance().view;
                    _local2.tip3.visible = false;
                    _local2.enter_contest_tip.visible = false;
                };
            };
        }
        public function listen_interaction(_arg1:EventDispatcher, _arg2:String, _arg3:Function):void{
            _arg1.addEventListener(_arg2, _arg3);
        }
        public function remove_listener(_arg1:EventDispatcher, _arg2:String, _arg3:Function):void{
            _arg1.removeEventListener(_arg2, _arg3);
        }

    }
}//package com.viroxoty.fashionista.events

