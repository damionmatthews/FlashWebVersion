// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ContestantBar

package com.viroxoty.fashionista{
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Friend;
    import flash.system.ApplicationDomain;
    import flash.display.MovieClip;
    import flash.text.TextFormat;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import com.viroxoty.fashionista.ui.ImageLoader;
    import com.viroxoty.fashionista.data.Team;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.net.*;
    import __AS3__.vec.*;
    import flash.text.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.user_boutique.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class ContestantBar {

        static const DEFAULT:String = "default";
        static const RUNWAY:String = "runway";
        static const DYNAMIC_BOXES:int = 6;
        static const BOX_WIDTH:Number = 72.75;
        static const SPACER:int = 3;

        private static var _instance:ContestantBar;
        static var SCROLL_AMOUNT:int;

        private var invite_pool:Vector.<Friend>;
        private var invite_pool_length:int;
        private var daily_leader:Friend;
        private var team_leader:Friend;
        private var filtered_a_list:Vector.<Friend>;
        private var appDomain:ApplicationDomain;
        private var did_init:Boolean;
        private var mode:String;
        private var view:MovieClip;
        private var text_format:TextFormat;
        var container:MovieClip;
        var visible_a_list:int;
        var total_boxes:int;
        var container_start_x:Number;
        var container_min_x:Number;
        var current_index:int;
        var offset:int;

        public function ContestantBar(){
            _instance = this;
            Tracer.out("New ContestantBar");
        }
        public static function getInstance():ContestantBar{
            if (_instance == null)
            {
                _instance = new (ContestantBar)();
            };
            return (_instance);
        }

        public function load_swf():void{
            var swf_loaded:Function;
            var ioErrorHandler:Function;
            swf_loaded = function (_arg1:Event):void{
                Tracer.out("ContestantBar > swf_loaded ");
                appDomain = (_arg1.target as LoaderInfo).applicationDomain;
                view = (get_asset("asset") as MovieClip);
                MainViewController.getInstance().check_first_screen_swfs();
            };
            ioErrorHandler = function (_arg1:IOErrorEvent):void{
                Tracer.out(("ioErrorHandler: " + _arg1));
            };
            var swf_filename:String = (Constants.SERVER_SWF + Constants.CONTESTANT_BAR_SWF);
            var request:URLRequest = new URLRequest(swf_filename);
            Tracer.out(("ContestantBar > loading " + swf_filename));
            var l:Loader = new Loader();
            l.contentLoaderInfo.addEventListener(Event.COMPLETE, swf_loaded);
            l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            l.load(request);
        }
        public function isReady():Boolean{
            return (!((this.view == null)));
        }
        function get_asset(_arg1:String):Object{
            if (this.appDomain == null)
            {
                throw (new Error("appDomain is null"));
            };
            var _local2:Class = Class(this.appDomain.getDefinition(_arg1));
            return (new (_local2)());
        }
        public function init():void{
            Tracer.out("ContestantBar > init");
            this.did_init = true;
            this.init_invite_pool();
            this.text_format = new TextFormat();
            this.text_format.font = "Arial";
            this.text_format.bold = true;
            MainViewController.getInstance().footer_container.addChild(this.view);
            Util.simpleButton(this.view.top_btn, this.open_my_team);
            Util.simpleButton(this.view.a_list_btn, this.open_a_list);
            Util.forTypeIn(this.view.user_box, "TextField", Util.partial(Util.setDefaultTextFormat, this.text_format));
            this.view.user_box.first_name.text = UserData.getInstance().first_name;
            var _local1:ImageLoader = new ImageLoader(Constants.fb_pic_for_id(DataManager.user_id), this.view.user_box.pic);
            this.view.user_box.votes.text = (UserData.getInstance().week_votes + " votes");
            Util.simpleButton(this.view.user_box, this.show_user);
            Util.simpleButton(this.view.team_container, this.show_team);
            Util.simpleButton(this.view.star_btn, this.make_star);
            Util.hideTips(this.view);
            Util.simpleRolloverTip(this.view.star_btn, this.view.earn_tip);
            this.update_team_icon();
            this.view.containerMask.startWidth = this.view.containerMask.width;
            this.view.scrollContainer.startX = this.view.scrollContainer.x;
            this.container = this.view.scrollContainer;
            this.view.prev_btn.visible = false;
            Util.simpleButton(this.view.prev_btn, this.scroll_left);
            Util.simpleButton(this.view.next_btn, this.scroll_right);
            this.update_section();
        }
        public function update_section():void{
            var _local2:*;
            if (this.did_init != true)
            {
                return;
            };
            var _local1:* = (((Main.getInstance().current_section)==Constants.SECTION_RUNWAY) ? RUNWAY : DEFAULT);
            if (_local1 != this.mode)
            {
                this.mode = _local1;
                this.clear_data();
                if (this.mode == RUNWAY)
                {
                    DataManager.getInstance().get_runway_contestant_bar_data(this.got_runway_data, this.runway_data_fail);
                } else
                {
                    UserData.getInstance().sort_a_list("points");
                    _local2 = this;
                    var _local3 = _local2;
                    (_local3[("render_" + this.mode)]());
                };
            };
            this.view.runway_overlay.visible = (this.mode == RUNWAY);
        }
        public function update_team_icon(){
            var _local1:ImageLoader;
            Tracer.out("update_team_icon");
            var _local2:Team = UserData.getInstance().team;
            Util.hideTips(this.view);
            Util.clearSimpleRolloverTip(this.view.team_container);
            if (_local2)
            {
                while (this.view.team_container.numChildren > 0)
                {
                    this.view.team_container.removeChildAt(0);
                };
                _local1 = new ImageLoader(_local2.icon_url, this.view.team_container, 45, 45);
                Util.simpleRolloverTip(this.view.team_container, this.view.invite_tip);
            } else
            {
                Util.simpleRolloverTip(this.view.team_container, this.view.join_tip);
            };
            if (this.mode == RUNWAY)
            {
                this.update_section();
            };
        }
        function open_my_team(_arg1:MouseEvent):void{
            External.open_top_page();
        }
        function open_a_list(_arg1:MouseEvent):void{
            MessageCenter.getInstance().show_a_list();
        }
        function show_user(_arg1:MouseEvent):void{
            if (this.mode == DEFAULT)
            {
                External.open_user_looks();
            } else
            {
                if (this.mode == RUNWAY)
                {
                    Runway.getInstance().show_my_looks();
                };
            };
        }
        function invite_friend(_arg1:Event):void{
            var _local2:Friend = _arg1.currentTarget.friend;
            FacebookConnector.invite_friend(_local2);
        }
        function visit_friend(_arg1:Event):void{
            var _local2:Friend = _arg1.currentTarget.friend;
            BoutiqueVisit.createVisit(_local2.user_id, _local2.name);
        }
        function invite_launch(_arg1:Event):void{
            var _local2:Friend = _arg1.currentTarget.friend;
            FacebookConnector.invite_friend(_local2, (UserData.getInstance().first_name + " invites you to create and launch your boutique in Fashionista FaceOff!"), (("Invite " + _local2.first_name) + " to launch their boutique!"));
        }
        function show_team_looks(_arg1:Event):void{
            Runway.getInstance().show_team_looks();
        }
        function show_top_looks(_arg1:Event):void{
            Runway.getInstance().show_top_looks();
        }
        function show_looks(_arg1:Event):void{
            var _local2:Friend = _arg1.currentTarget.friend;
            DataManager.getInstance().get_a_lister_looks_xml(_local2.user_id, this.got_friend_looks);
        }
        function invite_look(_arg1:Event):void{
            var _local2:Friend = _arg1.currentTarget.friend;
            FacebookConnector.invite_friend(_local2, (UserData.getInstance().first_name + " invites you to create some winning looks in Fashionista FaceOff!"), (("Invite " + _local2.first_name) + " to create some looks!"));
        }
        function add_friend(_arg1:Event):void{
            FacebookConnector.invite_friends();
        }
        function show_team(_arg1=null){
            MessageCenter.getInstance().show_team();
        }
        function make_star(_arg1:Event):void{
            Pop_Up.getInstance().display_popup(Pop_Up.MAKE_ME_A_STAR);
        }
        function got_runway_data(_arg1:Object):void{
            this.daily_leader = (((_arg1.daily_leader)==null) ? null : Friend.parseObj(_arg1.daily_leader));
            this.team_leader = (((_arg1.team_leader)==null) ? null : Friend.parseObj(_arg1.team_leader));
            UserData.getInstance().update_a_list(_arg1.a_list);
            UserData.getInstance().sort_a_list("votes");
            this.filtered_a_list = this.filter_a_list(UserData.getInstance().a_list);
            Tracer.out(("got_runway_data > new filtered_a_list is " + this.filtered_a_list));
            this.render_runway();
        }
        function runway_data_fail():void{
        }
        function got_friend_looks(_arg1:XML):void{
            Runway.getInstance().a_lister_xml = _arg1;
            Runway.getInstance().show_a_lister_looks();
        }
        function clear_data(){
            while (this.view.fixedContainer.numChildren > 0)
            {
                this.view.fixedContainer.removeChildAt(0);
            };
            while (this.container.numChildren > 0)
            {
                this.container.removeChildAt(0);
            };
            this.view.prev_btn.visible = false;
        }
        function render_default():void{
            var _local1:Friend;
            var _local4:int;
            var _local2:int = Math.min(2, this.invite_pool.length);
            this.visible_a_list = (DYNAMIC_BOXES - _local2);
            var _local3:int = (_local2 * (BOX_WIDTH + SPACER));
            this.view.scrollContainer.x = (this.view.scrollContainer.startX + _local3);
            this.container_start_x = this.view.scrollContainer.x;
            this.view.containerMask.x = this.view.scrollContainer.x;
            this.view.containerMask.width = (this.view.containerMask.startWidth - _local3);
            SCROLL_AMOUNT = ((BOX_WIDTH + SPACER) * this.visible_a_list);
            Tracer.out("ContestantBar > render_default: adding friend boxes");
            while (_local4 < _local2)
            {
                _local1 = this.get_random_invite();
                _local1.addEventListener(Friend.FIRST_NAME_READY, this.update_box, false, 0, true);
                this.view.fixedContainer.addChild(this.make_box(_local1, "friend", this.invite_friend, _local4));
                FacebookConnector.get_friend_data(_local1);
                _local4++;
            };
            var _local5:Vector.<Friend> = UserData.getInstance().a_list;
            this.total_boxes = Math.max((_local5.length + 1), this.visible_a_list);
            Tracer.out(("ContestantBar > render_default: total a_list boxes = " + this.total_boxes));
            this.container_min_x = (this.container_start_x - ((BOX_WIDTH + SPACER) * (this.total_boxes - this.visible_a_list)));
            this.current_index = 0;
            this.offset = 0;
            Tracer.out("ContestantBar > render_default: adding a_list boxes");
            this.add_a_list_boxes();
            this.view.next_btn.visible = (this.total_boxes > this.visible_a_list);
        }
        function render_runway():void{
            var _local1:Friend;
            var _local4:int;
            if (UserData.getInstance().team)
            {
                if (this.team_leader)
                {
                    this.view.fixedContainer.addChild(this.make_box(this.team_leader, "top", this.show_team_looks, 0));
                };
            } else
            {
                this.view.fixedContainer.addChild(this.make_join_team_box(0));
            };
            if (this.daily_leader)
            {
                this.view.fixedContainer.addChild(this.make_box(this.daily_leader, "top", this.show_top_looks, 1));
            };
            var _local2:int = (2 * (BOX_WIDTH + SPACER));
            this.view.scrollContainer.x = (this.view.scrollContainer.startX + _local2);
            this.container_start_x = this.view.scrollContainer.x;
            this.view.containerMask.x = this.view.scrollContainer.x;
            this.view.containerMask.width = (this.view.containerMask.startWidth - _local2);
            this.visible_a_list = (DYNAMIC_BOXES - 2);
            SCROLL_AMOUNT = ((BOX_WIDTH + SPACER) * this.visible_a_list);
            var _local3:int = Math.min(2, this.invite_pool.length);
            Tracer.out((("ContestantBar > render_runway: adding " + _local3) + " friend boxes"));
            while (_local4 < _local3)
            {
                _local1 = this.get_random_invite();
                _local1.addEventListener(Friend.FIRST_NAME_READY, this.update_box, false, 0, true);
                this.container.addChild(this.make_box(_local1, "friend", this.invite_friend, _local4));
                FacebookConnector.get_friend_data(_local1);
                _local4++;
            };
            this.offset = _local3;
            this.total_boxes = (this.offset + Math.max((this.filtered_a_list.length + 1), this.visible_a_list));
            Tracer.out(("ContestantBar > render_runway: total a_list boxes = " + this.total_boxes));
            this.container_min_x = (this.container_start_x - ((BOX_WIDTH + SPACER) * (this.total_boxes - this.visible_a_list)));
            this.current_index = 0;
            Tracer.out("ContestantBar > render_runway: adding a_list boxes");
            this.add_a_list_boxes();
            this.view.next_btn.visible = (this.total_boxes > this.visible_a_list);
        }
        function filter_a_list(a_list:Vector.<Friend>):Vector.<Friend>{
            var friend_or_look:Function;
            friend_or_look = function (_arg1:Friend, _arg2:int, _arg3:Vector.<Friend>):Boolean{
                return (((_arg1.fb_friend) || ((_arg1.looks > 0))));
            };
            return (a_list.filter(friend_or_look));
        }
        function add_a_list_boxes():void{
            var _local1:int;
            var _local2:Friend;
            var _local3:Function;
            var _local4:Number;
            var _local5:MovieClip;
            Tracer.out("add_a_list_boxes");
            var _local6:Vector.<Friend> = (((this.mode)==RUNWAY) ? this.filtered_a_list : UserData.getInstance().a_list);
            var _local7:int = Math.min(this.total_boxes, (this.current_index + this.visible_a_list));
            var _local8:int = this.current_index;
            while (_local8 < _local7)
            {
                _local1 = (_local8 + this.offset);
                if (_local8 >= _local6.length)
                {
                    this.container.addChild(this.make_add_friend_box(_local1));
                } else
                {
                    _local2 = _local6[_local8];
                    _local4 = 1;
                    if (this.mode == DEFAULT)
                    {
                        if (_local2.activeBoutique)
                        {
                            _local3 = this.visit_friend;
                        } else
                        {
                            _local3 = this.invite_launch;
                            _local4 = 0.5;
                        };
                    } else
                    {
                        if (this.mode == RUNWAY)
                        {
                            if (_local2.looks > 0)
                            {
                                _local3 = this.show_looks;
                            } else
                            {
                                _local3 = this.invite_look;
                                _local4 = 0.5;
                            };
                        };
                    };
                    _local5 = this.make_box(_local2, (((this.mode)==RUNWAY) ? "vote" : "a_list"), _local3, _local1);
                    _local5.btn.alpha = _local4;
                    this.container.addChild(_local5);
                };
                _local8++;
            };
            this.current_index = _local7;
        }
        function make_box(_arg1:Friend, _arg2:String, _arg3:Function, _arg4:int):MovieClip{
            Tracer.out(((((("make_box: " + _arg1) + ", ") + _arg2) + ", slot: ") + _arg4));
            var _local5:MovieClip = (this.get_asset((_arg2 + "_box")) as MovieClip);
            _local5.friend = _arg1;
            Util.forTypeIn(_local5, "TextField", Util.partial(Util.setDefaultTextFormat, this.text_format));
            Util.setTextFromData(_local5, _arg1);
            if (_local5.points_text)
            {
                _local5.points_text.visible = false;
            };
            if (_local5.votes_text)
            {
                _local5.votes_text.visible = false;
            };
            var _local6:ImageLoader = new ImageLoader(_arg1.pic, _local5.pic);
            if (_arg3 != null)
            {
                Util.simpleButton(_local5, _arg3);
            };
            _local5.x = ((BOX_WIDTH + SPACER) * _arg4);
            return (_local5);
        }
        function make_add_friend_box(_arg1:int):MovieClip{
            Tracer.out(("make_add_friend_box - slot: " + _arg1));
            var _local2:MovieClip = (this.get_asset("add_friend_box") as MovieClip);
            Util.simpleButton(_local2, this.add_friend);
            _local2.x = ((BOX_WIDTH + SPACER) * _arg1);
            return (_local2);
        }
        function make_join_team_box(_arg1:int):MovieClip{
            var _local2:MovieClip = (this.get_asset("join_team_box") as MovieClip);
            var _local3:ImageLoader = new ImageLoader((Constants.SERVER_IMAGES + "join_team.png"), _local2.pic, 50, 50);
            Util.simpleButton(_local2, this.show_team);
            _local2.x = ((BOX_WIDTH + SPACER) * _arg1);
            return (_local2);
        }
        function update_box(e:Event):void{
            var f:Friend;
            var find_container:Function = function (_arg1){
                var _local2:MovieClip;
                var _local3:int;
                while (_local3 < _arg1.numChildren)
                {
                    _local2 = (_arg1.getChildAt(_local3) as MovieClip);
                    if (_local2.friend == f)
                    {
                        Util.setTextFromData(_local2, f);
                        return;
                    };
                    _local3++;
                };
            };
            f = (e.currentTarget as Friend);
            Tracer.out(("update_box for " + f.first_name));
            f.removeEventListener(Friend.FIRST_NAME_READY, this.update_box);
            (find_container(this.view.fixedContainer));
            (find_container(this.view.scrollContainer));
        }
        function scroll_right(e:MouseEvent):void{
            this.view.prev_btn.visible = true;
            Tweener.removeTweens(this.container);
            var newX:Number = Math.max((this.container.x - SCROLL_AMOUNT), this.container_min_x);
            Tweener.addTween(this.container, {
                "x":newX,
                "time":0.4,
                "transition":"easeInOutSine",
                "onComplete":function (){
                }
            });
            Tracer.out(((((("scroll_right: current x = " + this.container.x) + ", newX is ") + newX) + ", container_min_x is ") + this.container_min_x));
            this.view.next_btn.visible = (newX > this.container_min_x);
            var page:int = (Math.round(((this.container_start_x - newX) / SCROLL_AMOUNT)) + 1);
            var added_boxes:* = (page * this.visible_a_list);
            Tracer.out(((("scroll_left: numChildren is " + this.container.numChildren) + ", added_boxes should be ") + added_boxes));
            if (this.container.numChildren < added_boxes)
            {
                this.add_a_list_boxes();
            };
        }
        function scroll_left(e:MouseEvent):void{
            this.view.next_btn.visible = true;
            Tweener.removeTweens(this.container);
            var newX:Number = Math.min((this.container.x + SCROLL_AMOUNT), this.container_start_x);
            Tracer.out(((("scroll_left: current x = " + this.container.x) + ", newX is ") + newX));
            Tweener.addTween(this.container, {
                "x":newX,
                "time":0.4,
                "transition":"easeInOutSine",
                "onComplete":function (){
                }
            });
            this.view.prev_btn.visible = !((newX == this.container_start_x));
        }
        function init_invite_pool():void{
            if (UserData.getInstance().non_app_friends)
            {
                this.invite_pool = UserData.getInstance().non_app_friends.concat();
                this.invite_pool_length = this.invite_pool.length;
            } else
            {
                this.invite_pool = new Vector.<Friend>();
            };
        }
        function get_random_invite():Friend{
            var _local1:Friend = Friend(Util.random_item(this.invite_pool));
            Util.remove(this.invite_pool, _local1);
            if ((((this.invite_pool.length == 0)) && ((this.invite_pool_length > 0))))
            {
                this.init_invite_pool();
            };
            return (_local1);
        }

    }
}//package com.viroxoty.fashionista

