// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.MessageCenter

package com.viroxoty.fashionista{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Friend;
    import flash.system.ApplicationDomain;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.ui.LightScroller;
    import flash.text.TextFormat;
    import flash.utils.Timer;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.events.Event;
    import com.viroxoty.fashionista.messages.MessageDataObject;
    import com.viroxoty.fashionista.data.Item;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.messages.MessageViewController;
    import flash.events.TimerEvent;
    import com.viroxoty.fashionista.messages.AListFriendView;
    import com.viroxoty.fashionista.data.Team;
    import com.viroxoty.fashionista.ui.ImageLoader;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.net.*;
    import __AS3__.vec.*;
    import flash.utils.*;
    import com.viroxoty.fashionista.events.*;
    import flash.text.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.sound.*;
    import com.viroxoty.fashionista.asset.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.messages.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class MessageCenter extends EventDispatcher {

        static const SPACER:int = 5;
        static const MESSAGE_DELETE_SECS:Number = 0.4;
        static const A_LIST_SPACER:int = 10;
        public static const WELCOME:int = 0;
        public static const MESSAGES:int = 1;
        public static const A_LIST:int = 2;
        public static const TEAM:int = 3;

        private static var _instance:MessageCenter;

        private var pendingInit:Boolean = false;
        public var messages:Object;
        var all_messages:Array = null;
        var has_messages:Boolean;
        var has_unviewed_messages:Boolean;
        var unviewed_index:int = -1;
        var a_list:Vector.<Friend>;
        var vip_points:int;
        var teams:Array;
        private var appDomain:ApplicationDomain;
        private var message_center:MovieClip;
        private var message_view:MovieClip;
        var container:MovieClip;
        var containerStartY:Number;
        var scroller:LightScroller;
        var tf:TextFormat;
        var delay_timer:Timer;
        private var a_list_view:MovieClip;
        var a_list_container:MovieClip;
        var a_list_start_y:Number;
        private var team_view:MovieClip;
        private var select_team_view:MovieClip;
        public var mode:int;

        public function MessageCenter(){
            Tracer.out("new MessageCenter");
            this.tf = new TextFormat();
            this.tf.font = "Arial";
            this.tf.bold = true;
            this.delay_timer = new Timer(100, 1);
            this.delay_timer.addEventListener("timer", this.delay_timer_handler);
        }
        public static function getInstance():MessageCenter{
            if (_instance == null)
            {
                _instance = new (MessageCenter)();
            };
            return (_instance);
        }

        public function destroy():void{
            Tracer.out("MessageCenter > destroy");
            this.message_center = null;
            this.messages = null;
            this.all_messages = null;
            this.has_messages = false;
            this.a_list = null;
            this.message_view = null;
            this.a_list_view = null;
        }
        public function load_swf(){
            var _local1:* = ((Constants.SERVER_SWF + Constants.MESSAGE_CENTER_FILENAME) + ".swf");
            var _local2:URLRequest = new URLRequest(_local1);
            var _local3:Loader = new Loader();
            _local3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.asset_loaded);
            _local3.load(_local2);
        }
        public function asset_loaded(_arg1:Event):void{
            Tracer.out("MessageCenter > asset_loaded");
            this.appDomain = (_arg1.target as LoaderInfo).applicationDomain;
            if (this.pendingInit)
            {
                this.init_welcome();
            };
        }
        public function update_a_list():void{
            if (this.a_list == null)
            {
                return;
            };
            while (this.a_list_view.container.numChildren > 0)
            {
                this.a_list_view.container.removeChildAt(0);
            };
            this.a_list_view.container.y = this.a_list_start_y;
            DataManager.getInstance().get_a_list(this.a_list_loaded, this.a_list_load_failed);
        }
        function load_messages():void{
            MainViewController.getInstance().show_preloader();
            this.all_messages = [];
            DataManager.getInstance().get_messages();
        }
        public function messages_loaded(_arg1:Object):void{
            if (this.message_view.visible)
            {
                MainViewController.getInstance().hide_preloader();
            };
            this.set_messages(_arg1);
            this.show_messages();
        }
        public function set_messages(_arg1:Object):void{
            var _local2:String;
            var _local3:UserData;
            var _local4:Array;
            var _local5:int;
            var _local6:int;
            var _local7:MessageDataObject;
            var _local8:Object;
            var _local9:Item;
            var _local10:Item;
            this.messages = _arg1;
            this.has_unviewed_messages = false;
            Tracer.out("MessageCenter > checking messages object");
            this.all_messages = [];
            for (_local2 in this.messages)
            {
                Tracer.out(((("    " + _local2) + " is ") + this.messages[_local2]));
                _local4 = this.messages[_local2];
                _local5 = _local4.length;
                _local6 = 0;
                while (_local6 < _local5)
                {
                    _local7 = new MessageDataObject();
                    _local8 = _local4[_local6];
                    if (_local8.type != "")
                    {
                        _local7.parseMessageObj(_local8);
                        _local7.is_a_list = (((_local7.type)==MessageViewController.TYPE_A_LIST_ADD) ? 1 : 0);
                        this.all_messages.push(_local7);
                    };
                    _local6++;
                };
            };
            this.all_messages.sortOn(["is_a_list", "viewed", "timestamp"], [Array.NUMERIC, Array.NUMERIC, Array.DESCENDING]);
            _local3 = UserData.getInstance();
            if ((((Tracker.deleted_message_join_team == false)) && ((_local3.team == null))))
            {
                _local7 = new MessageDataObject();
                _local7.id = 5;
                _local7.setupJoinTeamMessage();
                this.all_messages.unshift(_local7);
            };
            if (Tracker.deleted_message_boutique == false)
            {
                if (((((_local3.has_boutique) && (_local3.has_active_boutique))) && ((_local3.boutique_earnings > 0))))
                {
                    _local7 = new MessageDataObject();
                    _local7.id = 4;
                    _local7.setupBoutiqueEarningsMessage(_local3.boutique_earnings);
                    this.all_messages.unshift(_local7);
                } else
                {
                    if (((_local3.has_boutique) && ((_local3.has_active_boutique == false))))
                    {
                        _local7 = new MessageDataObject();
                        _local7.id = 4;
                        _local7.setupLaunchBoutiqueMessage();
                        this.all_messages.unshift(_local7);
                    };
                };
            };
            if ((((Tracker.deleted_message_fashion_earnings == false)) && ((_local3.offline_data.coins > 0))))
            {
                _local7 = new MessageDataObject();
                _local7.id = 3;
                _local7.setupFashionEmpireEarningsMessage(_local3.offline_data.coins);
                this.all_messages.unshift(_local7);
            };
            if (DataManager.getInstance().free_item)
            {
                _local9 = DataManager.getInstance().free_item;
                if (_local3.owns(_local9))
                {
                    DataManager.getInstance().free_item = null;
                } else
                {
                    if (Tracker.deleted_message_daily_free_item == false)
                    {
                        _local7 = new MessageDataObject();
                        _local7.id = 2;
                        _local7.setupDailyFreeItemMessage(_local9);
                        this.all_messages.unshift(_local7);
                    };
                };
            };
            if (DataManager.getInstance().daily_deal_item)
            {
                _local10 = DataManager.getInstance().daily_deal_item;
                if (_local3.owns(_local10))
                {
                    DataManager.getInstance().daily_deal_item = null;
                } else
                {
                    if (Tracker.deleted_message_daily_deal == false)
                    {
                        _local7 = new MessageDataObject();
                        _local7.id = 1;
                        _local7.setupDailyDealMessage(_local10);
                        this.all_messages.unshift(_local7);
                    };
                };
            };
            this.has_messages = (this.all_messages.length > 0);
        }
        function load_a_list():void{
            MainViewController.getInstance().show_preloader();
            this.a_list = new Vector.<Friend>();
            DataManager.getInstance().get_a_list(this.a_list_loaded, this.a_list_load_failed);
        }
        function a_list_loaded(_arg1:Object):void{
            if (this.a_list_view.visible)
            {
                MainViewController.getInstance().hide_preloader();
            };
            this.a_list = UserData.getInstance().process_a_list_json(_arg1);
            this.show_a_list_data();
            if ((((this.a_list.length > 0)) && (this.a_list_view.visible)))
            {
                Tracker.track("open_non_blank", "a_list");
            };
        }
        function a_list_load_failed():void{
            MainViewController.getInstance().hide_preloader();
        }
        public function init_welcome():void{
            var _local1:Class;
            Tracer.out("init_welcome");
            if (this.appDomain == null)
            {
                this.pendingInit = true;
                return;
            };
            this.mode = WELCOME;
            _local1 = this.class_by_name("welcome_messages");
            this.message_view = new (_local1)();
            this.message_view.no_messages.visible = (this.has_messages == false);
            MainViewController.getInstance().addMessageCenter(this.message_view);
            MainViewController.getInstance().showMessageCenter();
            this.message_view.close_mc.buttonMode = true;
            this.message_view.close_mc.addEventListener(MouseEvent.CLICK, this.close_welcome, false, 0, true);
            var _local2:Object = UserData.getInstance().offline_data;
            this.message_view.votes_txt.defaultTextFormat = this.tf;
            this.message_view.votes_txt.text = String((int(_local2.votes) + int(_local2.pr_agent_votes)));
            this.message_view.fcash_txt.defaultTextFormat = this.tf;
            this.message_view.fcash_txt.text = _local2.coins;
            this.message_view.faceoffs_txt.defaultTextFormat = this.tf;
            this.message_view.faceoffs_txt.text = _local2.faceoffs_won;
            if (_local2.coins > 0)
            {
                PelletFactory.make_cash_pellet(_local2.coins);
                SoundEffectManager.getInstance().play_pellet_drop();
            };
            this.show_messages();
            dispatchEvent(new Event(EventHandler.MESSAGE_CENTER_INIT));
        }
        public function updateFCash(_arg1:int):void{
            if ((((this.mode == WELCOME)) && (this.message_view)))
            {
                this.message_view.fcash_txt.text = (int(this.message_view.fcash_txt.text) + _arg1);
            } else
            {
                Tracer.out("updateFCash > WelcomeCenter is not open!");
            };
        }
        public function close(_arg1:MouseEvent=null):void{
            MainViewController.getInstance().hideMessageCenter();
            this.destroy();
        }
        public function show_message_center():void{
            this.mode = MESSAGES;
            this.setup_message_center();
            this.select_messages();
            MainViewController.getInstance().showMessageCenter();
        }
        public function show_a_list():void{
            this.mode = A_LIST;
            this.setup_message_center();
            this.select_a_list();
            MainViewController.getInstance().showMessageCenter();
        }
        public function reload_a_list():void{
            this.close();
            this.show_a_list();
        }
        public function show_team():void{
            this.mode = TEAM;
            this.setup_message_center();
            this.select_team();
            MainViewController.getInstance().showMessageCenter();
        }
        function close_welcome(_arg1:MouseEvent):void{
            Tracer.out("MessageCenter > close_welcome");
            this.close(_arg1);
        }
        function share_stats(_arg1:MouseEvent):void{
            Util.fadeOut(this.message_view.share_btn);
            this.message_view.share_btn.buttonMode = false;
            this.message_view.share_btn.removeEventListener(MouseEvent.CLICK, this.share_stats);
            FacebookConnector.share_stats();
        }
        function setup_message_center():void{
            var _local1:Class = this.class_by_name("message_center");
            this.message_center = new (_local1)();
            this.message_center.close_mc.buttonMode = true;
            this.message_center.close_mc.addEventListener(MouseEvent.CLICK, this.close, false, 0, true);
            this.message_center.messages_tab.buttonMode = true;
            this.message_center.messages_tab.addEventListener(MouseEvent.CLICK, this.select_messages, false, 0, true);
            this.message_center.a_list_tab.buttonMode = true;
            this.message_center.a_list_tab.addEventListener(MouseEvent.CLICK, this.select_a_list, false, 0, true);
            this.message_center.team_tab.buttonMode = true;
            this.message_center.team_tab.addEventListener(MouseEvent.CLICK, this.select_team, false, 0, true);
            this.message_view = this.message_center.message_view;
            this.a_list_view = this.message_center.a_list_view;
            this.team_view = this.message_center.team_view;
            this.select_team_view = this.message_center.select_team_view;
            MainViewController.getInstance().addMessageCenter(this.message_center);
        }
        function select_messages(_arg1:MouseEvent=null):void{
            this.message_center.addChildAt(this.message_center.a_list_tab, (this.message_center.getChildIndex(this.message_center.frame) - 1));
            this.message_center.addChildAt(this.message_center.team_tab, (this.message_center.getChildIndex(this.message_center.frame) - 1));
            this.message_center.addChildAt(this.message_center.messages_tab, (this.message_center.getChildIndex(this.message_center.frame) + 1));
            this.a_list_view.visible = false;
            this.team_view.visible = false;
            this.select_team_view.visible = false;
            this.message_view.no_messages.visible = false;
            this.message_view.visible = true;
            if (this.all_messages == null)
            {
                this.load_messages();
            } else
            {
                if (this.all_messages.length == 0)
                {
                    this.message_view.no_messages.visible = true;
                };
            };
        }
        function show_messages(){
            var mdo:MessageDataObject;
            var mc:MovieClip;
            var index:int;
            var i:int;
            this.message_view.username_txt.defaultTextFormat = this.tf;
            this.message_view.username_txt.text = UserData.getInstance().user_name;
            if (this.message_view.no_messages)
            {
                this.message_view.no_messages.visible = (this.has_messages == false);
            };
            this.container = this.message_view.messageContainer;
            this.container.mask = this.message_view.mask_mc;
            this.containerStartY = this.container.y;
            this.scroller = new LightScroller(this.container, this);
            this.scroller.x = 680;
            this.scroller.y = this.container.y;
            this.scroller.visible = false;
            this.message_view.addChild(this.scroller);
            this.scroller.addEventListener(LightScroller.SCROLLED, this.didScrollEntries, false, 0, true);
            this.unviewed_index = 0;
            this.has_unviewed_messages = false;
            var viewed_messages:Array = [];
            var l:int = this.all_messages.length;
            for (;i < l;(i = (i + 1)))
            {
                mdo = this.all_messages[i];
                try
                {
                    mc = MessageViewController.make_message(mdo);
                } catch(e:Error)
                {
                    Tracer.out(("failed to make message of message id " + mdo.id));
                    continue;
                };
                if (mc != null)
                {
                    mc.x = 0;
                    mc.y = ((mc.height + SPACER) * index);
                    mc.bg.gotoAndStop(((index % 2) + 1));
                    this.container.addChild(mc);
                    if ((mc.y + mc.height) <= this.container.mask.height)
                    {
                        if (mdo.viewed == 0)
                        {
                            mdo.viewed = 1;
                            viewed_messages.push(mdo.id);
                        };
                    } else
                    {
                        if (this.has_unviewed_messages)
                        {
                            if ((((mdo.viewed == 0)) && ((this.has_unviewed_messages == false))))
                            {
                                this.has_unviewed_messages = true;
                                this.unviewed_index = index;
                            };
                        };
                    };
                    Tracer.out(("unviewed_index = " + this.unviewed_index));
                    index = (index + 1);
                };
            };
            Tracer.out(((("messages processed > unviewed_index = " + this.unviewed_index) + ", has_unviewed_messages = ") + this.has_unviewed_messages));
            if (viewed_messages.length > 0)
            {
                DataManager.getInstance().read_messages(viewed_messages.toString());
            };
            dispatchEvent(new Event(LightScroller.TARGET_CHANGED));
            if (this.container.height > this.container.mask.height)
            {
                this.scroller.visible = true;
            };
        }
        public function delete_message(messageVC:MessageViewController):void{
            var mdo:MessageDataObject;
            var newY:Number;
            var view:MovieClip;
            var newViewY:Number;
            var i:int;
            var l:int = this.all_messages.length;
            while (i < l)
            {
                mdo = this.all_messages[i];
                if (mdo.id == messageVC.data.id) break;
                i = (i + 1);
            };
            Tweener.addTween(messageVC.view, {
                "alpha":0,
                "time":MESSAGE_DELETE_SECS,
                "transition":"easeinoutsine",
                "onComplete":this.delete_done
            });
            l = this.all_messages.length;
            var newCH:Number = (this.container.height - (messageVC.view.height + SPACER));
            if ((this.container.y + newCH) <= (this.containerStartY + this.container.mask.height))
            {
                Tracer.out("container needs to move down");
                newY = (this.containerStartY - Math.max(0, (newCH - this.container.mask.height)));
                Tweener.addTween(this.container, {
                    "y":newY,
                    "time":MESSAGE_DELETE_SECS,
                    "transition":"easeinoutsine",
                    "onComplete":function (){
                    }
                });
            };
            var s:int = (i + 1);
            i = s;
            while (i < l)
            {
                mdo = this.all_messages[i];
                view = mdo.view;
                if (Tweener.isTweening(view))
                {
                    newViewY = (view.targetY - (view.height + SPACER));
                } else
                {
                    newViewY = (view.y - (view.height + SPACER));
                };
                view.targetY = newViewY;
                Tweener.addTween(view, {
                    "y":newViewY,
                    "time":MESSAGE_DELETE_SECS,
                    "transition":"easeinoutsine",
                    "onComplete":function (){
                    }
                });
                i = (i + 1);
            };
        }
        public function delete_done():void{
            Tracer.out("delete_done");
            this.delay_timer.start();
        }
        function delay_timer_handler(_arg1:TimerEvent):void{
            var _local2:MessageDataObject;
            this.delay_timer.stop();
            this.delay_timer.reset();
            var _local3:int = this.all_messages.length;
            var _local4:int = (_local3 - 1);
            while (_local4 >= 0)
            {
                _local2 = this.all_messages[_local4];
                if (_local2.view.alpha == 0)
                {
                    this.container.removeChild(_local2.view);
                    this.all_messages.splice(_local4, 1);
                };
                _local4--;
            };
            _local3 = this.all_messages.length;
            _local4 = 0;
            while (_local4 < _local3)
            {
                _local2 = this.all_messages[_local4];
                _local2.view.bg.gotoAndStop(((_local4 % 2) + 1));
                _local4++;
            };
            Tracer.out(("delay_timer_handler > container.height is " + this.container.height));
            if (this.container.height <= this.container.mask.height)
            {
                this.scroller.visible = false;
            } else
            {
                dispatchEvent(new Event(LightScroller.TARGET_CHANGED));
            };
        }
        function message_viewed(_arg1:MessageDataObject):void{
            _arg1.viewed = 1;
            DataManager.getInstance().read_messages(String(_arg1.id));
        }
        public function didScrollEntries(_arg1:Event){
            var _local2:int;
            var _local3:int;
            var _local4:MessageDataObject;
            var _local5:MovieClip;
            if (this.has_unviewed_messages)
            {
                Tracer.out("didScrollEntries: checking for freshly viewed messages...");
                _local2 = this.all_messages.length;
                _local3 = this.unviewed_index;
                while (_local3 < _local2)
                {
                    _local4 = this.all_messages[_local3];
                    _local5 = _local4.view;
                    if ((((this.container.y - this.containerStartY) + _local5.y) + (0.8 * _local5.height)) <= this.container.mask.height)
                    {
                        if (_local4.viewed == 0)
                        {
                            this.message_viewed(_local4);
                            this.unviewed_index++;
                            if (this.unviewed_index == _local2)
                            {
                                this.has_unviewed_messages = false;
                            };
                        } else
                        {
                            this.has_unviewed_messages = false;
                        };
                    };
                    _local3++;
                };
            };
        }
        function select_a_list(_arg1:MouseEvent=null):void{
            this.message_center.addChildAt(this.message_center.messages_tab, (this.message_center.getChildIndex(this.message_center.frame) - 1));
            this.message_center.addChildAt(this.message_center.team_tab, (this.message_center.getChildIndex(this.message_center.frame) - 1));
            this.message_center.addChildAt(this.message_center.a_list_tab, (this.message_center.getChildIndex(this.message_center.frame) + 1));
            this.message_view.visible = false;
            this.team_view.visible = false;
            this.select_team_view.visible = false;
            this.a_list_view.visible = true;
            if (this.a_list == null)
            {
                this.load_a_list();
            } else
            {
                if (this.a_list.length > 0)
                {
                    Tracker.track("open_non_blank", "a_list");
                };
            };
            if (this.a_list_view.add_friends.buttonMode != true)
            {
                this.a_list_view.add_friends.buttonMode = true;
                this.a_list_view.add_friends.addEventListener(MouseEvent.CLICK, this.add_friends, false, 0, true);
            };
        }
        function add_friends(_arg1:MouseEvent):void{
            FacebookConnector.invite_a_list();
        }
        function show_a_list_data(){
            var _local1:Friend;
            var _local2:Class;
            var _local3:MovieClip;
            var _local4:AListFriendView;
            var _local8:int;
            this.a_list_view.points_txt.defaultTextFormat = this.tf;
            this.a_list_view.points_txt.text = UserData.getInstance().vip_points;
            var _local5:MovieClip = this.a_list_view.container;
            this.a_list_start_y = _local5.y;
            _local5.mask = this.a_list_view.mask_mc;
            var _local6:LightScroller = new LightScroller(_local5, this);
            _local6.x = 640;
            _local6.y = _local5.y;
            _local6.visible = false;
            this.a_list_view.addChild(_local6);
            var _local7:int = this.a_list.length;
            this.a_list_view.points_txt.defaultTextFormat = this.tf;
            this.a_list_view.size_txt.text = _local7;
            while (_local8 < _local7)
            {
                _local1 = this.a_list[_local8];
                Tracer.out(("parsing a_list user " + _local8));
                _local2 = this.class_by_name("a_list_box");
                _local3 = new (_local2)();
                _local4 = new AListFriendView(_local3, _local1);
                _local3.x = ((((_local8 % 2))==0) ? 0 : (_local3.width + A_LIST_SPACER));
                _local3.y = ((_local3.height + A_LIST_SPACER) * Math.floor((_local8 / 2)));
                _local3.bg.gotoAndStop(((Math.floor((_local8 / 2)) % 2) + 1));
                _local5.addChild(_local3);
                _local8++;
            };
            dispatchEvent(new Event(LightScroller.TARGET_CHANGED));
            if (_local5.height > _local5.mask.height)
            {
                _local6.visible = true;
            };
        }
        function select_team(_arg1:MouseEvent=null):void{
            this.message_center.addChildAt(this.message_center.a_list_tab, (this.message_center.getChildIndex(this.message_center.frame) - 1));
            this.message_center.addChildAt(this.message_center.messages_tab, (this.message_center.getChildIndex(this.message_center.frame) - 1));
            this.message_center.addChildAt(this.message_center.team_tab, (this.message_center.getChildIndex(this.message_center.frame) + 1));
            this.message_view.visible = false;
            this.a_list_view.visible = false;
            if (UserData.getInstance().team)
            {
                this.setup_team_view();
            } else
            {
                this.setup_select_team_view();
            };
        }
        function setup_team_view(_arg1:Boolean=false){
            this.team_view.visible = true;
            this.select_team_view.visible = false;
            if ((((_arg1 == false)) && (this.team_view.invite_btn.buttonMode)))
            {
                return;
            };
            var _local2:Team = UserData.getInstance().team;
            var _local3:String = ((_arg1) ? "Congratulations!  " : "");
            _local3 = (_local3 + (("You're on " + _local2.name) + " FashionTeam this week!  Each look you create will add to your team's score and you earn FashionCash if your team wins!"));
            this.team_view.header_txt.text = _local3;
            while (this.team_view.pic.numChildren > 0)
            {
                this.team_view.pic.removeChildAt(0);
            };
            var _local4:ImageLoader = new ImageLoader(_local2.large_url, this.team_view.pic);
            if (_arg1)
            {
                this.team_view.change_btn.visible = false;
                this.team_view.share_btn.buttonMode = true;
                this.team_view.share_btn.addEventListener(MouseEvent.CLICK, this.share_team, false, 0, true);
            } else
            {
                this.team_view.share_btn.visible = false;
                if (UserData.getInstance().can_change_team)
                {
                    this.team_view.change_btn.visible = true;
                    this.team_view.change_btn.buttonMode = true;
                    this.team_view.change_btn.addEventListener(MouseEvent.CLICK, this.change_team, false, 0, true);
                } else
                {
                    this.team_view.change_btn.visible = false;
                };
            };
            if (this.team_view.invite_btn.buttonMode)
            {
                return;
            };
            this.team_view.invite_btn.buttonMode = true;
            this.team_view.invite_btn.addEventListener(MouseEvent.CLICK, this.invite_team, false, 0, true);
        }
        function setup_select_team_view(){
            var _local1:MovieClip;
            var _local2:Team;
            var _local3:ImageLoader;
            var _local8:int;
            this.team_view.visible = false;
            this.select_team_view.visible = true;
            if (UserData.getInstance().team)
            {
                this.select_team_view.header_txt.gotoAndStop(2);
                this.select_team_view.cancel_btn.visible = true;
                this.select_team_view.cancel_btn.buttonMode = true;
                this.select_team_view.cancel_btn.addEventListener(MouseEvent.CLICK, this.cancel_select_team, false, 0, true);
            } else
            {
                this.select_team_view.header_txt.gotoAndStop(1);
                this.select_team_view.cancel_btn.visible = false;
            };
            var _local4:Array = DataManager.getInstance().teams;
            var _local5:int = ((UserData.getInstance().team) ? UserData.getInstance().team.id : -1);
            var _local6:int = ((UserData.getInstance().team) ? -1 : UserData.getInstance().prev_team);
            var _local7:int = _local4.length;
            while (_local8 < _local7)
            {
                _local1 = this.select_team_view[("t" + _local8)];
                _local2 = _local4[_local8];
                _local1.team = _local2;
                _local1.name_txt.text = _local2.name;
                _local1.friends_txt.text = (((_local2.members)==1) ? (_local2.members + " Friend") : (_local2.members + " Friends"));
                if (_local2.leader)
                {
                    _local1.leader_txt.text = ("Leader: " + _local2.leader);
                } else
                {
                    _local1.leader_txt.text = "";
                };
                _local3 = new ImageLoader(_local2.icon_url, _local1.pic);
                if ((((_local5 == _local2.id)) || ((_local6 == _local2.id))))
                {
                    _local1.alpha = 0.5;
                    _local1.buttonMode = false;
                    _local1.removeEventListener(MouseEvent.CLICK, this.join_team);
                } else
                {
                    _local1.alpha = 1;
                    if (_local1.buttonMode == false)
                    {
                        _local1.buttonMode = true;
                        _local1.addEventListener(MouseEvent.CLICK, this.join_team, false, 0, true);
                    };
                };
                _local8++;
            };
        }
        function join_team(_arg1:MouseEvent):void{
            var _local2:Team = _arg1.currentTarget.team;
            if (UserData.getInstance().team)
            {
                FacebookConnector.buy_team_change(_local2.id, this.joined_team);
            } else
            {
                DataManager.getInstance().join_team(_local2, this.joined_team);
            };
        }
        function joined_team():void{
            this.setup_team_view(true);
        }
        function invite_team(_arg1:MouseEvent):void{
            var _local2:Team = UserData.getInstance().team;
            FacebookConnector.invite_team(_local2.id, _local2.name);
        }
        function change_team(_arg1:MouseEvent):void{
            this.setup_select_team_view();
        }
        function share_team(_arg1:MouseEvent):void{
            var _local2:Team = UserData.getInstance().team;
            FacebookConnector.share_team(_local2.name, _local2.large_url);
            _arg1.currentTarget.visible = false;
        }
        function cancel_select_team(_arg1:MouseEvent):void{
            this.setup_team_view();
        }
        public function class_by_name(_arg1:String):Class{
            if (this.appDomain)
            {
                return (Class(this.appDomain.getDefinition(_arg1)));
            };
            return (null);
        }

    }
}//package com.viroxoty.fashionista

