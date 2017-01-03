// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.user_boutique.DecorBrowserController

package com.viroxoty.fashionista.user_boutique{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Decor;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import com.viroxoty.fashionista.data.UserDecor;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.events.Event;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.net.*;
    import __AS3__.vec.*;
    import com.viroxoty.fashionista.events.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.adobe.serialization.json.*;
    import com.viroxoty.fashionista.util.*;

    public class DecorBrowserController extends EventDispatcher {

        public static const SWF_CONTAINER_SIZE:int = 100;
        static const SWF_CONTAINER_SPACER:int = 6;
        static const ITEMS_PER_PAGE:int = 5;
        public static const EVENT_BROWSER_INTERACTION:String = "EVENT_BROWSER_INTERACTION";

        private static var _instance:DecorBrowserController;

        var categories:Array;
        var category_data:Vector.<Decor>;
        var subcategory_filter:String;
        var view:MovieClip;
        var dragLayer:Sprite;
        var transforming_decor:DecorViewController;
        var current_btn:MovieClip;
        var current_category:int;
        var current_count:int;
        var total_data:int;
        var start_click_x:Number;
        var start_click_y:Number;
        var ignore_hide_decor_place_tip:Boolean;

        public function DecorBrowserController(){
            this.categories = [];
            super();
            _instance = this;
            Tracer.out("new DecorBrowserController");
        }
        public static function getInstance():DecorBrowserController{
            if (_instance == null)
            {
                _instance = new (DecorBrowserController)();
            };
            return (_instance);
        }

        public function init(aView:MovieClip){
            var catName:String;
            var btn:MovieClip;
            var j:String;
            var setup_subcat_btn:Function = function (_arg1:MovieClip, _arg2:String){
                _arg1.categoryName = _arg2;
                _arg1.buttonMode = true;
                _arg1.addEventListener(MouseEvent.CLICK, click_subcategory, false, 0, true);
            };
            this.view = aView;
            this.view.tip_closet.visible = false;
            this.view.tip_browser.visible = false;
            this.view.tip_drag.visible = false;
            this.view.launch_btn.tip_exclamation.visible = false;
            this.view.launch_tip.visible = false;
            if (UserData.getInstance().visits == 1)
            {
                if (Tracker.first_time_my_boutique_decor_browser_interaction)
                {
                    this.check_show_browser_tip();
                } else
                {
                    if (Tracker.first_time_my_boutique_launch)
                    {
                        this.view.launch_btn.tip_exclamation.visible = true;
                    };
                };
            } else
            {
                if ((((UserData.getInstance().visits == 2)) || (Tracker.first_time_my_boutique_session)))
                {
                    if (Tracker.first_time_my_boutique_closet)
                    {
                        this.view.tip_closet.visible = true;
                    } else
                    {
                        if (Tracker.first_time_my_boutique_decor_browser_interaction)
                        {
                            this.check_show_browser_tip();
                        } else
                        {
                            if (Tracker.first_time_my_boutique_launch)
                            {
                                this.view.launch_btn.tip_exclamation.visible = true;
                            };
                        };
                    };
                };
            };
            this.dragLayer = new Sprite();
            this.view.addChild(this.dragLayer);
            this.view.model_btn.buttonMode = true;
            this.view.model_btn.addEventListener(MouseEvent.CLICK, this.click_model, false, 0, true);
            Tracer.out("setting up category buttons");
            var i:int = 1;
            while (i <= 9)
            {
                catName = DecorCategories.category_name_for_id(i);
                btn = this.view[(catName + "_btn")];
                btn.categoryId = i;
                btn.categoryName = catName;
                btn.buttonMode = true;
                btn.icon.gotoAndStop(1);
                btn.tip.visible = false;
                btn.hit.addEventListener(MouseEvent.CLICK, this.click_category, false, 0, true);
                btn.hit.addEventListener(MouseEvent.ROLL_OVER, this.category_roll_over, false, 0, true);
                btn.hit.addEventListener(MouseEvent.ROLL_OUT, this.category_roll_out, false, 0, true);
                if (btn.subcat)
                {
                    Tracer.out(("setting up subcat for " + btn.categoryName));
                    btn.subcat.visible = false;
                    btn.addEventListener(MouseEvent.ROLL_OVER, this.rollover_category, false, 0, true);
                    btn.addEventListener(MouseEvent.ROLL_OUT, this.rollout_category, false, 0, true);
                    for (j in btn.subcat)
                    {
                        if ((btn.subcat[j] is MovieClip))
                        {
                            (setup_subcat_btn(btn.subcat[j], btn.categoryName));
                            Tracer.out(("setting up subcat button " + btn.subcat[j].name));
                        };
                    };
                };
                i = (i + 1);
            };
            Tracer.out("category buttons setup done");
            this.view.launch_btn.buttonMode = true;
            this.view.launch_btn.addEventListener(MouseEvent.CLICK, this.click_launch, false, 0, true);
            if (UserData.getInstance().has_active_boutique)
            {
                this.view.launch_btn.launch_txt.visible = false;
            } else
            {
                this.view.launch_btn.share_txt.visible = false;
                this.view.launch_btn.addEventListener(MouseEvent.ROLL_OVER, this.launch_rollover, false, 0, true);
                this.view.launch_btn.addEventListener(MouseEvent.ROLL_OUT, this.launch_rollout, false, 0, true);
            };
            this.view.prev_btn.buttonMode = true;
            this.view.prev_btn.addEventListener(MouseEvent.CLICK, this.click_prev, false, 0, true);
            this.view.prev_btn.visible = false;
            this.view.next_btn.buttonMode = true;
            this.view.next_btn.addEventListener(MouseEvent.CLICK, this.click_next, false, 0, true);
            this.view.camera_btn.stop();
            this.view.camera_btn.buttonMode = true;
            this.view.camera_btn.addEventListener(MouseEvent.CLICK, this.click_camera, false, 0, true);
            this.view.reset_btn.buttonMode = true;
            this.view.reset_btn.addEventListener(MouseEvent.CLICK, this.click_reset, false, 0, true);
        }
        public function load_data(){
            this.current_count = 0;
            this.total_data = 0;
            this.categories = [];
            this.category_data = null;
            this.subcategory_filter = null;
            this.current_category = 8;
            DataManager.getInstance().load_decor_category(this.current_category, this.loaded_decor);
            this.current_btn = this.view.walls_btn;
            this.current_btn.icon.gotoAndStop(2);
        }
        public function loaded_decor(_arg1:Object):void{
            var _local2:Decor;
            var _local4:int;
            Tracer.out(("loaded_decor: received " + Json.encode(_arg1)));
            var _local3:Array = _arg1.decors;
            this.category_data = new Vector.<Decor>();
            this.total_data = _local3.length;
            while (_local4 < this.total_data)
            {
                _local2 = Decor.parseServerData(_local3[_local4]);
                if (MyBoutique.getInstance().boutique.decors[_local2.id] != null)
                {
                    MyBoutique.getInstance().boutique.decors[_local2.id].addPurchaseData(_local2);
                    _local2 = MyBoutique.getInstance().boutique.decors[_local2.id];
                };
                if (!(((_local2.available == false)) && ((_local2.owned == false))))
                {
                    if (!((_local2.hasRestriction(Constants.RESTRICTION_HIDDEN)) && ((_local2.owned == false))))
                    {
                        this.category_data.push(_local2);
                    };
                };
                _local4++;
            };
            this.categories[this.current_category] = this.category_data;
            this.set_category();
        }
        public function update_decor_counts(_arg1:Decor){
            Tracer.out("DecorBrowserController > update_decor_counts");
            Tracer.out((" decor.decorsPlaced = " + _arg1.decorsPlaced));
            var _local2:int = DecorCategories.category_id_for_name(_arg1.category);
            if (this.current_category == _local2)
            {
                this.load_page();
            };
        }
        public function decor_returned(_arg1:UserDecor){
            this.show_plus_one(_arg1);
        }
        public function show_plus_one(_arg1:UserDecor){
            var _local2:DecorBrowserSprite;
            var _local5:int;
            var _local3:Sprite = new PlusOne();
            var _local4:int = this.view.swfContainer.numChildren;
            while (_local5 < _local4)
            {
                _local2 = this.view.swfContainer.getChildAt(_local5);
                if (_local2.data.id == _arg1.decor.id)
                {
                    _local3.x = ((this.view.swfContainer.x + ((SWF_CONTAINER_SIZE + SWF_CONTAINER_SPACER) * _local5)) + (SWF_CONTAINER_SIZE / 2));
                    _local3.y = (this.view.swfContainer.y + (SWF_CONTAINER_SIZE / 2));
                    this.view.addChild(_local3);
                    return;
                };
                _local5++;
            };
            var _local6:MovieClip = this.view[(_arg1.decor.category + "_btn")];
            _local6.addChild(_local3);
        }
        public function check_show_browser_tip(){
            if (Tracker.first_time_my_boutique_decor_browser_interaction)
            {
                FirstVisitEventHandler.getInstance().listen_interaction(this, EVENT_BROWSER_INTERACTION, this.did_interact);
                this.view.tip_browser.visible = true;
            };
        }
        public function hide_browser_tip(){
            this.view.tip_browser.visible = false;
        }
        public function show_launch_exclamation(){
            this.view.launch_btn.tip_exclamation.visible = true;
        }
        public function update_launch_btn_after_launch(){
            this.view.launch_btn.tip_exclamation.visible = false;
            if (this.view.launch_btn.share_txt.visible == false)
            {
                this.view.launch_btn.share_txt.visible = true;
                this.view.launch_btn.launch_txt.visible = false;
                this.view.launch_btn.removeEventListener(MouseEvent.ROLL_OVER, this.launch_rollover);
                this.view.launch_btn.removeEventListener(MouseEvent.ROLL_OUT, this.launch_rollout);
                this.view.launch_tip.visible = false;
            };
        }
        public function check_decor_place_tip(_arg1=null){
            Tracer.out("check_decor_place_tip");
            if (Tracker.first_time_my_boutique_place_decor)
            {
                Util.fadeIn(this.view.tip_drag);
            };
        }
        public function hide_drag_tip(_arg1=null){
            Tracer.out("hide_drag_tip");
            if (this.ignore_hide_decor_place_tip)
            {
                Tracer.out("ignore flag is on, not hiding");
                this.ignore_hide_decor_place_tip = false;
                return;
            };
            Util.fadeOut(this.view.tip_drag);
        }
        function click_model(_arg1=null){
            this.check_hide_closet_tip();
            MyBoutique.getInstance().select_model();
            if (Tracker.first_time_my_boutique_place_decor)
            {
                if (this.view.tip_drag.visible)
                {
                    this.hide_drag_tip();
                };
            };
        }
        function set_category(){
            var mostOwnedFirst:Function;
            var subcat_data:Vector.<Decor>;
            var l:int;
            var i:int;
            mostOwnedFirst = function (_arg1:Decor, _arg2:Decor):Number{
                var _local3:int;
                var _local4:int;
                if (((_arg1.owned) && ((_arg2.owned == false))))
                {
                    return (-1);
                };
                if ((((_arg1.owned == false)) && (_arg2.owned)))
                {
                    return (1);
                };
                if (((_arg1.owned) && (_arg2.owned)))
                {
                    _local3 = _arg1.decorsAvailable;
                    _local4 = _arg2.decorsAvailable;
                    if (_local3 > _local4)
                    {
                        return (-1);
                    };
                    if (_local4 > _local3)
                    {
                        return (1);
                    };
                };
                if (_arg1.id > _arg2.id)
                {
                    return (-1);
                };
                return (1);
            };
            Tracer.out("set_category");
            this.category_data = this.categories[this.current_category];
            if (this.subcategory_filter)
            {
                Tracer.out(("filtering for " + this.subcategory_filter));
                subcat_data = new Vector.<Decor>();
                l = this.category_data.length;
                i = 0;
                while (i < l)
                {
                    if (this.category_data[i].subcategory == this.subcategory_filter)
                    {
                        subcat_data.push(this.category_data[i]);
                    };
                    i = (i + 1);
                };
                this.category_data = subcat_data;
            };
            this.category_data.sort(mostOwnedFirst);
            this.current_count = 0;
            this.total_data = this.category_data.length;
            Tracer.out(("total_data: " + this.total_data));
            this.load_page();
        }
        function category_roll_over(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget.parent as MovieClip);
            _local2.tip.visible = true;
        }
        function category_roll_out(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget.parent as MovieClip);
            _local2.tip.visible = false;
        }
        function click_category(_arg1:MouseEvent){
            var _local2:MovieClip = (_arg1.currentTarget.parent as MovieClip);
            this.subcategory_filter = null;
            this.update_category_btn(_local2);
            if (_local2.subcat)
            {
                _local2.subcat.visible = false;
            };
            dispatchEvent(new Event(EVENT_BROWSER_INTERACTION));
        }
        function update_category_btn(_arg1:MovieClip){
            this.current_btn.icon.gotoAndStop(1);
            this.current_btn = _arg1;
            this.current_btn.icon.gotoAndStop(2);
            this.current_category = _arg1.categoryId;
            if (this.categories[this.current_category] == null)
            {
                DataManager.getInstance().load_decor_category(_arg1.categoryId, this.loaded_decor);
            } else
            {
                this.set_category();
            };
            DecorManager.getInstance().check_close_model_ui();
            if (Tracker.first_time_my_boutique_place_decor)
            {
                if (this.view.tip_drag.visible)
                {
                    this.hide_drag_tip();
                };
            };
        }
        function click_subcategory(_arg1:MouseEvent){
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            Tracer.out(("click_subcategory: " + _local2.name));
            this.subcategory_filter = _local2.name.split("_btn").join("");
            var _local3:MovieClip = this.view[(_local2.categoryName + "_btn")];
            this.update_category_btn(_local3);
            _local2.parent.visible = false;
            dispatchEvent(new Event(EVENT_BROWSER_INTERACTION));
        }
        function rollover_category(_arg1:MouseEvent){
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            _local2.subcat.visible = true;
        }
        function rollout_category(_arg1:MouseEvent){
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            _local2.subcat.visible = false;
        }
        function load_page(){
            var _local1:int;
            var _local2:Sprite;
            var _local3:URLRequest;
            var _local4:Loader;
            var _local5:Decor;
            var _local6:DecorBrowserSprite;
            var _local7:int;
            this.clean_swf_container();
            this.view.prev_btn.visible = (this.current_count > 0);
            this.view.next_btn.visible = ((this.current_count + ITEMS_PER_PAGE) < this.total_data);
            var _local8:int = Math.min((this.current_count + ITEMS_PER_PAGE), this.total_data);
            Tracer.out(("load_page: max is " + _local8));
            _local1 = this.current_count;
            while (_local1 < _local8)
            {
                _local2 = new Sprite();
                _local5 = this.category_data[_local1];
                _local6 = new DecorBrowserSprite(_local5);
                _local6.x = _local7;
                _local6.loadAsset();
                if ((((this.current_category == 8)) || ((this.current_category == 1))))
                {
                    _local6.addEventListener(MouseEvent.ROLL_OVER, this.rollover_handler, false, 0, true);
                    _local6.addEventListener(MouseEvent.ROLL_OUT, this.rollout_handler, false, 0, true);
                    _local6.addEventListener(MouseEvent.CLICK, this.click_wall_floor, false, 0, true);
                } else
                {
                    _local6.addEventListener(MouseEvent.MOUSE_DOWN, this.mouse_down_handler, false, 0, true);
                    if (Tracker.first_time_my_boutique_place_decor)
                    {
                        _local6.addEventListener(MouseEvent.ROLL_OVER, this.check_decor_place_tip, false, 0, true);
                        _local6.addEventListener(MouseEvent.ROLL_OUT, this.hide_drag_tip, false, 0, true);
                    };
                };
                _local7 = (_local7 + (SWF_CONTAINER_SIZE + SWF_CONTAINER_SPACER));
                this.view.swfContainer.addChild(_local6);
                _local1++;
            };
        }
        function click_next(_arg1:MouseEvent){
            this.current_count = (this.current_count + ITEMS_PER_PAGE);
            this.load_page();
            if (Tracker.first_time_my_boutique_place_decor)
            {
                if (this.view.tip_drag.visible)
                {
                    this.hide_drag_tip();
                };
            };
            dispatchEvent(new Event(EVENT_BROWSER_INTERACTION));
        }
        function click_prev(_arg1:MouseEvent){
            this.current_count = (this.current_count - ITEMS_PER_PAGE);
            this.load_page();
            if (Tracker.first_time_my_boutique_place_decor)
            {
                if (this.view.tip_drag.visible)
                {
                    this.hide_drag_tip();
                };
            };
            dispatchEvent(new Event(EVENT_BROWSER_INTERACTION));
        }
        function clean_swf_container(){
            while (this.view.swfContainer.numChildren > 0)
            {
                this.view.swfContainer.removeChildAt(0);
            };
        }
        function mouse_down_handler(_arg1:MouseEvent){
            var _local2:DecorBrowserSprite = (_arg1.currentTarget as DecorBrowserSprite);
            Tracer.out(("DecorBrowserController > MOUSE_DOWN on " + _local2.data.id));
            var _local3:UserDecor = _local2.data.getAvailableUserDecor();
            if (_local3 == null)
            {
                _local3 = _local2.data.newInstance();
            };
            var _local4:DecorViewController = new DecorViewController(_local3);
            _local4.loadAsset();
            this.start_drag_decor(_local4);
            DecorManager.getInstance().check_close_model_ui();
            if (Tracker.first_time_my_boutique_place_decor)
            {
                this.ignore_hide_decor_place_tip = true;
                this.check_decor_place_tip();
            };
            dispatchEvent(new Event(EVENT_BROWSER_INTERACTION));
        }
        public function start_drag_decor(_arg1:DecorViewController){
            this.transforming_decor = _arg1;
            this.dragLayer.addChild(this.transforming_decor);
            this.transforming_decor.x = this.dragLayer.mouseX;
            this.transforming_decor.y = this.dragLayer.mouseY;
            this.transforming_decor.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.update_position, false, 0, true);
            this.transforming_decor.stage.addEventListener(MouseEvent.MOUSE_UP, this.drop, false, 0, true);
            Tracer.out(((("start_transform_decor : new start position is " + this.transforming_decor.x) + ", ") + this.transforming_decor.y));
            this.start_click_x = this.transforming_decor.x;
            this.start_click_y = this.transforming_decor.y;
        }
        public function drop(_arg1:MouseEvent):void{
            this.transforming_decor.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.update_position);
            this.transforming_decor.stage.removeEventListener(MouseEvent.MOUSE_UP, this.drop);
            Tracer.out(((("drop : end position is " + this.transforming_decor.x) + ", ") + this.transforming_decor.y));
            this.dragLayer.removeChild(this.transforming_decor);
            if ((((((((this.transforming_decor.y > 0)) || ((this.transforming_decor.y < -(Constants.GAME_SCREEN_HEIGHT))))) || ((this.transforming_decor.x < 0)))) || ((this.transforming_decor.x > Constants.SCREEN_WIDTH))))
            {
                Tracer.out("checking for click");
                if ((((Math.abs((this.transforming_decor.x - this.start_click_x)) < 3)) && ((Math.abs((this.transforming_decor.y - this.start_click_y)) < 3))))
                {
                    UserData.getInstance().buy_decor(this.transforming_decor.data.decor);
                    if (Tracker.first_time_my_boutique_click_decor)
                    {
                        Tracker.first_time_my_boutique_click_decor = false;
                        Tracker.track(Tracker.CLICK_DECOR, Tracker.FIRST_TIME_MY_BOUTIQUE);
                    };
                };
                this.transforming_decor = null;
            } else
            {
                if (Tracker.first_time_my_boutique_place_decor)
                {
                    if (this.view.tip_drag.visible)
                    {
                        this.hide_drag_tip();
                    };
                };
                this.transforming_decor.y = (this.transforming_decor.y + Constants.GAME_SCREEN_HEIGHT);
                this.transforming_decor.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouse_down_handler);
                DecorManager.getInstance().add_decor(this.transforming_decor);
            };
        }
        function update_position(_arg1:MouseEvent):void{
            this.transforming_decor.x = this.dragLayer.mouseX;
            this.transforming_decor.y = this.dragLayer.mouseY;
        }
        function rollover_handler(_arg1:MouseEvent):void{
            var _local2:DecorBrowserSprite = (_arg1.currentTarget as DecorBrowserSprite);
            if (this.current_category == 1)
            {
                DecorManager.getInstance().preview_floor(_local2.data);
            } else
            {
                DecorManager.getInstance().preview_wall(_local2.data);
            };
            dispatchEvent(new Event(EVENT_BROWSER_INTERACTION));
        }
        function rollout_handler(_arg1:MouseEvent):void{
            if (this.current_category == 1)
            {
                DecorManager.getInstance().remove_floor_preview();
            } else
            {
                DecorManager.getInstance().remove_wall_preview();
            };
        }
        function click_wall_floor(_arg1:MouseEvent):void{
            if (Tracker.first_time_my_boutique_click_wall_floor)
            {
                Tracker.first_time_my_boutique_click_wall_floor = false;
                Tracker.track(Tracker.CLICK_WALL_FLOOR, Tracker.FIRST_TIME_MY_BOUTIQUE);
            };
            Tracer.out("click_wall_floor");
            var _local2:DecorBrowserSprite = (_arg1.currentTarget as DecorBrowserSprite);
            var _local3:Decor = _local2.data;
            Tracer.out(("click_wall_floor: decor is " + _local3.toString()));
            var _local4:UserDecor = _local3.getAvailableUserDecor();
            if (_local4 != null)
            {
                if (_local4.decor.category == DecorCategories.WALLS)
                {
                    DecorManager.getInstance().place_wall(_local4);
                } else
                {
                    if (_local4.decor.category == DecorCategories.FLOORS)
                    {
                        DecorManager.getInstance().place_floor(_local4);
                    };
                };
                return;
            };
            Tracer.out(("click_wall_floor: will call UserData::buy_decor for " + _local3.toString()));
            UserData.getInstance().buy_decor(_local3);
            DecorManager.getInstance().pending_decor_purchase = _local3;
            DecorManager.getInstance().check_close_model_ui();
            dispatchEvent(new Event(EVENT_BROWSER_INTERACTION));
        }
        function click_camera(_arg1:MouseEvent):void{
            MyBoutique.getInstance().show_caption_popup();
        }
        function click_launch(_arg1:MouseEvent):void{
            MyBoutique.getInstance().launch_boutique();
        }
        function launch_rollover(_arg1:MouseEvent):void{
            this.view.launch_tip.visible = true;
        }
        function launch_rollout(_arg1:MouseEvent):void{
            this.view.launch_tip.visible = false;
        }
        function click_reset(_arg1=null):void{
            Pop_Up.getInstance().display_popup(Pop_Up.RESET_MY_BOUTIQUE_CONFIRM, DecorManager.getInstance().reset_boutique_level);
        }
        function check_hide_closet_tip(){
            if (Tracker.first_time_my_boutique_closet)
            {
                this.view.tip_closet.visible = false;
                Tracker.first_time_my_boutique_closet = false;
                Pop_Up.getInstance().display_popup(Pop_Up.MY_BOUTIQUE_DRESS_UP, this.click_dress);
                this.check_show_browser_tip();
            };
        }
        function click_dress(){
            Tracer.out("DecorBrowserController > click_dress");
            Tracker.track(Tracker.CLICK_DRESS, Tracker.FIRST_TIME_MY_BOUTIQUE);
        }
        function did_interact(_arg1:Event):void{
            Tracker.first_time_my_boutique_decor_browser_interaction = false;
            FirstVisitEventHandler.getInstance().remove_listener(this, EVENT_BROWSER_INTERACTION, this.did_interact);
            this.view.tip_browser.visible = false;
            this.view.launch_btn.tip_exclamation.visible = true;
        }

    }
}//package com.viroxoty.fashionista.user_boutique

