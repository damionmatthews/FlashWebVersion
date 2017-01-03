// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.Notification

package com.viroxoty.fashionista.ui{
    import flash.events.EventDispatcher;
    import flash.system.ApplicationDomain;
    import flash.display.Sprite;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.NotificationDO;
    import flash.display.MovieClip;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.events.IOErrorEvent;
    import flash.events.Event;
    import flash.text.TextFormat;
    import flash.text.TextField;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.net.*;
    import __AS3__.vec.*;
    import flash.text.*;
    import flash.display.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class Notification extends EventDispatcher {

        public static const FADE_OUT_SPEED_NORMAL:int = 0;
        public static const FADE_OUT_SPEED_SLOW:int = 1;
        public static const FADE_OUT_NONE:int = -1;
        private static const FADE_IN_TIME:Number = 0.3;
        private static const FADE_OUT_DELAY_NORMAL:Number = 3.5;
        private static const FADE_OUT_TIME_NORMAL:Number = 0.5;
        private static const FADE_OUT_DELAY_SLOW:Number = 7.5;
        private static const FADE_OUT_TIME_SLOW:Number = 0.5;
        public static const POSITION_CENTER:int = 0;
        public static const POSITION_TOP_RIGHT:int = 1;
        public static const POSITION_BOTTOM_LEFT:int = 2;
        public static const POSITION_TOP_LEFT:int = 3;
        public static const POSTIION_BOTTOM_RIGHT:int = 4;
        public static const MY_BOUTIQUE_DRAG:String = "my_boutique_drag";
        public static const MY_BOUTIQUE_RESIZE:String = "my_boutique_resize";
        public static const MY_BOUTIQUE_VISIT_WELCOME:String = "my_boutique_visit_welcome";
        public static const NOTICE:String = "notice";
        public static const SMALL_NOTICE:String = "small_notice";

        private static var _instance:Notification;

        private var appDomain:ApplicationDomain;
        var container:Sprite;
        var pending_notifications:Vector.<NotificationDO>;
        private var notification:MovieClip;

        public function Notification(){
            Tracer.out("New Notification");
            _instance = this;
            this.container = MainViewController.getInstance().notification_container;
            this.pending_notifications = new Vector.<NotificationDO>();
        }
        public static function getInstance():Notification{
            if (_instance == null)
            {
                _instance = new (Notification)();
            };
            return (_instance);
        }

        public function load_notifications():void{
            var _local1:* = ((Constants.SERVER_SWF + Constants.NOTIFICATION_FILENAME) + ".swf");
            Tracer.out(("Notification > load_notifications at " + _local1));
            var _local2:URLRequest = new URLRequest(_local1);
            var _local3:Loader = new Loader();
            _local3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.swf_loaded);
            _local3.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            _local3.load(_local2);
        }
        public function ioErrorHandler(_arg1:IOErrorEvent):void{
            Tracer.out(("Notification > ioErrorHandler: " + _arg1));
            MainViewController.getInstance().hide_preloader();
        }
        public function swf_loaded(_arg1:Event):void{
            Tracer.out("Notification > swf_loaded ");
            this.appDomain = (_arg1.target as LoaderInfo).applicationDomain;
            MainViewController.getInstance().hide_preloader();
            this.show_next();
        }
        public function add_notification(_arg1:String, ... _args):void{
            Tracer.out(((("Notification > add_notification : " + _arg1) + ", ") + _args.toString()));
            var _local3:NotificationDO = new NotificationDO();
            _local3.type = _arg1;
            _local3.args = _args;
            this.pending_notifications.push(_local3);
            if (this.appDomain == null)
            {
                Tracer.out("   notification swf not loaded yet!  Loading now..");
                MainViewController.getInstance().show_preloader();
                this.load_notifications();
                return;
            };
            if (this.notification == null)
            {
                this.show_next();
            };
        }
        public function clear_notifications():void{
            if (this.notification)
            {
                Tweener.removeTweens(this.notification);
            };
            while (this.container.numChildren > 0)
            {
                this.container.removeChildAt(0);
            };
            this.pending_notifications = new Vector.<NotificationDO>();
            this.notification = null;
        }
        public function show_notification_clip(_arg1:MovieClip, _arg2:int=0, _arg3:int=0){
            if (this.notification)
            {
                throw (new Error("already a current notification!"));
            };
            this.notification = _arg1;
            this.container.addChild(this.notification);
            this.position(_arg3);
            this.show_notification();
            this.notification.addEventListener(MouseEvent.CLICK, this.remove, false, 0, true);
            this.set_fade_out(_arg2);
        }
        public function notice(_arg1:String, _arg2:int=2):void{
            this.add_notification(NOTICE, _arg1, _arg2);
        }
        public function small_notice(_arg1:String):void{
            this.add_notification(SMALL_NOTICE, _arg1);
        }
        function show_next():void{
            var _local1:NotificationDO;
            if (this.notification)
            {
                return;
            };
            var _local2:int = this.pending_notifications.length;
            if (_local2 > 0)
            {
                _local1 = this.pending_notifications.shift();
                Tracer.out(("Notification > show_next: " + _local1.type));
                this.display_notification.apply(null, [_local1.type].concat(_local1.args));
            } else
            {
                Tracer.out("Notification > show_next: no more notifications to show");
            };
        }
        function display_notification(_arg1:String, ... _args):void{
            Tracer.out(((("Notification > display_notification : " + _arg1) + ", ") + _args.toString()));
            if (this.appDomain.hasDefinition(_arg1) == false)
            {
                Tracer.out(("   error: no definition found for " + _arg1));
                return;
            };
            var _local3:Class = Class(this.appDomain.getDefinition(_arg1));
            this.notification = (new (_local3)() as MovieClip);
            this.notification.name = _arg1;
            if (this.hasOwnProperty(("setup_" + _arg1)))
            {
                this[("setup_" + _arg1)].apply(null, _args);
            };
            this.container.addChild(this.notification);
            this.notification.addEventListener(MouseEvent.CLICK, this.remove, false, 0, true);
        }
        function position(_arg1:int):void{
            switch (_arg1)
            {
                case POSITION_CENTER:
                default:
                    this.notification.x = (Constants.SCREEN_WIDTH / 2);
                    this.notification.y = (Constants.SCREEN_HEIGHT / 2);
                    if (this.notification.name == NOTICE)
                    {
                        this.notification.x = (this.notification.x - 122);
                        this.notification.y = (this.notification.y - 107);
                    };
                    return;
                case POSITION_TOP_RIGHT:
                    this.notification.x = 570;
                    this.notification.y = 20;
                    return;
                case POSITION_BOTTOM_LEFT:
                    this.notification.x = -51;
                    this.notification.y = 508;
                    return;
                case POSITION_TOP_LEFT:
                    this.notification.x = -41;
                    this.notification.y = 0;
                    return;
                case POSTIION_BOTTOM_RIGHT:
                    this.notification.x = 557;
                    this.notification.y = 334;
            };
        }
        function set_fade_out(_arg1:int=0):void{
            switch (_arg1)
            {
                case FADE_OUT_SPEED_NORMAL:
                default:
                    Tweener.addTween(this.notification, {
                        "alpha":0,
                        "time":FADE_OUT_TIME_NORMAL,
                        "delay":FADE_OUT_DELAY_NORMAL,
                        "transition":"linear",
                        "onComplete":this.remove
                    });
                    return;
                case FADE_OUT_SPEED_SLOW:
                    Tweener.addTween(this.notification, {
                        "alpha":0,
                        "time":FADE_OUT_TIME_SLOW,
                        "delay":FADE_OUT_DELAY_SLOW,
                        "transition":"linear",
                        "onComplete":this.remove
                    });
                case FADE_OUT_NONE:
            };
        }
        function show_notification():void{
            this.notification.alpha = 0;
            Tweener.addTween(this.notification, {
                "alpha":1,
                "time":FADE_IN_TIME,
                "transition":"linear"
            });
        }
        function remove(_arg1=null){
            Tweener.removeTweens(this.notification);
            this.notification.removeEventListener(MouseEvent.CLICK, this.remove);
            if (((this.notification) && (this.container.contains(this.notification))))
            {
                this.container.removeChild(this.notification);
            };
            this.notification = null;
            this.show_next();
        }
        public function setup_my_boutique_drag():void{
            this.position(POSTIION_BOTTOM_RIGHT);
            this.set_fade_out(FADE_OUT_SPEED_SLOW);
        }
        public function setup_my_boutique_resize():void{
            this.position(POSTIION_BOTTOM_RIGHT);
            this.set_fade_out(FADE_OUT_SPEED_SLOW);
        }
        public function setup_my_boutique_visit_welcome(_arg1:String):void{
            this.position(POSITION_CENTER);
            this.set_fade_out();
            this.format_text(this.notification.name_txt, (_arg1 + "'s"));
        }
        public function setup_notice(_arg1:String, _arg2:int=2):void{
            this.position(_arg2);
            this.set_fade_out();
            this.format_text(this.notification.message_txt, _arg1);
        }
        public function setup_small_notice(_arg1:String):void{
            this.notification.x = 11;
            this.notification.y = 601;
            this.set_fade_out();
            this.format_text(this.notification.message_txt, _arg1);
        }
        function format_text(_arg1:TextField, _arg2:String=null){
            var _local3:TextFormat = new TextFormat();
            _local3.bold = true;
            _arg1.defaultTextFormat = _local3;
            if (_arg2)
            {
                _arg1.text = _arg2;
                Util.verticallyCenterText(_arg1);
            };
        }

    }
}//package com.viroxoty.fashionista.ui

