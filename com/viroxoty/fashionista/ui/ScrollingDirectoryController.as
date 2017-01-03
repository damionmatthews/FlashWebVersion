// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.ScrollingDirectoryController

package com.viroxoty.fashionista.ui{
    import com.viroxoty.fashionista.boutique.BoutiqueDataObject;
    import com.viroxoty.fashionista.data.UserBoutique;
    import flash.display.MovieClip;
    import flash.text.TextFormat;
    import flash.text.Font;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Friend;
    import com.viroxoty.fashionista.UserData;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import com.viroxoty.fashionista.boutique.*;
    import flash.text.*;
    import flash.display.*;
    import com.viroxoty.fashionista.user_boutique.*;
    import com.viroxoty.fashionista.asset.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class ScrollingDirectoryController {

        public static const MODE_BOUTIQUE:int = 1;
        public static const MODE_A_LIST:int = 2;
        static const BB_HEIGHT:int = 80;
        static const SCROLL_AMT:int = 320;
        static const THUMBS_PER_PAGE:int = 4;
        static const INITIAL_A_LIST_THUMBS:int = 2;

        private static var _instance:ScrollingDirectoryController;
        static var MASK_HEIGHT:int;
        static var VISIBLE_AREA:int;
        static var last_boutique_y:Number = -1;
        static var last_a_list_y:Number = -1;
        static var current_index:int = 0;

        var _current_boutique:BoutiqueDataObject;
        var _current_user_boutique:UserBoutique;
        var view:MovieClip;
        var container:MovieClip;
        var container_start_y:Number;
        var tf:TextFormat;
        public var mode:int;
        var total_thumbs_to_load:int = 0;
        var total_a_list_thumbs:int;
        var container_min_y:Number;
        var initial_scroll_up_from_middle_start:Boolean;

        public function ScrollingDirectoryController(){
            _instance = this;
            this.tf = new TextFormat();
            var _local1:Font = (MainViewController.getInstance().get_game_asset("gill_sans_light") as Font);
            this.tf.font = _local1.fontName;
        }
        public static function getInstance():ScrollingDirectoryController{
            return (_instance);
        }

        public function destroy():void{
            this.view = null;
            this.container = null;
            this._current_boutique = null;
            this._current_user_boutique = null;
        }
        public function set_current_boutique(_arg1:BoutiqueDataObject):void{
            this._current_boutique = _arg1;
        }
        public function set_current_user_boutique(_arg1:UserBoutique):void{
            this._current_user_boutique = _arg1;
        }
        public function hide_directory():void{
            this.view.ui.visible = false;
        }
        public function init_with_view(_arg1:MovieClip):void{
            this.view = _arg1;
            MASK_HEIGHT = this.view.ui.directory_mask.height;
            VISIBLE_AREA = (MASK_HEIGHT - (2 * this.view.ui.up_btn.height));
            this.container = this.view.ui.container;
            this.container_start_y = this.container.y;
            if (last_boutique_y == -1)
            {
                last_boutique_y = this.container.y;
                last_a_list_y = this.container.y;
            };
            this.view.out_tab.visible = true;
            this.view.out_tab.buttonMode = true;
            this.view.out_tab.addEventListener(MouseEvent.CLICK, this.open_directory, false, 0, true);
            Util.create_tooltip("OPEN BOUTIQUE DIRECTORY", this.view.out_tab, "left", "top");
            this.view.ui.in_tab.buttonMode = true;
            this.view.ui.in_tab.addEventListener(MouseEvent.CLICK, this.close_directory, false, 0, true);
            this.view.ui.boutiques_btn.buttonMode = true;
            this.view.ui.boutiques_btn.addEventListener(MouseEvent.CLICK, this.click_boutiques, false, 0, true);
            this.view.ui.a_list_btn.buttonMode = true;
            this.view.ui.a_list_btn.addEventListener(MouseEvent.CLICK, this.click_a_list_boutiques, false, 0, true);
            this.view.ui.up_btn.visible = false;
            this.view.ui.up_btn.buttonMode = true;
            this.view.ui.up_btn.addEventListener(MouseEvent.CLICK, this.scroll_up, false, 0, true);
            this.view.ui.down_btn.visible = (this.container.height > this.view.ui.directory_mask.height);
            this.view.ui.down_btn.buttonMode = true;
            this.view.ui.down_btn.addEventListener(MouseEvent.CLICK, this.scroll_down, false, 0, true);
            if (this.mode == MODE_BOUTIQUE)
            {
                this.show_boutiques();
            } else
            {
                if (this.mode == MODE_A_LIST)
                {
                    this.show_a_list_boutiques();
                };
            };
        }
        public function update_locks():void{
            var bb:MovieClip;
            var i:int;
            if ((((this.view == null)) || ((this.mode == MODE_A_LIST))))
            {
                return;
            };
            var l:int = this.container.numChildren;
            while (i < l)
            {
                bb = (this.container.getChildAt(i) as MovieClip);
                if ((((UserData.getInstance().mini_level < bb.boutique.mini_level)) || ((UserData.getInstance().level < bb.boutique.level))))
                {
                    bb.lock.visible = true;
                    bb.pic.alpha = 0.5;
                } else
                {
                    bb.lock.visible = false;
                    if (bb.pic.alpha < 1)
                    {
                        Tweener.addTween(bb.pic, {
                            "alpha":1,
                            "time":0.4,
                            "transition":"easeInOutSine",
                            "onComplete":function (){
                            }
                        });
                    };
                };
                i = (i + 1);
            };
        }
        public function update_a_list():void{
            if (this.mode == MODE_A_LIST)
            {
                this.show_a_list_boutiques();
            };
        }
        function click_boutiques(_arg1=null){
            this.show_boutiques();
        }
        function click_a_list_boutiques(_arg1=null){
            this.show_a_list_boutiques();
        }
        function show_boutiques(){
            var _local1:BoutiqueDataObject;
            var _local2:MovieClip;
            var _local3:String;
            var _local4:ImageLoader;
            var _local6:int;
            var _local8:int;
            this.mode = MODE_BOUTIQUE;
            this.view.ui.a_list_highlight.visible = false;
            this.view.ui.boutique_highlight.visible = true;
            this.clear_container();
            var _local5:Array = CityManager.getInstance().boutiques;
            var _local7:int = _local5.length;
            while (_local8 < _local7)
            {
                _local1 = _local5[_local8];
                if (!(((_local1.isOpen == false)) || ((_local1.order == -1))))
                {
                    Tracer.out(("processing " + _local1.short_name));
                    _local2 = (MainViewController.getInstance().get_game_asset("boutique_box") as MovieClip);
                    _local2.boutique_name_tip.name_txt.defaultTextFormat = this.tf;
                    _local2.boutique_name_tip.name_txt.text = _local1.name;
                    _local2.boutique_name_tip.visible = false;
                    _local2.highlight.visible = ((this._current_boutique) && ((this._current_boutique.id == _local1.id)));
                    if ((((UserData.getInstance().mini_level < _local1.mini_level)) || ((UserData.getInstance().level < _local1.level))))
                    {
                        _local2.lock.visible = true;
                        _local2.pic.alpha = 0.5;
                    } else
                    {
                        _local2.lock.visible = false;
                    };
                    _local2.boutique = _local1;
                    _local3 = (((Constants.SERVER_IMAGES + "boutiques/thumbs/") + _local1.short_name) + "_sm.png");
                    if (_local1.name == "Dresses Dresses Dresses")
                    {
                        _local3 = Util.fresh_url(_local3);
                    };
                    _local4 = new ImageLoader(_local3, _local2.pic);
                    _local2.buttonMode = true;
                    _local2.addEventListener(MouseEvent.ROLL_OVER, this.show_boutique_name, false, 0, true);
                    _local2.addEventListener(MouseEvent.ROLL_OUT, this.hide_boutique_name, false, 0, true);
                    _local2.addEventListener(MouseEvent.CLICK, this.open_boutique, false, 0, true);
                    _local2.x = 0;
                    _local2.y = (BB_HEIGHT * _local6);
                    this.container.addChild(_local2);
                    _local6++;
                };
                _local8++;
            };
            this.container.y = last_boutique_y;
            this.view.ui.up_btn.visible = !((this.container.y == this.container_start_y));
            this.container_min_y = ((this.container_start_y + VISIBLE_AREA) - this.container.height);
            this.view.ui.down_btn.visible = (this.container.y > this.container_min_y);
        }
        function show_a_list_boutiques():void{
            var _local1:MovieClip;
            var _local2:String;
            var _local3:ImageLoader;
            Tracer.out("show_a_list_boutiques");
            this.mode = MODE_A_LIST;
            this.view.ui.a_list_highlight.visible = true;
            this.view.ui.boutique_highlight.visible = false;
            var _local4:Vector.<Friend> = UserData.getInstance().a_list;
            if ((((_local4 == null)) || ((((_local4.length > 0)) && ((_local4[0].profile_url == null))))))
            {
                MainViewController.getInstance().show_preloader();
                DataManager.getInstance().get_a_list(this.a_list_loaded, this.a_list_load_failed);
                return;
            };
            this.clear_container();
            var _local5:UserData = UserData.getInstance();
            if (((_local5.has_boutique) && (_local5.has_active_boutique)))
            {
                _local1 = (MainViewController.getInstance().get_game_asset("boutique_box") as MovieClip);
                _local1.boutique_name_tip.name_txt.defaultTextFormat = this.tf;
                _local1.boutique_name_tip.name_txt.text = "My Boutique";
                _local1.boutique_name_tip.visible = false;
                _local1.addEventListener(MouseEvent.ROLL_OVER, this.show_boutique_name, false, 0, true);
                _local1.addEventListener(MouseEvent.ROLL_OUT, this.hide_boutique_name, false, 0, true);
                _local2 = UserData.getInstance().my_boutique_url;
                _local3 = new ImageLoader(Util.fresh_url(_local2), _local1.pic);
                _local1.highlight.visible = false;
                _local1.lock.visible = false;
                _local1.addEventListener(MouseEvent.CLICK, this.open_my_boutique, false, 0, true);
            } else
            {
                if ((((((Main.getInstance().current_section == Constants.SECTION_MY_BOUTIQUE)) && (_local5.has_boutique))) && ((_local5.has_active_boutique == false))))
                {
                    _local1 = (MainViewController.getInstance().get_game_asset("launch_boutique_thumb") as MovieClip);
                    _local1.x = 5;
                    _local1.addEventListener(MouseEvent.CLICK, this.launch_my_boutique, false, 0, true);
                } else
                {
                    _local1 = (MainViewController.getInstance().get_game_asset("design_boutique_thumb") as MovieClip);
                    _local1.x = 5;
                    _local1.addEventListener(MouseEvent.CLICK, this.open_my_boutique, false, 0, true);
                };
            };
            _local1.buttonMode = true;
            this.container.addChild(_local1);
            this.total_thumbs_to_load++;
            var _local6:Friend = Friend.getJoel();
            _local1 = (MainViewController.getInstance().get_game_asset("boutique_box") as MovieClip);
            _local1.boutique_name_tip.name_txt.defaultTextFormat = this.tf;
            _local1.boutique_name_tip.name_txt.text = "Joel Goodrich";
            _local1.boutique_name_tip.visible = false;
            _local1.highlight.visible = ((this._current_user_boutique) && ((this._current_user_boutique.user_id == _local6.user_id)));
            _local1.addEventListener(MouseEvent.ROLL_OVER, this.show_boutique_name, false, 0, true);
            _local1.addEventListener(MouseEvent.ROLL_OUT, this.hide_boutique_name, false, 0, true);
            _local1.addEventListener(MouseEvent.CLICK, this.open_a_list_boutique, false, 0, true);
            _local1.lock.visible = false;
            _local2 = Util.fresh_url((((Constants.UGC_SERVER_IMAGES + "my_boutique_thumbs/") + _local6.user_id) + ".png"));
            _local3 = new ImageLoader(_local2, _local1.pic);
            _local1.user = _local6;
            _local1.y = BB_HEIGHT;
            this.container.addChild(_local1);
            this.total_thumbs_to_load++;
            this.container.y = last_a_list_y;
            current_index = Math.max((-(INITIAL_A_LIST_THUMBS) + Math.floor(((this.container_start_y - this.container.y) / BB_HEIGHT))), 0);
            Tracer.out(((("container.y is " + this.container.y) + ", current_index is ") + current_index));
            this.load_a_list_thumbs(current_index);
            if ((((current_index > 0)) && (((current_index + THUMBS_PER_PAGE) < this.total_a_list_thumbs))))
            {
                this.load_a_list_thumbs((current_index + THUMBS_PER_PAGE), 1);
                current_index++;
                this.initial_scroll_up_from_middle_start = true;
            };
            this.view.ui.up_btn.visible = !((this.container.y == this.container_start_y));
            this.view.ui.down_btn.visible = (this.container.y > this.container_min_y);
        }
        function load_a_list_thumbs(_arg1:int, _arg2:int=4):void{
            var _local3:Friend;
            var _local4:MovieClip;
            var _local5:String;
            var _local6:ImageLoader;
            var _local7:Vector.<Friend> = UserData.getInstance().get_a_list_active_boutique();
            if (this.total_thumbs_to_load == INITIAL_A_LIST_THUMBS)
            {
                this.total_a_list_thumbs = _local7.length;
                this.total_thumbs_to_load = (this.total_thumbs_to_load + this.total_a_list_thumbs);
                this.container_min_y = (this.container_start_y - ((Math.ceil(((this.total_thumbs_to_load + 1) / 4)) - 1) * SCROLL_AMT));
            };
            var _local8:int = Math.min(this.total_a_list_thumbs, (_arg1 + _arg2));
            Tracer.out(((("load_a_list_thumbs > from " + _arg1) + " to ") + (_local8 - 1)));
            var _local9:int = _arg1;
            while (_local9 < _local8)
            {
                _local3 = _local7[_local9];
                Tracer.out(("processing " + _local3.name));
                _local4 = (MainViewController.getInstance().get_game_asset("boutique_box") as MovieClip);
                _local4.boutique_name_tip.name_txt.defaultTextFormat = this.tf;
                _local4.boutique_name_tip.name_txt.text = _local3.name;
                _local4.boutique_name_tip.visible = false;
                _local4.highlight.visible = ((this._current_user_boutique) && ((this._current_user_boutique.user_id == _local3.user_id)));
                _local4.lock.visible = false;
                _local4.user = _local3;
                _local5 = Util.fresh_url((((Constants.UGC_SERVER_IMAGES + "my_boutique_thumbs/") + _local3.user_id) + ".png"));
                _local6 = new ImageLoader(_local5, _local4.pic);
                _local4.buttonMode = true;
                _local4.addEventListener(MouseEvent.ROLL_OVER, this.show_boutique_name, false, 0, true);
                _local4.addEventListener(MouseEvent.ROLL_OUT, this.hide_boutique_name, false, 0, true);
                _local4.addEventListener(MouseEvent.CLICK, this.open_a_list_boutique, false, 0, true);
                _local4.x = 0;
                _local4.y = (BB_HEIGHT * (_local9 + INITIAL_A_LIST_THUMBS));
                this.container.addChild(_local4);
                _local9++;
            };
            if (_local8 == this.total_a_list_thumbs)
            {
                _local4 = (MainViewController.getInstance().get_game_asset("see_more_boutiques_thumb") as MovieClip);
                _local4.buttonMode = true;
                _local4.addEventListener(MouseEvent.CLICK, this.see_more_boutiques, false, 0, true);
                _local4.x = 5;
                _local4.y = ((BB_HEIGHT * (_local9 + INITIAL_A_LIST_THUMBS)) + 5);
                this.container.addChild(_local4);
                this.total_thumbs_to_load++;
            };
        }
        function clear_container():void{
            while (this.container.numChildren > 0)
            {
                this.container.removeChildAt(0);
            };
            this.container.y = this.container_start_y;
            this.total_thumbs_to_load = 0;
        }
        function a_list_loaded(_arg1:Object):void{
            MainViewController.getInstance().hide_preloader();
            UserData.getInstance().process_a_list_json(_arg1);
            if (this.mode == MODE_A_LIST)
            {
                this.show_a_list_boutiques();
            };
        }
        function a_list_load_failed():void{
            MainViewController.getInstance().hide_preloader();
        }
        function show_boutique_name(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            _local2.boutique_name_tip.visible = true;
        }
        function hide_boutique_name(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            _local2.boutique_name_tip.visible = false;
        }
        function open_boutique(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            BoutiqueManager.getInstance().setup_boutique_by_name(_local2.boutique.short_name);
        }
        function open_my_boutique(_arg1:MouseEvent):void{
            MyBoutique.getInstance().load();
        }
        function launch_my_boutique(_arg1:MouseEvent):void{
            MyBoutique.getInstance().launch_boutique();
        }
        function open_a_list_boutique(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            var _local3:Friend = _local2.user;
            BoutiqueVisit.createVisit(_local3.user_id, _local3.name);
        }
        function see_more_boutiques(_arg1:MouseEvent):void{
            FacebookConnector.invite_boutique_friends();
        }
        function scroll_up(e:MouseEvent):void{
            this.view.ui.down_btn.visible = true;
            Tweener.removeTweens(this.container);
            var newY:Number = Math.min((this.container.y + SCROLL_AMT), this.container_start_y);
            Tracer.out(((("scroll_up: current y = " + this.container.y) + ", newY is ") + newY));
            Tweener.addTween(this.container, {
                "y":newY,
                "time":0.4,
                "transition":"easeInOutSine",
                "onComplete":function (){
                }
            });
            this.view.ui.up_btn.visible = !((newY == this.container_start_y));
            if (this.mode == MODE_BOUTIQUE)
            {
                last_boutique_y = newY;
            } else
            {
                if (this.mode == MODE_A_LIST)
                {
                    last_a_list_y = newY;
                };
            };
            current_index = Math.max(0, (current_index - THUMBS_PER_PAGE));
            if (this.initial_scroll_up_from_middle_start)
            {
                this.initial_scroll_up_from_middle_start = false;
                current_index--;
            };
            Tracer.out(((("scroll_up: numChildren is " + this.container.numChildren) + ", thumbs to load is ") + this.total_thumbs_to_load));
            if (this.container.numChildren < this.total_thumbs_to_load)
            {
                this.load_a_list_thumbs(current_index);
            };
        }
        function scroll_down(e:MouseEvent):void{
            this.view.ui.up_btn.visible = true;
            Tweener.removeTweens(this.container);
            var newY:Number = (this.container.y - SCROLL_AMT);
            Tweener.addTween(this.container, {
                "y":newY,
                "time":0.4,
                "transition":"easeInOutSine",
                "onComplete":function (){
                }
            });
            if (this.mode == MODE_BOUTIQUE)
            {
                last_boutique_y = newY;
            } else
            {
                if (this.mode == MODE_A_LIST)
                {
                    last_a_list_y = newY;
                };
            };
            current_index = (current_index + THUMBS_PER_PAGE);
            if (this.container.numChildren < this.total_thumbs_to_load)
            {
                this.load_a_list_thumbs(current_index);
            };
            Tracer.out(((((("scroll_down: current y = " + this.container.y) + ", newY is ") + newY) + ", container_min_y is ") + this.container_min_y));
            this.view.ui.down_btn.visible = (newY > this.container_min_y);
        }
        function open_directory(_arg1:MouseEvent):void{
            this.view.ui.visible = true;
        }
        function close_directory(_arg1:MouseEvent):void{
            this.view.ui.visible = false;
        }

    }
}//package com.viroxoty.fashionista.ui

